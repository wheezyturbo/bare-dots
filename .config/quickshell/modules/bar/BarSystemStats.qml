import QtQuick
import QtQuick.Layouts
import qs.config
import qs.services

RowLayout {
    id: root
    spacing: Config.spacing_md
    Layout.alignment: Qt.AlignVCenter

    function formatPercentage(value) {
        if (!isFinite(value))
            return "--";
        return Math.round(value) + "%";
    }

    function formatSpeed(bytesPerSecond) {
        if (!isFinite(bytesPerSecond) || bytesPerSecond < 0)
            return "0.00";
        // Convert to MB/s (1 MB = 1024 * 1024 bytes)
        var mbps = bytesPerSecond / (1024 * 1024);
        return mbps.toFixed(2);
    }

    function usageColor(value) {
        if (!Config.colorize_system_stats || !isFinite(value))
            return Config.color_foreground;

        if (value < 40)
            return "#4FC3F7";  // low - light blue
        if (value < 70)
            return "#2ECC71";  // medium - green
        if (value < 85)
            return "#F1C40F";  // high - yellow
        return "#E74C3C";      // critical - red
    }

    Text {
        text: "C " + root.formatPercentage(SystemStats.cpuUsage)
        color: root.usageColor(SystemStats.cpuUsage)
        font.pointSize: Config.font_xs
        font.weight: 600
    }

    Text {
        text: "R " + root.formatPercentage(SystemStats.memoryUsage)
        color: root.usageColor(SystemStats.memoryUsage)
        font.pointSize: Config.font_xs
        font.weight: 600
    }

    Text {
      text: "T(C) " + SystemStats.temp
      color: root.usageColor(SystemStats.temp)
      font.pointSize: Config.font_xs
      font.weight: 600
    }

    // Network Download Speed
    Text {
        text: "\uf063 " + root.formatSpeed(SystemStats.downloadSpeed) 
        color: Config.color_primary
        font.pointSize: Config.font_xs
        font.weight: 600
    }

    // Network Upload Speed
    Text {
        text: "\uf062 " + root.formatSpeed(SystemStats.uploadSpeed)
        color: Config.color_primary
        font.pointSize: Config.font_xs
        font.weight: 600
    }
}
