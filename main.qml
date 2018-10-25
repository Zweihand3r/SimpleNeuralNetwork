import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import FileManager 1.1

import './qml/Switches'
import './Tests'

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Simple Neural Network")

    property int selectionIndexOnLoad: -1

    Component.onCompleted: componentLoaded()

    /* UI */

    FileManager {
        id: fileManager
    }

    RowLayout {
        id: menu
        anchors.centerIn: parent

        property int selectionIndex

        Repeater {
            model: ["Tests", "Switches"]
            delegate: MouseArea {
                Layout.preferredWidth: 180
                Layout.preferredHeight: 90
                hoverEnabled: true; clip: true
                onClicked: clickHandler(index, mouseX, mouseY)

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

                function clickHandler(index, mouseX, mouseY) {
                    menu.selectionIndex = index

                    clickIndicator.anchors.horizontalCenterOffset = mouseX - 120
                    clickIndicator.anchors.verticalCenterOffset = mouseY - 60
                    clickIndicator.visible = true
                    clickAnim.start()
                }
            }
        }

        function selectionHandler(index) {
            if (index === undefined) index = selectionIndex

            switch (index) {
            case 0: tests.visible = true; break
            case 1: switches.visible = true; break
            }
        }
    }

    Tests {
        id: tests
        visible: false
    }

    Switches {
        id: switches
        visible: false
    }

    function componentLoaded() {
        if (selectionIndexOnLoad >= 0) {
            menu.selectionHandler(selectionIndexOnLoad)
        }
    }

    function printArray(arr, title) {
        if (title) { console.log(title) }
        arr.forEach(function(item) {
            console.log(item)
        })
    }
}
