import QtQuick 2.7
import QtQuick.Layouts 1.3

Item {
    id: rootLS
    width: parent.width
    height: parent.height
    visible: false

    property int coverCount: 20
    property int slideDuration: 360

    property bool disableAnim: false

    property Item caller: dummyCaller
    property string complete_action: ""

    MouseArea { anchors.fill: parent; hoverEnabled: true; onClicked: forceActiveFocus() }

    ColumnLayout {
        spacing: 0; anchors { fill: parent }

        Repeater {
            id: coverRep
            model: coverCount

            Item {
                Layout.fillWidth: true; Layout.fillHeight: true
                Layout.preferredWidth: parent.width; Layout.preferredHeight: 12

                property int animX: 0

                Rectangle {
                    x: parent.animX
                    width: parent.width
                    height: parent.height
                    color: col_prim

                    Behavior on x {
                        enabled: !disableAnim
                        NumberAnimation { duration: slideDuration; easing.type: Easing.InCurve }
                    }
                }
            }
        }
    }

    Timer {
        property int index: 0
        property bool showing: true

        id: animTimer
        repeat: true; interval: 20
        onTriggered: animLoop()
    }

    Timer {
        id: animCompletionTimer
        repeat: false; interval: slideDuration
        onTriggered: animCompletion()
    }

    Item { id: dummyCaller }

    function present(data) {
        /*data = {
            "caller": <Calling item (Item derivative)>,
            "complete_action": <Function to call on complete>
        }*/

        caller = data.caller
        complete_action = data.complete_action

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

    function dismiss(data) {
        if (data === undefined) {
            caller = dummyCaller
            complete_action = ""
        } else {
            caller = data.caller
            complete_action = data.complete_action
        }

        animTimer.showing = false

        animTimer.index = 0
        animTimer.start()
    }

    function animLoop() {
        if (animTimer.index < coverCount) {
            if (animTimer.showing) coverRep.itemAt(animTimer.index).animX = 0
            else {
                if (animTimer.index % 2 === 0) {
                    coverRep.itemAt(animTimer.index).animX = -width
                } else {
                    coverRep.itemAt(animTimer.index).animX = width
                }
            }

            animTimer.index += 1
        }
        else {
            animTimer.stop()

            /* Anim completion */
            animCompletionTimer.start()
        }
    }

    function animCompletion() {
        if (!animTimer.showing) {
            console.log("LoadingScreen.qml: dismiss complete")
            visible = false
        } else {
            console.log("LoadingScreen.qml: present complete")
        }

        if (complete_action.length > 0)
            caller[complete_action]()
    }
}
