pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property real usage

    function update() {
        storage.running = true;
    }

    function parse(text: string) {
        const deviceMap = new Map();

        for (let line of text.split("\n")) {
            line = line.trim();
            if (line === "")
                continue;

            const parts = line.split(/\s+/);
            if (parts.length < 3)
                continue;

            const device = parts[0];
            const used = parseInt(parts[1], 10) || 0;
            const avail = parseInt(parts[2], 10) || 0;

            // Only keep the entry with the largest total space for each device
            const dev = deviceMap.get(device);
            if (!deviceMap.has(device) || (used + avail) > (dev.used + dev.avail)) {
                deviceMap.set(device, {
                    used: used,
                    avail: avail
                });
            }
        }

        let totalUsed = 0;
        let totalAvail = 0;

        for (const [device, stats] of deviceMap) {
            totalUsed += stats.used;
            totalAvail += stats.avail;
        }

        root.usage = Math.round(totalUsed / (totalUsed + totalAvail) * 100);
    }

    Process {
        id: storage

        running: true
        command: ["sh", "-c", "df -B GB | grep '^/dev/' | awk '{print $1, $3, $4}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.parse(text);
            }
        }
    }
}
