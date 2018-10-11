import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

RowLayout {
    id: rootSR
    spacing: 20

    property color color: "#FFFFFF"
    property color networkOutputColor: "#7666EF"

    property int switchCount: 3

    property bool switchable: false
    property bool selectable: true

    property bool checked: true
    property bool userOutput: false
    property bool networkOutput: false

    MouseArea {
        id: checkbox
        Layout.preferredHeight: parent.height
        Layout.preferredWidth: parent.height
        visible: selectable
        onClicked: checked = !checked

        Rectangle {
            anchors { fill: parent; margins: 5 }
            color: "transparent"
            border { width: 2; color: rootSR.color }

            Rectangle {
                anchors { fill: parent; margins: 4 }
                color: rootSR.color
                scale: checked ? 1 : 0

                Behavior on scale {
                    ScaleAnimator { duration: 64; easing.type: Easing.InCubic }
                }
            }
        }
    }

    Repeater {
        id: switchRepeater
        model: switchCount

        Rectangle {
            id: rootSwitch

            property bool switchedOn: false

            Layout.preferredWidth: 20
            Layout.preferredHeight: 30
            color: "transparent"; radius: width / 2
            border { width: 2; color: rootSR.color }
            opacity: selectable ? (checked ? 1 : 0.5) : 1

            Behavior on opacity {
                OpacityAnimator { duration: 64; easing.type: Easing.InCubic }
            }

            MouseArea {
                anchors.fill: parent; enabled: switchable
                onClicked: parent.switchedOn = !parent.switchedOn
            }

            Item {
                anchors { fill: parent; margins: 4 }

                Rectangle {
                    y: rootSwitch.switchedOn ? parent.height - height : 0
                    width: parent.width
                    height: parent.width
                    radius: width / 2
                    color: rootSR.color

                    Behavior on y {
                        NumberAnimation { duration: 64; easing.type: Easing.InCubic }
                    }
                }
            }
        }
    }

    Item { Layout.preferredWidth: 2 }

    MouseArea {
        id: userOutputDisplay
        Layout.preferredHeight: parent.height
        Layout.preferredWidth: parent.height
        onClicked: userOutput = !userOutput
        enabled: checked; visible: selectable

        Rectangle {
            anchors { fill: parent }
            color: "transparent"; radius: width / 2
            border { width: 2; color: rootSR.color }

            RadialGradient {
                anchors { fill: parent; margins: -20 }
                opacity: userOutput ? (checked ? 1 : 0) : 0

                gradient: Gradient {
                    GradientStop { position: 0.0; color: rootSR.color }
                    GradientStop { position: 0.125; color: rootSR.color }
                    GradientStop { position: 0.4; color: "transparent" }
                }

                Behavior on opacity {
                    OpacityAnimator { duration: 120; easing.type: Easing.InCubic }
                }
            }

            Behavior on opacity {
                OpacityAnimator { duration: 64; easing.type: Easing.InCubic }
            }
        }
    }

    Item { Layout.preferredWidth: 2 }

    Rectangle {
        Layout.preferredHeight: parent.height
        Layout.preferredWidth: parent.height
        color: "transparent"; radius: width / 2
        border { width: 2; color: networkOutputColor }

        RadialGradient {
            anchors { fill: parent; margins: -20 }
            opacity: networkOutput ? 1 : 0

            gradient: Gradient {
                GradientStop { position: 0.0; color: networkOutputColor }
                GradientStop { position: 0.125; color: networkOutputColor }
                GradientStop { position: 0.4; color: "transparent" }
            }

            Behavior on opacity {
                OpacityAnimator { duration: 120; easing.type: Easing.InCubic }
            }
        }

        Behavior on opacity {
            OpacityAnimator { duration: 64; easing.type: Easing.InCubic }
        }
    }

    function setSwitchInputs(inputs) {
        if (inputs.length !== switchCount) {
            console.log("Invalid switch input")
            return
        }

        inputs.forEach(function(input, index) {
            switchRepeater.itemAt(index).switchedOn = input
        })
    }

    function getSwitchInputs() {
        var inputs = []

        for (var index = 0; index < switchCount; index++) {
            var input = switchRepeater.itemAt(index).switchedOn ? 1 : 0
            inputs.push(input)
        }

        return inputs
    }

    function getUserOutput() {
        return userOutput ? 1 : 0
    }

    function setNetworkOutput(output) {
        networkOutput = output === 1 ? true : false
        console.log(output, networkOutput)
    }
}
