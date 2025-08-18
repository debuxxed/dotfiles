pragma Singleton

import Quickshell

Singleton {
    readonly property string time: {
        Qt.formatDateTime(clock.date, "ddd_dd.MM.yyyy_hh:mm_t");
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
