import QtQuick 2.7
import QtQuick.Controls 2.1

ProgressBar {
    id: rootPb
    anchors.centerIn: parent

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 6
        color: "#00000000"; radius: height / 2
        border { width: 1; color: "#FFFFFF" }
    }

    contentItem: Item {
        implicitWidth: 200
        implicitHeight: 4

        Rectangle {
            width: rootPb.visualPosition * parent.width
            height: parent.height
            radius: parent.height / 2
            color: "#FFFFFF"
        }
    }
}
