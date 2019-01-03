import QtQuick 2.7
import QtQuick.Layouts 1.3

Item {
    id: rootLS
    width: parent.width
    height: parent.height
    visible: false

    property int coverCount: 20

    property bool disableAnim: false

    MouseArea { anchors.fill: parent; hoverEnabled: true; onClicked: forceActiveFocus() }

    ColumnLayout {
        spacing: 0
        anchors { fill: parent }

        Repeater {
            id: coverRep
            model: coverCount

            Item {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: 12
                Layout.fillWidth: true
                Layout.fillHeight: true

                property int animX: 0

                Rectangle {
                    x: parent.animX
                    width: parent.width
                    height: parent.height

//                    color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1)

                    Behavior on x {
                        enabled: !disableAnim
                        NumberAnimation { duration: 240; easing.type: Easing.InCurve }
                    }
                }
            }
        }
    }

    Timer {
        property int index: 0
        property bool showing: true
        property bool filled: false

        id: animTimer
        repeat: true
        interval: 20
        onTriggered: animLoop()
    }

    function showAnim() {
        disableAnim = true

        for (var index = 0; index < coverCount; index++) {
            if (index % 2 === 0) {
                coverRep.itemAt(index).animX = -width
            } else {
                coverRep.itemAt(index).animX = width
            }
        }

        visible = true
        disableAnim = false
        animTimer.showing = true

        animTimer.index = 0
        animTimer.start()
    }

    function animLoop() {
        if (animTimer.showing) {
            if (animTimer.index < coverCount) {
                coverRep.itemAt(animTimer.index).animX = 0
            }

            animTimer.index += 1
        }
        else animTimer.stop()
    }
}
