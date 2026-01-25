pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real brightness: 50
    property real maxBrightness: 100

    // Get current brightness on startup
    Component.onCompleted: {
        getMaxBrightness.running = true;
    }

    // Periodic refresh
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: getBrightness.running = true
    }

    Process {
        id: getMaxBrightness
        command: ["brightnessctl", "max"]
        stdout: SplitParser {
            onRead: function(line) {
                var val = parseInt(line.trim());
                if (!isNaN(val) && val > 0) {
                    root.maxBrightness = val;
                    getBrightness.running = true;
                }
            }
        }
    }

    Process {
        id: getBrightness
        command: ["brightnessctl", "get"]
        stdout: SplitParser {
            onRead: function(line) {
                var val = parseInt(line.trim());
                if (!isNaN(val)) {
                    root.brightness = (val / root.maxBrightness) * 100;
                }
            }
        }
    }

    Process {
        id: setBrightness
        property string brightnessArg: ""
        command: ["brightnessctl", "set", brightnessArg]
        onExited: getBrightness.running = true
    }

    function setBrightnessValue(value) {
        var clamped = Math.max(1, Math.min(100, value));
        setBrightness.brightnessArg = Math.round(clamped) + "%";
        setBrightness.running = true;
    }

    function adjustBrightness(delta) {
        setBrightnessValue(root.brightness + delta);
    }
}
