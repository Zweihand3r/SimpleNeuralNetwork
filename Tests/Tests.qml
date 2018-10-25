import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

Rectangle {
    id: rootTests
    anchors.fill: parent

    StackLayout {
        id: stackLt
        anchors.fill: parent
        currentIndex: tabbar.currentIndex

        Simple {

        }

        AddNetwork {

        }

        Grid_ {

        }
    }

    RowLayout {
        width: parent.width
        anchors.bottom: parent.bottom

        Button {
            text: "Back"
            Layout.fillHeight: true
            Layout.preferredHeight: 32
            Layout.preferredWidth: 96
            onClicked: rootTests.visible = false
        }

        TabBar {
            id: tabbar
            currentIndex: 2
            Layout.fillWidth: true

            Repeater {
                model: ["Simple", "Addnetwork", "Grid"]
                TabButton { text: modelData }
            }
        }
    }
}
