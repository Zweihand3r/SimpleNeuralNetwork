import QtQuick 2.7
import QtQuick.Layouts 1.3

import './Switches'

Item {
    id: rootContent
    width: windowWidth
    height: windowHeight

    property int windowWidth: 640
    property int windowHeight: 480

    Rectangle {
        id: header
        color: "#000000"
        width: windowWidth; height: 44

        Text {
            anchors { centerIn: parent }
            font.pixelSize: 25; color: "#FFFFFF"
            text: contentStack.itemAt(contentStack.currentIndex).objectName
        }
    }

    StackLayout {
        id: contentStack
        currentIndex: 0
        anchors { left: parent.left; top: header.bottom; right: parent.right; bottom: parent.bottom }

        Switches {
            id: switches
            objectName: "Switches"
        }
    }
}
