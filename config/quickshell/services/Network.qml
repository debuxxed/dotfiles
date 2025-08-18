pragma Singleton

import Quickshell
import Quickshell.Io
import qs.config

Singleton {
    id: root

    property real uploadBandwidth
    property real downloadBandwidth

    Process {
        running: true
        command: [PathConfig.networkBandwidthScript]
        stdout: SplitParser {
            onRead: data => {
                const t = data.split(' ');

                // Convert kbps to Mbps
                root.uploadBandwidth = t[0] * 0.008;
                root.downloadBandwidth = t[1] * 0.008;
            }
        }
        stderr: SplitParser {
            onRead: data => {
                console.log(data);
            }
        }
    }
}
