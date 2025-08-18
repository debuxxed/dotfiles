pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Hyprland
import qs.config

Singleton {
    id: root

    property string workspaceNum: Hyprland.focusedWorkspace?.name ?? "No Workspace"
    property string kbLayout: "No lang"

    // react on all events
    Connections {
        target: Hyprland

        function onRawEvent(event: HyprlandEvent) {
            // Filter out redundant old v1 events for the same thing
            const oldEvents = ["activewindow", "focusedmon", "monitoradded", "createworkspace", "destroyworkspace", "moveworkspace", "activespecial", "movewindow", "windowtitle"];
            if (event.name in oldEvents) {
                return;
            }

            // react on keyboard layout change
            if (event.name == "activelayout") {
                root.kbLayout = event.parse(2)[1];
            }
        }
    }

    // initialize current keyboard layout
    Process {
        running: true
        command: ["sh", "-c", PathConfig.keyboardLayoutScript]
        stdout: StdioCollector {
            onStreamFinished: {
                root.kbLayout = this.text.trim();
            }
        }
    }
}
