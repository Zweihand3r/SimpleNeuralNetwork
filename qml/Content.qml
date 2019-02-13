import QtQuick 2.7
import QtQuick.Layouts 1.3

import './Switches'
import './Mover'
import './Components'

Item {
    id: rootContent
    width: windowWidth
    height: windowHeight

    /* 16:9 */
    property int windowWidth: 853
    property int windowHeight: 480

    property string theme: "dark"

    /* Colors */
    property color col_accent: "#7666EF"

    property color col_prim: "#FFFFFF"
    property color col_prim_dim: "#656565"
    property color col_bg: "#000000"

    onThemeChanged: changeTheme()

    Menu {
        id: menu
        currentStackIndex: 1
    }

    Item {
        id: content
        x: menu.presented ? menu.panelWidth : 0
        width: parent.width; height: parent.height

        Behavior on x {
            enabled: !dataManager.animDisabled
            NumberAnimation { duration: menu.animDuration; easing.type: Easing.InCubic }
        }

        Rectangle {
            anchors.fill: parent; color: col_bg
            Behavior on color { enabled: !dataManager.animDisabled; ColorAnimation { duration: 120 } }
        }

        StackLayout {
            id: contentStack
            currentIndex: menu.currentStackIndex; anchors {
                left: parent.left; top: header.bottom; right: parent.right; bottom: parent.bottom
            }

            Switches {
                id: switches
                objectName: "Switches"
            }

            Mover {
                id: mover
                objectName: "Mover"
            }
        }

        Item {
            id: header
            width: windowWidth; height: 44
            Rectangle {
                anchors.fill: parent; color: col_bg; opacity: 0.85
                Behavior on color { enabled: !dataManager.animDisabled; ColorAnimation { duration: 120 } }
            }

            Rectangle {
                width: parent.width - 16; height: 1; color: col_prim; anchors {
                    bottom: parent.bottom; horizontalCenter: parent.horizontalCenter
                } Behavior on color { enabled: !dataManager.animDisabled; ColorAnimation { duration: 120 } }
            }

            Text {
                anchors { centerIn: parent }
                font.pixelSize: 25; color: col_prim
                text: contentStack.itemAt(contentStack.currentIndex).objectName
                Behavior on color { enabled: !dataManager.animDisabled; ColorAnimation { duration: 120 } }
            }
        }

        MenuIndicator {
            id: menuIndicator
        }
    }

    LoadingScreen {
        id: loadingScreen
    }

    Popup_ {
        id: popup
    }

    Rectangle {
        id: _bounds; visible: false

        function outline(x, y, width, height, color) {
            visible = true; _bounds.x = x; _bounds.y = y
            _bounds.width = width; _bounds.height = height
            if (color !== undefined) _bounds.color = color
        }

        function hide() { visible = false }
    }

    function changeTheme() {
        var colorProperties = ["accent", "prim", "prim_dim", "bg"]
        var colors = dataManager.themes[theme]
        colorProperties.forEach(function(prop) {
            prop = "col_" + prop
            rootContent[prop] = colors[prop]
        })
    }
}
