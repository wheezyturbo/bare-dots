pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real volume: 50
    property bool muted: false

    // Get current volume on startup
    Component.onCompleted: {
        getVolume.running = true;
    }

    // Periodic refresh
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: getVolume.running = true
    }

    Process {
        id: getVolume
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: SplitParser {
            onRead: function(line) {
                // Format: "Volume: 0.50" or "Volume: 0.50 [MUTED]"
                var match = line.match(/Volume:\s*([\d.]+)/);
                if (match) {
                    root.volume = parseFloat(match[1]) * 100;
                }
                root.muted = line.includes("[MUTED]");
            }
        }
    }

    Process {
        id: setVolume
        property string volumeArg: ""
        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", volumeArg]
        onExited: getVolume.running = true
    }

    Process {
        id: toggleMute
        command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
        onExited: getVolume.running = true
    }

    function setVolumeValue(value) {
        var clamped = Math.max(0, Math.min(100, value));
        setVolume.volumeArg = (clamped / 100).toFixed(2);
        setVolume.running = true;
    }

    function adjustVolume(delta) {
        setVolumeValue(root.volume + delta);
    }

    function toggleMuted() {
        toggleMute.running = true;
    }
}
