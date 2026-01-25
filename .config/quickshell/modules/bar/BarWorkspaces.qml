import QtQuick
import QtQuick.Layouts
import qs.config
import qs.services

RowLayout {
    spacing: Config.spacing_base

    Repeater {
        model: NiriWorkspaces.workspaces

        Rectangle {
            id: button
            required property var modelData
            property bool isHovered: false
            property bool isFocused: modelData.is_focused

            width: 12
            height: 12
            radius: 6

            color: {
                if (isFocused) {
                    return Config.color_foreground;
                }
                if (button.isHovered) {
                    return Config.color_primary;
                }
                return Config.color_transparent;
            }

            border.width: isFocused ? 0 : 1.5
            border.color: {
                if (modelData.is_urgent) {
                    return Config.color_red;
                }
                if (button.isHovered) {
                    return Config.color_primary;
                }
                return Config.color_muted_foreground;
            }

            // Urgent workspace pulsing
            SequentialAnimation on opacity {
                running: modelData.is_urgent && !isFocused
                loops: Animation.Infinite
                NumberAnimation { to: 0.5; duration: 500 }
                NumberAnimation { to: 1.0; duration: 500 }
            }

            // Smooth transitions
            Behavior on color {
                ColorAnimation { duration: 150 }
            }
            Behavior on border.color {
                ColorAnimation { duration: 150 }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    NiriWorkspaces.focusWorkspaceByIdx(modelData.idx);
                }

                onEntered: {
                    if (!button.isFocused) {
                        cursorShape = Qt.PointingHandCursor;
                    }
                    parent.isHovered = true;
                }

                onExited: {
                    parent.isHovered = false;
                }
            }
        }
    }
}
