import qs.config
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick

MouseArea {
    id: root

    required property SystemTrayItem modelData
    required property int barHeight

    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
    implicitWidth: UIConfig.trayIconHitboxWidth
    implicitHeight: barHeight

    onClicked: event => {
        switch (event.button) {
        case Qt.LeftButton:
            modelData.activate();
            break;
        case Qt.RightButton:
            if (modelData.hasMenu) {
                menu.open();
            }
            break;
        case Qt.MiddleButton:
            modelData.secondaryActivate();
            break;
        }
    }

    QsMenuAnchor {
        id: menu

        menu: root.modelData.menu
        anchor.item: root
    }

    IconImage {
        id: icon

        implicitSize: UIConfig.trayIconSize
        anchors.centerIn: parent

        source: {
            let icon = root.modelData.icon;
            if (icon.includes("?path=")) {
                const [name, path] = icon.split("?path=");
                icon = `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`;
            }
            return icon;
        }
        asynchronous: true
    }
}
