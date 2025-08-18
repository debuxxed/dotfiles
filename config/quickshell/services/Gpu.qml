pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string usage
    property string vramUsage

    function update() {
        gpuUsage.running = true;
    }

    function parse(text) {
        const gpus = JSON.parse(text);
        root.usage = gpus[0].gpu_util;
        root.vramUsage = gpus[0].mem_util;
    }

    Process {
        id: gpuUsage

        running: true
        command: ["sh", "-c", "nvtop -s"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.parse(this.data);
            }
        }
    }
}
