import QtQuick
import QtQuick.Layouts
import qs.config
import qs.services

RowLayout {
    id: root
    spacing: Config.spacing_md
    Layout.alignment: Qt.AlignVCenter

    // ═══════════════════════════════════════════════════════════════════════
    // Helper Functions
    // ═══════════════════════════════════════════════════════════════════════
    
    function formatPercentage(value) {
        if (!isFinite(value))
            return "--";
        return Math.round(value) + "%";
    }

    function formatSpeed(bytesPerSecond) {
        if (!isFinite(bytesPerSecond) || bytesPerSecond < 0)
            return "0.00";
        var mbps = bytesPerSecond / (1024 * 1024);
        return mbps.toFixed(2);
    }
    
    function formatSpeedDetailed(bytesPerSecond) {
        if (!isFinite(bytesPerSecond) || bytesPerSecond < 0)
            return "0 B/s";
        if (bytesPerSecond < 1024)
            return bytesPerSecond.toFixed(0) + " B/s";
        if (bytesPerSecond < 1024 * 1024)
            return (bytesPerSecond / 1024).toFixed(1) + " KB/s";
        return (bytesPerSecond / (1024 * 1024)).toFixed(2) + " MB/s";
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
    
    function tempColor(value) {
        if (!Config.colorize_system_stats || !isFinite(value))
            return Config.color_foreground;
        if (value < 50)
            return "#4FC3F7";  // cool
        if (value < 70)
            return "#2ECC71";  // warm
        if (value < 85)
            return "#F1C40F";  // hot
        return "#E74C3C";      // critical
    }
    
    function getUsageStatus(value) {
        if (value < 40) return "Low";
        if (value < 70) return "Normal";
        if (value < 85) return "High";
        return "Critical";
    }
    
    function getTempStatus(value) {
        if (value < 50) return "Cool";
        if (value < 70) return "Normal";
        if (value < 85) return "Warm";
        return "Hot!";
    }

    // ═══════════════════════════════════════════════════════════════════════
    // Reusable Tooltip Component (simplified for compatibility)
    // ═══════════════════════════════════════════════════════════════════════
    
    component StatsTooltip: Rectangle {
        id: tooltipRoot
        
        property string title: "Stats"
        property string icon: ""
        property string mainValue: ""
        property color accentColor: Config.color_primary
        property var details: []
        property string footer: ""
        
        implicitWidth: Math.max(180, tooltipContent.implicitWidth + 28)
        implicitHeight: tooltipContent.implicitHeight + 24
        
        // Glassmorphic dark background
        color: "#0F0F14"
        border.color: Qt.rgba(1, 1, 1, 0.1)
        border.width: 1
        radius: 8
        
        // Position above parent
        x: parent ? (parent.width - width) / 2 : 0
        y: parent ? -height - 12 : 0
        z: 1000
        
        // Animation
        opacity: visible ? 1 : 0
        scale: visible ? 1 : 0.92
        transformOrigin: Item.Bottom
        
        Behavior on opacity {
            NumberAnimation { duration: 120; easing.type: Easing.OutQuad }
        }
        Behavior on scale {
            NumberAnimation { duration: 120; easing.type: Easing.OutQuad }
        }
        
        // Accent line at top
        Rectangle {
            width: parent.width - 16
            height: 2
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 1
            radius: 1
            color: tooltipRoot.accentColor
        }
        
        ColumnLayout {
            id: tooltipContent
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8
            
            // Header
            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                
                Text {
                    visible: tooltipRoot.icon !== ""
                    text: tooltipRoot.icon
                    color: tooltipRoot.accentColor
                    font.pixelSize: 16
                    font.family: "Symbols Nerd Font"
                }
                
                Text {
                    text: tooltipRoot.title
                    color: Qt.rgba(1, 1, 1, 0.6)
                    font.pixelSize: Config.font_sm
                    font.weight: Font.Medium
                    Layout.fillWidth: true
                }
                
                Text {
                    visible: tooltipRoot.mainValue !== ""
                    text: tooltipRoot.mainValue
                    color: tooltipRoot.accentColor
                    font.pixelSize: Config.font_base
                    font.weight: Font.Bold
                }
            }
            
            // Separator
            Rectangle {
                visible: tooltipRoot.details.length > 0
                Layout.fillWidth: true
                height: 1
                color: Qt.rgba(1, 1, 1, 0.08)
            }
            
            // Details
            Repeater {
                model: tooltipRoot.details
                
                delegate: RowLayout {
                    Layout.fillWidth: true
                    spacing: 6
                    
                    Text {
                        text: modelData.icon || "•"
                        color: modelData.color || Qt.rgba(1, 1, 1, 0.4)
                        font.pixelSize: Config.font_xs
                        font.family: modelData.icon ? "Symbols Nerd Font" : undefined
                    }
                    
                    Text {
                        text: modelData.label
                        color: Qt.rgba(1, 1, 1, 0.45)
                        font.pixelSize: Config.font_xs
                        Layout.fillWidth: true
                    }
                    
                    Text {
                        text: modelData.value
                        color: modelData.color || Config.color_foreground
                        font.pixelSize: Config.font_xs
                        font.weight: Font.DemiBold
                    }
                }
            }
            
            // Footer
            Text {
                visible: tooltipRoot.footer !== ""
                text: tooltipRoot.footer
                color: Qt.rgba(1, 1, 1, 0.3)
                font.pixelSize: Config.font_xxs
                font.italic: true
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignCenter
                Layout.topMargin: 2
            }
        }
        
        // Arrow pointer
        Rectangle {
            width: 10
            height: 10
            rotation: 45
            color: "#0F0F14"
            border.color: Qt.rgba(1, 1, 1, 0.1)
            border.width: 1
            anchors.bottom: parent.bottom
            anchors.bottomMargin: -5
            anchors.horizontalCenter: parent.horizontalCenter
            z: -1
        }
    }

    // ═══════════════════════════════════════════════════════════════════════
    // CPU Usage
    // ═══════════════════════════════════════════════════════════════════════
    
    Item {
        id: cpuItem
        implicitWidth: cpuText.implicitWidth
        implicitHeight: cpuText.implicitHeight
        
        Text {
            id: cpuText
            text: "󰻠 " + root.formatPercentage(SystemStats.cpuUsage)
            color: root.usageColor(SystemStats.cpuUsage)
            font.pointSize: Config.font_xs
            font.weight: 600
        }
        
        MouseArea {
            id: cpuMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
        }
        
        StatsTooltip {
            visible: cpuMouse.containsMouse
            title: "CPU Usage"
            icon: "󰻠"
            mainValue: root.formatPercentage(SystemStats.cpuUsage)
            accentColor: root.usageColor(SystemStats.cpuUsage)
            details: [
                { icon: "󰓅", label: "Status", value: root.getUsageStatus(SystemStats.cpuUsage), color: root.usageColor(SystemStats.cpuUsage) },
                { icon: "󰔏", label: "Temperature", value: SystemStats.temp.toFixed(1) + "°C", color: root.tempColor(SystemStats.temp) }
            ]
            footer: "Processor utilization"
        }
    }

    // ═══════════════════════════════════════════════════════════════════════
    // RAM Usage
    // ═══════════════════════════════════════════════════════════════════════
    
    Item {
        id: ramItem
        implicitWidth: ramText.implicitWidth
        implicitHeight: ramText.implicitHeight
        
        Text {
            id: ramText
            text: "󰍛 " + root.formatPercentage(SystemStats.memoryUsage)
            color: root.usageColor(SystemStats.memoryUsage)
            font.pointSize: Config.font_xs
            font.weight: 600
        }
        
        MouseArea {
            id: ramMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
        }
        
        StatsTooltip {
            visible: ramMouse.containsMouse
            title: "Memory Usage"
            icon: "󰍛"
            mainValue: root.formatPercentage(SystemStats.memoryUsage)
            accentColor: root.usageColor(SystemStats.memoryUsage)
            details: [
                { icon: "󰓅", label: "Status", value: root.getUsageStatus(SystemStats.memoryUsage), color: root.usageColor(SystemStats.memoryUsage) }
            ]
            footer: "RAM utilization"
        }
    }

    // ═══════════════════════════════════════════════════════════════════════
    // Temperature
    // ═══════════════════════════════════════════════════════════════════════
    
    Item {
        id: tempItem
        implicitWidth: tempText.implicitWidth
        implicitHeight: tempText.implicitHeight
        
        Text {
            id: tempText
            text: "󰔏 " + SystemStats.temp.toFixed(0) + "°"
            color: root.tempColor(SystemStats.temp)
            font.pointSize: Config.font_xs
            font.weight: 600
        }
        
        MouseArea {
            id: tempMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
        }
        
        StatsTooltip {
            visible: tempMouse.containsMouse
            title: "CPU Temperature"
            icon: "󰔏"
            mainValue: SystemStats.temp.toFixed(1) + "°C"
            accentColor: root.tempColor(SystemStats.temp)
            details: [
                { icon: "󰓅", label: "Status", value: root.getTempStatus(SystemStats.temp), color: root.tempColor(SystemStats.temp) }
            ]
            footer: "Core package temperature"
        }
    }

    // ═══════════════════════════════════════════════════════════════════════
    // GPU Usage
    // ═══════════════════════════════════════════════════════════════════════
    
    Item {
        id: gpuItem
        visible: SystemStats.gpuAvailable
        implicitWidth: gpuText.implicitWidth
        implicitHeight: gpuText.implicitHeight
        
        Text {
            id: gpuText
            text: (SystemStats.gpuType === "nvidia" ? "󰢮 " : "󰾲 ") + root.formatPercentage(SystemStats.gpuUsage)
            color: root.usageColor(SystemStats.gpuUsage)
            font.pointSize: Config.font_xs
            font.weight: 600
        }
        
        MouseArea {
            id: gpuMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
        }
        
        StatsTooltip {
            visible: gpuMouse.containsMouse
            title: SystemStats.gpuType === "nvidia" ? "NVIDIA GPU" : "Intel Graphics"
            icon: SystemStats.gpuType === "nvidia" ? "󰢮" : "󰾲"
            mainValue: root.formatPercentage(SystemStats.gpuUsage)
            accentColor: root.usageColor(SystemStats.gpuUsage)
            details: SystemStats.gpuType === "nvidia" ? [
                { icon: "󰓅", label: "Status", value: root.getUsageStatus(SystemStats.gpuUsage), color: root.usageColor(SystemStats.gpuUsage) },
                { icon: "󰔏", label: "Temperature", value: SystemStats.gpuTemp + "°C", color: root.tempColor(SystemStats.gpuTemp) }
            ] : [
                { icon: "󰓅", label: "Status", value: root.getUsageStatus(SystemStats.gpuUsage), color: root.usageColor(SystemStats.gpuUsage) },
                { icon: "󰾲", label: "Type", value: "Integrated", color: Config.color_primary }
            ]
            footer: SystemStats.gpuType === "nvidia" ? "Discrete GPU utilization" : "Frequency-based estimate"
        }
    }

    // ═══════════════════════════════════════════════════════════════════════
    // Network Stats
    // ═══════════════════════════════════════════════════════════════════════
    
    Item {
        id: networkItem
        implicitWidth: networkRow.implicitWidth
        implicitHeight: networkRow.implicitHeight
        
        RowLayout {
            id: networkRow
            spacing: Config.spacing_md
            
            Text {
                text: "󰇚 " + root.formatSpeed(SystemStats.downloadSpeed)
                color: Config.color_primary
                font.pointSize: Config.font_xs
                font.weight: 600
            }
            
            Text {
                text: "󰕒 " + root.formatSpeed(SystemStats.uploadSpeed)
                color: Config.color_secondary
                font.pointSize: Config.font_xs
                font.weight: 600
            }
        }
        
        MouseArea {
            id: networkMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
        }
        
        StatsTooltip {
            visible: networkMouse.containsMouse
            title: "Network Activity"
            icon: "󰛳"
            mainValue: ""
            accentColor: Config.color_primary
            details: [
                { icon: "󰇚", label: "Download", value: root.formatSpeedDetailed(SystemStats.downloadSpeed), color: Config.color_primary },
                { icon: "󰕒", label: "Upload", value: root.formatSpeedDetailed(SystemStats.uploadSpeed), color: Config.color_secondary }
            ]
            footer: "Current network throughput"
        }
    }
}
