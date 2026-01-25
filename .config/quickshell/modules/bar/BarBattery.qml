import QtQuick
import QtQuick.Layouts
import qs.config
import qs.services

RowLayout {
    id: root
    spacing: 4

    // Helper function for battery color based on percentage
    function batteryColor() {
        var pct = BatteryService.percentage;
        if (BatteryService.isCharging) {
            return "#2ECC71";  // Green when charging
        } else if (pct > 80) {
            return "#2ECC71";  // Green
        } else if (pct > 50) {
            return "#4FC3F7";  // Light blue
        } else if (pct > 20) {
            return "#F39C12";  // Amber/Orange
        } else {
            return "#E74C3C";  // Red
        }
    }

    // Charging indicator with animation
    Text {
        id: chargingBolt
        text: "\uf0e7"  // Lightning bolt
        font.pixelSize: Config.font_xxs
        font.family: "Symbols Nerd Font"
        color: root.batteryColor()
        visible: BatteryService.isCharging

        SequentialAnimation on opacity {
            running: chargingBolt.visible
            loops: Animation.Infinite
            NumberAnimation { to: 0.3; duration: 1000 }
            NumberAnimation { to: 1.0; duration: 1000 }
        }
    }

    // Battery icon based on level
    Text {
        id: batteryIcon
        text: {
            var pct = BatteryService.percentage;
            if (BatteryService.isCharging) {
                return "\udb80\udc84";  // Battery charging
            } else if (pct >= 90) {
                return "\udb80\udc79";  // Full
            } else if (pct >= 70) {
                return "\udb80\udc82";  // 70%
            } else if (pct >= 50) {
                return "\udb80\udc80";  // 50%
            } else if (pct >= 30) {
                return "\udb80\udc7e";  // 30%
            } else if (pct >= 10) {
                return "\udb80\udc7c";  // Low
            } else {
                return "\udb80\udc7a";  // Critical
            }
        }
        font.pixelSize: Config.font_sm
        font.family: "Symbols Nerd Font"
        color: root.batteryColor()

        // Critical battery pulsing
        SequentialAnimation on opacity {
            running: BatteryService.percentage <= 10 && !BatteryService.isCharging
            loops: Animation.Infinite
            NumberAnimation { to: 0.3; duration: 500 }
            NumberAnimation { to: 1.0; duration: 500 }
        }
    }

    // Percentage text
    Text {
        text: BatteryService.percentage + "%"
        font.pixelSize: Config.font_xs
        font.weight: 600
        color: root.batteryColor()

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }
}
