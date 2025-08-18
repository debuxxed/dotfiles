pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

Item {
    id: root
    implicitWidth: row.width
    implicitHeight: row.height

    required property string prefix
    default property alias content: contentItem.sourceComponent

    Rectangle {
        anchors.fill: row
        anchors.leftMargin: -6
        anchors.rightMargin: anchors.leftMargin

        color: "black"
    }

    RowLayout {
        id: row

        layoutDirection: root.prefix == ">" ? Qt.RightToLeft : Qt.LeftToRight
        spacing: 4

        BarText {
            text: root.prefix
        }

        Loader {
            id: contentItem
        }
    }
}
