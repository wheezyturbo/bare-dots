import QtQuick
import QtQuick.Layouts
import qs.config
import qs.services

Item {
    id: root
    implicitWidth: volumeRow.implicitWidth
    implicitHeight: volumeRow.implicitHeight

    property bool popupVisible: false

    RowLayout {
        id: volumeRow
        spacing: 4

        Text {
            id: volumeIcon
            text: {
                if (VolumeService.muted || VolumeService.volume === 0) {
                    return "\ufc5d";  // Muted
                } else if (VolumeService.volume < 30) {
                    return "\uf026";  // Low
                } else if (VolumeService.volume < 70) {
                    return "\uf027";  // Medium
                } else {
                    return "\uf028";  // High
                }
            }
            color: VolumeService.muted ? Config.color_muted_foreground : Config.color_foreground
            font.pixelSize: Config.font_sm
            font.family: "Symbols Nerd Font"
        }

        Text {
            text: Math.round(VolumeService.volume) + "%"
            color: VolumeService.muted ? Config.color_muted_foreground : Config.color_foreground
            font.pixelSize: Config.font_xs
            font.weight: 600
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: function(mouse) {
            if (mouse.button === Qt.LeftButton) {
                VolumeService.toggleMuted();
            } else if (mouse.button === Qt.RightButton) {
                root.popupVisible = !root.popupVisible;
            }
        }

        onWheel: function(wheel) {
            var delta = wheel.angleDelta.y > 0 ? 5 : -5;
            VolumeService.adjustVolume(delta);
        }

        onEntered: cursorShape = Qt.PointingHandCursor
    }

    // Popup slider
    Rectangle {
        id: popup
        visible: root.popupVisible
        width: 200
        height: 60
        color: Config.color_background
        border.color: Config.color_border
        border.width: 1
        radius: Config.radius

        anchors.bottom: parent.top
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter

        // Close popup when clicking outside
        Timer {
            id: closeTimer
            interval: 3000
            running: popup.visible
            onTriggered: root.popupVisible = false
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            Text {
                text: "Volume: " + Math.round(VolumeService.volume) + "%"
                color: Config.color_foreground
                font.pixelSize: Config.font_sm
                font.weight: 600
                Layout.alignment: Qt.AlignHCenter
            }

            // Slider track
            Rectangle {
                Layout.fillWidth: true
                height: 6
                radius: 3
                color: Config.color_muted_foreground

                Rectangle {
                    width: parent.width * (VolumeService.volume / 100)
                    height: parent.height
                    radius: 3
                    color: VolumeService.muted ? Config.color_muted_foreground : Config.color_primary

                    Behavior on width {
                        NumberAnimation { duration: 100 }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: function(mouse) {
                        var value = (mouse.x / parent.width) * 100;
                        VolumeService.setVolumeValue(value);
                        closeTimer.restart();
                    }
                    onPositionChanged: function(mouse) {
                        if (pressed) {
                            var value = (mouse.x / parent.width) * 100;
                            VolumeService.setVolumeValue(value);
                            closeTimer.restart();
                        }
                    }
                }
            }
        }
    }
}
