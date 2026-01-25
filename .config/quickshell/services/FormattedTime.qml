pragma Singleton

import Quickshell

Singleton {
    id: root
    readonly property string time: {
        Qt.formatDateTime(clock.date, "h:mm AP     dd MMM yyyy");
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
