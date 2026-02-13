pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property Timer statsTimer: Timer {
        id: timer
        interval: 1000
        running: true
        repeat: true

        property real cpuUsage: 0
        property real memoryUsage: 0
        property real downloadSpeed: 0  // bytes per second
        property real uploadSpeed: 0    // bytes per second
        property real temp: 0
        
        // GPU properties
        property real gpuUsage: 0        // GPU utilization percentage
        property real gpuTemp: 0         // GPU temperature
        property string gpuType: "intel" // "intel" or "nvidia"
        property bool gpuAvailable: false

        onTriggered: root.updateStats()
    }

    readonly property real cpuUsage: statsTimer.cpuUsage
    readonly property real memoryUsage: statsTimer.memoryUsage
    readonly property real downloadSpeed: statsTimer.downloadSpeed
    readonly property real uploadSpeed: statsTimer.uploadSpeed
    readonly property real temp: statsTimer.temp
    
    // GPU readonly properties
    readonly property real gpuUsage: statsTimer.gpuUsage
    readonly property real gpuTemp: statsTimer.gpuTemp
    readonly property string gpuType: statsTimer.gpuType
    readonly property bool gpuAvailable: statsTimer.gpuAvailable

    property double _previousIdle: 0
    property double _previousTotal: 0
    property bool _hasPreviousSample: false

    // Network tracking
    property double _previousRxBytes: 0
    property double _previousTxBytes: 0
    property bool _hasNetworkSample: false

    FileView {
        id: cpuFile
        path: "/proc/stat"
        blockLoading: true
    }

    FileView {
        id: memFile
        path: "/proc/meminfo"
        blockLoading: true
    }

    FileView {
        id: netFile
        path: "/proc/net/dev"
        blockLoading: true
    }
    
    FileView {
      id: tempFile
      path: "/sys/devices/platform/coretemp.0/hwmon/hwmon6/temp1_input"
    }
    
    // Intel GPU frequency files
    FileView {
        id: intelGpuCurFreq
        path: "/sys/class/drm/card1/gt_cur_freq_mhz"
        blockLoading: true
    }
    
    FileView {
        id: intelGpuMaxFreq
        path: "/sys/class/drm/card1/gt_max_freq_mhz"
        blockLoading: true
    }
    
    // NVIDIA GPU monitoring via Process
    property string _nvidiaOutput: ""
    
    Process {
        id: nvidiaProcess
        command: ["nvidia-smi", "--query-gpu=utilization.gpu,temperature.gpu", "--format=csv,noheader,nounits"]
        onExited: function(exitCode, exitStatus) {
            if (exitCode === 0) {
                root._nvidiaOutput = stdout;
            } else {
                root._nvidiaOutput = "";
            }
        }
    }

    Component.onCompleted: updateStats()

    function updateStats() {
        updateCpuStats();
        updateMemoryStats();
        updateNetworkStats();
        updateTempStats();
        updateGpuStats();
    }


    function updateTempStats(){
      var text = readFile(tempFile);

      if (text === undefined || text === null || text.length === 0)
        return

      var temp = Number(text)


      statsTimer.temp = temp/1000


    }

    function updateGpuStats() {
        // First try NVIDIA GPU (if discrete GPU is active)
        nvidiaProcess.running = true;
        
        // Check NVIDIA result from previous cycle
        if (root._nvidiaOutput && root._nvidiaOutput.length > 0) {
            var parts = root._nvidiaOutput.trim().split(",");
            if (parts.length >= 2) {
                var usage = Number(parts[0].trim());
                var temp = Number(parts[1].trim());
                
                if (isFinite(usage) && isFinite(temp)) {
                    statsTimer.gpuUsage = clampPercentage(usage);
                    statsTimer.gpuTemp = temp;
                    statsTimer.gpuType = "nvidia";
                    statsTimer.gpuAvailable = true;
                    return;
                }
            }
        }
        
        // Fallback to Intel GPU frequency-based usage estimation
        var curFreqText = readFile(intelGpuCurFreq);
        var maxFreqText = readFile(intelGpuMaxFreq);
        
        if (curFreqText && maxFreqText) {
            var curFreq = Number(curFreqText.trim());
            var maxFreq = Number(maxFreqText.trim());
            
            if (isFinite(curFreq) && isFinite(maxFreq) && maxFreq > 0) {
                // Calculate usage as percentage of max frequency
                var usage = (curFreq / maxFreq) * 100;
                statsTimer.gpuUsage = clampPercentage(usage);
                statsTimer.gpuTemp = 0; // Intel GPU temp not easily accessible
                statsTimer.gpuType = "intel";
                statsTimer.gpuAvailable = true;
                return;
            }
        }
        
        // No GPU stats available
        statsTimer.gpuAvailable = false;
        statsTimer.gpuUsage = 0;
        statsTimer.gpuTemp = 0;
    }

    function updateCpuStats() {
        var text = readFile(cpuFile);
        if (!text)
            return;

        var lines = text.split("\n");
        var cpuLine = null;
        for (var i = 0; i < lines.length; ++i) {
            if (lines[i].startsWith("cpu ")) {
                cpuLine = lines[i];
                break;
            }
        }

        if (!cpuLine)
            return;

        var parts = cpuLine.trim().split(/\s+/);
        if (parts.length < 8)
            return;

        var user = Number(parts[1]);
        var nice = Number(parts[2]);
        var system = Number(parts[3]);
        var idle = Number(parts[4]);
        var iowait = Number(parts[5]);
        var irq = Number(parts[6]);
        var softirq = Number(parts[7]);
        var steal = parts.length > 8 ? Number(parts[8]) : 0;

        var idleTime = idle + iowait;
        var nonIdleTime = user + nice + system + irq + softirq + steal;
        var totalTime = idleTime + nonIdleTime;

        if (root._hasPreviousSample) {
            var totalDelta = totalTime - root._previousTotal;
            var idleDelta = idleTime - root._previousIdle;

            if (totalDelta > 0) {
                var usage = (totalDelta - idleDelta) / totalDelta * 100;
                statsTimer.cpuUsage = clampPercentage(usage);
            }
        }

        root._previousTotal = totalTime;
        root._previousIdle = idleTime;
        root._hasPreviousSample = true;
    }

    function updateMemoryStats() {
        var text = readFile(memFile);
        if (!text)
            return;

        var lines = text.split("\n");
        var memTotal = NaN;
        var memAvailable = NaN;

        for (var i = 0; i < lines.length; ++i) {
            var line = lines[i];
            if (line.startsWith("MemTotal:")) {
                memTotal = parseMemValue(line);
            } else if (line.startsWith("MemAvailable:")) {
                memAvailable = parseMemValue(line);
            } else if (line.startsWith("MemFree:") && isNaN(memAvailable)) {
                memAvailable = parseMemValue(line);
            }
        }

        if (isFinite(memTotal) && isFinite(memAvailable) && memTotal > 0) {
            var used = memTotal - memAvailable;
            statsTimer.memoryUsage = clampPercentage((used / memTotal) * 100);
        }
    }

    function updateNetworkStats() {
        var text = readFile(netFile);
        if (!text)
            return;

        var lines = text.split("\n");
        var totalRxBytes = 0;
        var totalTxBytes = 0;

        // Skip first two header lines
        for (var i = 2; i < lines.length; ++i) {
            var line = lines[i].trim();
            if (!line)
                continue;

            // Format: "interface: rx_bytes rx_packets ... tx_bytes tx_packets ..."
            var colonIndex = line.indexOf(":");
            if (colonIndex === -1)
                continue;

            var iface = line.substring(0, colonIndex).trim();
            // Skip loopback interface
            if (iface === "lo")
                continue;

            var valuePart = line.substring(colonIndex + 1).trim();
            var parts = valuePart.split(/\s+/);
            if (parts.length < 10)
                continue;

            var rxBytes = Number(parts[0]);
            var txBytes = Number(parts[8]);

            if (isFinite(rxBytes))
                totalRxBytes += rxBytes;
            if (isFinite(txBytes))
                totalTxBytes += txBytes;
        }

        if (root._hasNetworkSample) {
            var rxDelta = totalRxBytes - root._previousRxBytes;
            var txDelta = totalTxBytes - root._previousTxBytes;

            // Speed in bytes per second (timer interval is 1000ms)
            statsTimer.downloadSpeed = rxDelta > 0 ? rxDelta : 0;
            statsTimer.uploadSpeed = txDelta > 0 ? txDelta : 0;
        }

        root._previousRxBytes = totalRxBytes;
        root._previousTxBytes = totalTxBytes;
        root._hasNetworkSample = true;
    }

    function parseMemValue(line) {
        var parts = line.split(":");
        if (parts.length < 2)
            return NaN;

        var valuePart = parts[1].trim().split(/\s+/)[0];
        var value = Number(valuePart);
        return isFinite(value) ? value : NaN;
    }

    function readFile(view) {
        try {
            view.reload();
            return view.text();
        } catch (error) {
            console.warn("Failed to read", view.path, error);
        }
        return "";
    }

    function clampPercentage(value) {
        if (!isFinite(value))
            return 0;
        if (value < 0)
            return 0;
        if (value > 100)
            return 100;
        return value;
    }
}
