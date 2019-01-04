import QtQuick 2.7
import QtQuick.Layouts 1.3

import './Controls'

Item {
    id: rootMenu
    width: windowWidth; height: windowHeight

    property bool presented: false

    property int panelWidth: 240
    property int animDuration: 240

    onPresentedChanged: delayTimer.start()

    Item {
        id: content
        width: panelWidth; height: parent.height

        Rectangle { anchors.fill: parent; color: col_prim }

        ColumnLayout {
            anchors { fill: parent; margins: 12 }

            Image_ {
                Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                source: 'qrc:/assets/Images/Neural_Brain.png'; fillMode: Image.PreserveAspectFit
                Layout.preferredWidth: 90; Layout.preferredHeight: paintedHeight; tint: col_bg
            }
        }
    }

    Timer {
        id: delayTimer
        interval: animDuration
        onTriggered: menuButton.presented = presented
    }
}
