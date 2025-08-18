pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import qs.services
import qs.config

PanelWindow {
    id: root

    anchors {
        top: true
        left: true
        right: true
    }
    implicitHeight: UIConfig.barHeight
    color: Colors.background

    property real spacing: UIConfig.barSpacing

    Timer {
        interval: SystemConfig.pollInterval
        running: true
        repeat: true
        onTriggered: {
            Cpu.update();
            Mem.update();
            Gpu.update();
            Disk.update();
        }
    }

    RowLayout {
        anchors.left: parent.left
        spacing: root.spacing

        Prefixed {
            prefix: ">"
            RowLayout {
                spacing: 0

                BarText {
                    text: "Ψ"

                    font.pointSize: 14
                }
                BarText {
                    text: {
                        const cpu = Math.round(Cpu.usage * 100);
                        const mem = Math.round(Mem.ramUsage * 100);
                        const swap = Math.round(Mem.swapUsage * 100);
                        `: [ L:${cpu}%  M:${mem}%  S:${swap}% ]`;
                    }
                }
            }
        }

        Prefixed {
            prefix: ">"
            BarText {
                text: `DSK: [ ${Disk.usage}% ]`
            }
        }

        Prefixed {
            prefix: ">"
            BarText {
                text: `GPU: [ L:${Gpu.usage}  M:${Gpu.vramUsage} ]`
            }
        }

        Prefixed {
            prefix: ">"
            BarText {
                text: {
                    const u = Network.uploadBandwidth.toFixed(2);
                    const d = Network.downloadBandwidth.toFixed(2);
                    `WIRED: [ ${u} MB  ${d} MB ]`;
                }
            }
        }
    }

    RowLayout {
        anchors.right: parent.right
        spacing: root.spacing

        Prefixed {
            prefix: "<"
            BarText {
                text: `VOL: [ I: ${Audio.volumeIn}%  O: ${Audio.volumeOut}% ]`
            }
        }

        Prefixed {
            prefix: "<"
            RowLayout {
                spacing: 4

                BarText {
                    text: `字`

                    font.pointSize: 10
                }
                BarText {
                    text: `${Hyprland.kbLayout}`
                }
            }
        }

        Prefixed {
            prefix: "<"
            BarText {
                text: `LAYER:` + Hyprland.workspaceNum
            }
        }

        Prefixed {
            prefix: "<"
            BarText {
                text: Time.time
            }
        }

        RowLayout {
            spacing: 0

            Repeater {
                model: SystemTray.items

                TrayItem {
                    barHeight: root.height
                }
            }
        }
    }
}
