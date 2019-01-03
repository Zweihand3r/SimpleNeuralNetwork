import QtQuick 2.7
import QtGraphicalEffects 1.0

Item {
    id: rootPp
    width: parent.width
    height: parent.height
//    visible: false

    Item {
        id: contentContainer
        anchors.fill: parent

        Rectangle {
            id: content
            anchors.fill: parent
            color: "red"; visible: false
        }

        Rectangle {
            id: mask
            width: 100; height: 100; radius: 6
            color: "black"; visible: false
        }

        OpacityMask {
            source: content
            maskSource: mask
            anchors.fill: parent
        }
    }
}
