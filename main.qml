import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import FileManager 1.1

import './qml'
import './Tests'

ApplicationWindow {
    visible: true
    width: content.windowWidth
    height: content.windowHeight
    title: qsTr("Simple Neural Network")

    /* UI */

    FileManager {
        id: fileManager
    }

    DataManager {
        id: dataManager
    }

    Tests {
        id: tests
//        visible: false
    }

    Content {
        id: content
        visible: false
    }

    function printArray(arr, title) {
        if (title) { console.log(title) }
        arr.forEach(function(item) {
            console.log(item)
        })
    }


    /* ------------ Redundant ------------- */

    /*property string selectContentOnLoad: "Content"

    Component.onCompleted: componentLoaded()

    ColumnLayout {
        id: menu
        anchors.centerIn: parent

        property string selectedItem

        Repeater {
            model: ["Content", "Tests"]
            delegate: MouseArea {
                Layout.preferredWidth: 240
                Layout.preferredHeight: 90
                hoverEnabled: true; clip: true
                onClicked: clickHandler(mouseX, mouseY)

                Rectangle {
                    anchors { fill: parent; margins: 8 } radius: 6
                    color: "#121212"; opacity: parent.containsMouse ? 1 : 0
                    Behavior on opacity { OpacityAnimator { duration: 120 } }
                }
                Rectangle { id: clickIndicator; visible: false; radius: width / 2 ; anchors.centerIn: parent }
                Rectangle { anchors.fill: parent; radius: 8; color: "#00000000"; border { color: "#121212"; width: 4 } }

                Text {
                    id: buttonText; anchors.fill: parent; text: modelData; font.pixelSize: 34
                    color: parent.containsMouse ? "#FFFFFF" : "#121212"; wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter
                    Behavior on color { ColorAnimation { duration: 120 }}
                }

                ParallelAnimation {
                    id: clickAnim
                    onStopped: { clickIndicator.visible = false; menu.selectionHandler() }
                    NumberAnimation { target: clickIndicator; property: "width"; from: 0; to: 360; duration: 360 }
                    NumberAnimation { target: clickIndicator; property: "height"; from: 0; to: 360; duration: 360 }
                    OpacityAnimator { target: clickIndicator; from: 1; to: 0; duration: 360; easing.type: Easing.InQuart }
                }

                function clickHandler(mouseX, mouseY) {
                    menu.selectedItem = buttonText.text

                    clickIndicator.anchors.horizontalCenterOffset = mouseX - (width / 2)
                    clickIndicator.anchors.verticalCenterOffset = mouseY - (height / 2)
                    clickIndicator.visible = true
                    clickAnim.start()
                }
            }
        }

        function selectionHandler(item) {
            if (item === undefined) item = selectedItem

            switch (item) {
            case "Tests": tests.visible = true; break
            case "Content": content.visible = true; break
            }
        }
    }

    function componentLoaded() {
        if (selectContentOnLoad !== undefined)
            menu.selectionHandler(selectContentOnLoad)
    }*/
}
