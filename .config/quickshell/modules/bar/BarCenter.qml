import QtQuick
import QtQuick.Layouts
import qs.config

Item {
    id: root
    Layout.fillWidth: true
    Layout.preferredHeight: Config.bar_height

    RowLayout {
        anchors.centerIn: parent
        spacing: Config.spacing_base

        BarWorkspaces {}
    }
}
