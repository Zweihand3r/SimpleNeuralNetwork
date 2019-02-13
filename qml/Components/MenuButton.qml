import QtQuick 2.7
import QtQuick.Layouts 1.3

import '../Controls'

Item {
    id: rootMbt
    implicitWidth: 144
    implicitHeight: 44
    clip: true

    property bool selected: false

    property string text: "Button"

    signal clicked()
    signal delayedClick()

    MouseArea {
        id: clicky
        hoverEnabled: true
        anchors.fill: parent
        onClicked: function() {
            if (dataManager.animDisabled) {
                rootMbt.clicked()
                rootMbt.delayedClick()
            } else clickHandler(mouseX, mouseY)
        }

        Rectangle {
            anchors { fill: parent; margins: 2 } radius: 2
            color: col_bg; opacity: clicky.containsMouse ? 1 : 0
            Behavior on opacity { enabled: !dataManager.animDisabled; OpacityAnimator { duration: 80 } }
        }

        Rectangle {
            id: clickIndicator; visible: false;
            color: col_prim; radius: width / 2; anchors.centerIn: parent
        }

        Item {
            height: parent.height; width: 3; anchors {
                right: parent.right; rightMargin: -1
            } opacity: selected ? 1 : 0

            Behavior on opacity { enabled: !dataManager.animDisabled; OpacityAnimator { duration: 120 } }

            Rectangle {
                anchors { centerIn: parent }
                width: 16; height: 16; color: col_prim; rotation: 45
                Behavior on color { enabled: !dataManager.animDisabled; ColorAnimation { duration: 120 } }

                Rectangle {
                    anchors { centerIn: parent }
                    width: 12; height: 12; color: col_bg
                    Behavior on color { enabled: !dataManager.animDisabled; ColorAnimation { duration: 120 } }
                }
            }
        }
    }

    RowLayout {
        anchors { fill: parent; margins: 8 }

        Item { Layout.preferredWidth: 1 }

        Text {
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            text: rootMbt.text; font { pixelSize: 21 }
            color: clicky.containsMouse ? col_prim : col_bg
        }
    }

    ParallelAnimation {
        id: clickAnim
        onStopped: { clickIndicator.visible = false; rootMbt.delayedClick() }
        NumberAnimation { target: clickIndicator; property: "width"; from: 0; to: width * 1.2; duration: 360 }
        NumberAnimation { target: clickIndicator; property: "height"; from: 0; to: width * 1.2; duration: 360 }
        OpacityAnimator { target: clickIndicator; from: 1; to: 0; duration: 360; easing.type: Easing.InQuart }
    }

    function clickHandler(mouseX, mouseY) {
        rootMbt.clicked()
        if (selected) return

        clickIndicator.anchors.horizontalCenterOffset = mouseX - (width / 2)
        clickIndicator.anchors.verticalCenterOffset = mouseY - (height / 2)
        clickIndicator.visible = true
        clickAnim.start()
    }
}
