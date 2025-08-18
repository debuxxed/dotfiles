pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real ramUsage: 0
    property real swapUsage: 0

    FileView {
        id: meminfoFile
        path: "/proc/meminfo"
        watchChanges: true
        onFileChanged: {
            root.parse(text);
        }
    }

    function update() {
        meminfoFile.reload();
        parse(meminfoFile.text());
    }

    // Parses memory and swap usage
    function parse(text) {
        const memoryTotal = parseInt(text.match(/MemTotal: *(\d+)/)?.[1] ?? 1);
        const memoryFree = parseInt(text.match(/MemAvailable: *(\d+)/)?.[1] ?? 0);
        root.ramUsage = (memoryTotal - memoryFree) / memoryTotal;

        const swapTotal = parseInt(text.match(/SwapTotal: *(\d+)/)?.[1] ?? 1);
        const swapFree = parseInt(text.match(/SwapFree: *(\d+)/)?.[1] ?? 0);
        root.swapUsage = (swapTotal - swapFree) / swapTotal;
    }
}
