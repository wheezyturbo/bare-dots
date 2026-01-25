pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property int percentage: 0
    property string status: "Unknown"  // Charging, Discharging, Full, Not charging, Unknown
    property bool isCharging: status === "Charging"
    property bool isDischarging: status === "Discharging"
    property bool isFull: status === "Full"
    property bool isCritical: percentage <= 10 && isDischarging
    property bool isLow: percentage <= 20 && isDischarging

    property string batteryPath: "/sys/class/power_supply/BAT1"

    Component.onCompleted: {
        detectBattery();
    }

    Timer {
        interval: 10000  // Update every 10 seconds
        running: true
        repeat: true
        onTriggered: refreshBattery()
    }

    // Detect battery path
    Process {
        id: detectBatteryProcess
        command: ["sh", "-c", "ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -1"]
        stdout: SplitParser {
            onRead: function(line) {
                var path = line.trim();
                if (path.length > 0) {
                    root.batteryPath = path;
                    capacityFile.path = path + "/capacity";
                    statusFile.path = path + "/status";
                    root.refreshBattery();
                }
            }
        }
    }

    FileView {
        id: capacityFile
        path: root.batteryPath + "/capacity"
        blockLoading: true
    }

    FileView {
        id: statusFile
        path: root.batteryPath + "/status"
        blockLoading: true
    }

    function detectBattery() {
        detectBatteryProcess.running = true;
    }

    function refreshBattery() {
        updateCapacity();
        updateStatus();
    }

    function updateCapacity() {
        try {
            capacityFile.reload();
            var text = capacityFile.text().trim();
            var val = parseInt(text);
            if (!isNaN(val)) {
                root.percentage = val;
            }
        } catch (e) {
            console.warn("Failed to read battery capacity:", e);
        }
    }

    function updateStatus() {
        try {
            statusFile.reload();
            root.status = statusFile.text().trim();
        } catch (e) {
            root.status = "Unknown";
        }
    }
}
