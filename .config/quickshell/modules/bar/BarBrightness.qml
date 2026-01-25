import QtQuick
import QtQuick.Layouts
import qs.config
import qs.services

Item {
    id: root
    implicitWidth: brightnessRow.implicitWidth
    implicitHeight: brightnessRow.implicitHeight

    property bool popupVisible: false

    RowLayout {
        id: brightnessRow
        spacing: 4

        Text {
            id: brightnessIcon
            text: {
                if (BrightnessService.brightness < 30) {
                    return "\udb80\udcde";  // Low brightness
                } else if (BrightnessService.brightness < 70) {
                    return "\udb80\udcdf";  // Medium brightness
                } else {
                    return "\udb80\udce0";  // High brightness
                }
            }
            color: Config.color_foreground
            font.pixelSize: Config.font_sm
            font.family: "Symbols Nerd Font"
        }

        Text {
            text: Math.round(BrightnessService.brightness) + "%"
            color: Config.color_foreground
            font.pixelSize: Config.font_xs
            font.weight: 600
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            root.popupVisible = !root.popupVisible;
        }

        onWheel: function(wheel) {
            var delta = wheel.angleDelta.y > 0 ? 5 : -5;
            BrightnessService.adjustBrightness(delta);
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

        // Close popup when idle
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
                text: "Brightness: " + Math.round(BrightnessService.brightness) + "%"
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
                    width: parent.width * (BrightnessService.brightness / 100)
                    height: parent.height
                    radius: 3
                    color: Config.color_yellow

                    Behavior on width {
                        NumberAnimation { duration: 100 }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: function(mouse) {
                        var value = (mouse.x / parent.width) * 100;
                        BrightnessService.setBrightnessValue(value);
                        closeTimer.restart();
                    }
                    onPositionChanged: function(mouse) {
                        if (pressed) {
                            var value = (mouse.x / parent.width) * 100;
                            BrightnessService.setBrightnessValue(value);
                            closeTimer.restart();
                        }
                    }
                }
            }
        }
    }
}
