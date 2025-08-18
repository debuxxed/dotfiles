pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real usage: 0

    FileView {
        id: statFile
        path: "/proc/stat"
        watchChanges: true
        onFileChanged: {
            root.parse(text());
        }
    }

    function update() {
        statFile.reload();
        parse(statFile.text());
    }

    property real prevCpuTotal: 0
    property real prevCpuIdle: 0
    function parse(text) {
        const data = text.match(/^cpu\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/);
        if (!data) {
            return;
        }

        const stats = data.slice(1).map(Number);
        const total = stats.reduce((a, b) => a + b, 0);
        const idle = stats[3];

        const totalDiff = total - root.prevCpuTotal;
        const idleDiff = idle - root.prevCpuIdle;

        root.prevCpuTotal = total;
        root.prevCpuIdle = idle;

        root.usage = totalDiff > 0 ? (1 - idleDiff / totalDiff) : 0;
    }
}
