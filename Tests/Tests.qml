import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

import '../js/NeuralFunctions.js' as Nef

Rectangle {
    id: rootTests
    anchors.fill: parent

    StackLayout {
        id: stackLt
        anchors { fill: parent; bottomMargin: rowLt.height }
        currentIndex: tabbar.currentIndex

        Simple {
            id: simple
        }

        AddNetwork {

        }

        Grid_ {

        }

        Interface {

        }
    }

    RowLayout {
        id: rowLt
        width: parent.width
        anchors.bottom: parent.bottom

        RowLayout {
            Layout.fillHeight: true
            spacing: 1

            Repeater {
                model: ["Back"]

                Button {
                    text: modelData
                    Layout.fillHeight: true
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: 96
//                    visible: index !== 0
                    onClicked: {
                        switch (text) {
                        case "Back":
                            rootTests.visible = false
                            content.visible = true
                            break
                        }
                    }
                }
            }
        }

        TabBar {
            id: tabbar
            currentIndex: 3
            Layout.fillWidth: true

            Repeater {
                model: ["Simple", "Addnetwork", "Grid", "Interface"]
                TabButton { text: modelData }
            }
        }
    }
}
