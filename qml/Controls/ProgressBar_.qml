import QtQuick 2.7
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0

ProgressBar {
    id: rootPb

    property color _col_prim: col_prim
    property int progressMargin: 4

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 6
        color: "#00000000"; radius: height / 2
        border { width: 2; color: _col_prim }
    }

    contentItem: Item {
        implicitWidth: 200
        implicitHeight: 4

        Item {
            id: container
            anchors { fill: parent; margins: progressMargin } visible: false
            Rectangle { width: (rootPb.visualPosition * parent.width); height: parent.height; color: _col_prim }
        }

        Rectangle {
            id: mask; visible: false
            anchors.fill: container; radius: width / 2
        }

        OpacityMask {
            anchors.fill: container
            source: container; maskSource: mask
        }
    }
}
