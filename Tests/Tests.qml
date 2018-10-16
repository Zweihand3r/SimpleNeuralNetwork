import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

Item {
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

    TabBar {
        id: tabbar
        width: parent.width
        currentIndex: 2
        anchors.bottom: parent.bottom

        Repeater {
            model: ["Simple", "Addnetwork", "Grid"]
            TabButton { text: modelData }
        }
    }
}
