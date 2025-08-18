pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property int volumeIn: {
        const source = Pipewire.defaultAudioSource;
        source ? Math.round(source.audio.volume * 100) : 0;
    }
    readonly property int volumeOut: {
        const source = Pipewire.defaultAudioSink;
        source ? Math.round(source.audio.volume * 100) : 0;
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSource, Pipewire.defaultAudioSink]
    }
}
