import QtQuick 2.7
import QtQuick.Layouts 1.3

import './Switches'

Item {
    id: rootContent
    width: windowWidth
    height: windowHeight

    /* 16:9 */
    property int windowWidth: 853
    property int windowHeight: 480

    property color col_accent: "#7666EF"

    property color col_prim: "#FFFFFF"
    property color col_prim_dim: "#656565"
    property color col_bg: "#000000"

    Rectangle { anchors.fill: parent; color: col_bg }

    StackLayout {
        id: contentStack
        currentIndex: 0; anchors {
            left: parent.left; top: header.bottom; right: parent.right; bottom: parent.bottom
        }

        Switches {
            id: switches
            objectName: "Switches"
        }
    }

    Item {
        id: header
        width: windowWidth; height: 44
        Rectangle { anchors.fill: parent; color: col_bg; opacity: 0.85 }
        Rectangle {
            width: parent.width - 16; height: 1; color: col_prim; anchors {
                bottom: parent.bottom; horizontalCenter: parent.horizontalCenter
            }
        }

        Text {
            anchors { centerIn: parent }
            font.pixelSize: 25; color: col_prim
            text: contentStack.itemAt(contentStack.currentIndex).objectName
        }
    }

    LoadingScreen {
        id: loadingScreen
    }

    Popup_ {
        id: popup
    }
}
