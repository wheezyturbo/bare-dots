pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property var workspaces: []
    property int focusedWorkspaceId: -1

    Component.onCompleted: {
        refreshWorkspaces();
    }

    // Periodic refresh
    Timer {
        interval: 500
        running: true
        repeat: true
        onTriggered: refreshWorkspaces()
    }

    Process {
        id: getWorkspaces
        command: ["niri", "msg", "--json", "workspaces"]
        stdout: SplitParser {
            splitMarker: ""
            onRead: function(data) {
                try {
                    var parsed = JSON.parse(data);
                    if (Array.isArray(parsed)) {
                        // Sort by idx
                        parsed.sort(function(a, b) {
                            return a.idx - b.idx;
                        });
                        root.workspaces = parsed;

                        // Find focused workspace
                        for (var i = 0; i < parsed.length; i++) {
                            if (parsed[i].is_focused) {
                                root.focusedWorkspaceId = parsed[i].id;
                                break;
                            }
                        }
                    }
                } catch (e) {
                    console.warn("Failed to parse workspaces:", e);
                }
            }
        }
    }

    Process {
        id: focusWorkspace
        property int targetIdx: 1
        command: ["niri", "msg", "action", "focus-workspace", String(targetIdx)]
        onExited: refreshWorkspaces()
    }

    function refreshWorkspaces() {
        getWorkspaces.running = true;
    }

    function focusWorkspaceByIdx(idx) {
        focusWorkspace.targetIdx = idx;
        focusWorkspace.running = true;
    }
}
