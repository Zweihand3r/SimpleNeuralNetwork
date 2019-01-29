import QtQuick 2.7
import QtQuick.Layouts 1.3

import '../Controls'

ColumnLayout {
    id: rootSwitchPanel; anchors {
        leftMargin: 8; rightMargin: 8
        left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter
    }

    Item {
        id: gridButton
        Layout.preferredWidth: parent.width; Layout.preferredHeight: width
        Rectangle { anchors { fill: gridContent; margins: -4 } radius: 8; color: col_bg }

        Item {
            id: gridContent; clip: true
            height: 128; width: (gridHovery.containsMouse ? parent.width + 128 : 0 )
            anchors { right: parent.right; verticalCenter: parent.verticalCenter }
            Behavior on width { NumberAnimation { duration: 120; easing.type: Easing.OutQuad }}

            Rectangle {
                anchors { right: parent.right; verticalCenter: parent.verticalCenter }
                color: col_prim; width: parent.width + 6; height: gridButton.height; radius: 6
            }

            Rectangle {
                anchors { right: parent.right; rightMargin: 48 }
                color: col_prim; width: 128; height: parent.height; radius: 6
            }
        }

        Image_ {
            tint: gridHovery.containsMouse ? col_bg : col_prim
            source: 'qrc:/assets/Images/Icon_Grid.png'
            anchors { fill: parent; margins: 12 } fillMode: Image.Stretch
        }

        MouseArea {
            id: gridHovery
            anchors.fill: parent
            hoverEnabled: true
        }
    }
}
