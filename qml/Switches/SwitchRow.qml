import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

RowLayout {
    id: rootSR
    spacing: 20

    property color color: col_prim
    property color networkOutputColor: col_accent

    property color color_on: color
    property color color_off: col_prim_dim

    property int switchCount: 3
    property int outputCount: 1

    property bool switchable: false
    property bool selectable: true

    /* "Binary", "Fill", "Decimal" */
    property int outputType: 0

    property bool checked: true

    MouseArea {
        id: checkbox
        Layout.preferredHeight: parent.height
        Layout.preferredWidth: parent.height
        visible: selectable
        onClicked: checked = !checked

        Rectangle {
            anchors { fill: parent; margins: 5 }
            color: "transparent"; radius: 4
            border { width: 2; color: rootSR.color }

            Rectangle {
                anchors { fill: parent; margins: 4 }
                color: rootSR.color; radius: 1
                scale: checked ? 1 : 0

                Behavior on scale {
                    enabled: !dataManager.animDisabled
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
                enabled: !dataManager.animDisabled
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
                    border { width: 2; color: color_on }
                    color: rootSwitch.switchedOn ? color_on : "transparent"

                    Behavior on y {
                        enabled: !dataManager.animDisabled
                        NumberAnimation { duration: 64; easing.type: Easing.InCubic }
                    }
                }
            }
        }
    }

    Item { Layout.preferredWidth: 2 }

    RowLayout {
        Repeater {
            id: userOutRepeater
            model: outputCount

            MouseArea {
                id: userOutputDisplay
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: parent.height
                enabled: checked; visible: selectable
                opacity: checked ? 1 : 0.5
                hoverEnabled: true
                onClicked: output = !output

                property bool output: false

                Item {
                    anchors { fill: parent }

                    Rectangle {
                        anchors { fill: parent }
                        color: "transparent"; radius: width / 2
                        border { width: 2; color: rootSR.color }
                        scale: userOutputDisplay.containsMouse ? 1.1 : 1

                        Behavior on scale { enabled: !dataManager.animDisabled; ScaleAnimator { duration: 80 } }
                    }

                    RadialGradient {
                        anchors { fill: parent; margins: -20 }
                        opacity: userOutputDisplay.output ? (checked ? 1 : 0) : 0

                        gradient: Gradient {
                            GradientStop { position: 0.0; color: rootSR.color }
                            GradientStop { position: 0.125; color: rootSR.color }
                            GradientStop { position: 0.4; color: "transparent" }
                        }

                        Behavior on opacity {
                            enabled: !dataManager.animDisabled
                            OpacityAnimator { duration: 120; easing.type: Easing.InCubic }
                        }
                    }

                    Behavior on opacity {
                        enabled: !dataManager.animDisabled
                        OpacityAnimator { duration: 64; easing.type: Easing.InCubic }
                    }
                }

                Behavior on opacity {
                    enabled: !dataManager.animDisabled
                    OpacityAnimator { duration: 64; easing.type: Easing.InCubic }
                }
            }
        }
    }

    Item { Layout.preferredWidth: 2 }

    RowLayout {
        Repeater {
            id: netOutRepeater
            model: outputCount

            Rectangle {
                id: netOutDisplay
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: parent.height
                color: "transparent"; radius: width / 2
                border { width: 2; color: networkOutputColor }

                property bool output: false
                property real outputValue: 0.0

                onOutputValueChanged: output = outputValue > 0.5

                RadialGradient {
                    opacity: parent.output ? 1 : 0
                    anchors { fill: parent; margins: -20 }
                    visible: outputType === 0 || outputType === 2

                    gradient: Gradient {
                        GradientStop { position: 0.0; color: networkOutputColor }
                        GradientStop { position: 0.125; color: networkOutputColor }
                        GradientStop { position: 0.4; color: "transparent" }
                    }

                    Behavior on opacity {
                        enabled: !dataManager.animDisabled
                        OpacityAnimator { duration: 120; easing.type: Easing.InCubic }
                    }
                }

                Item {
                    id: container
                    visible: false; anchors { fill: parent; margins: 4 }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        height: netOutDisplay.outputValue * width
                        width: parent.width; color: networkOutputColor
                    }
                }

                Rectangle {
                    id: mask
                    radius: width / 2; visible: false
                    anchors { fill: parent; margins: 4 }
                }

                OpacityMask {
                    visible: outputType === 1
                    anchors { fill: parent; margins: 4 }
                    source: container; maskSource: mask
                }

                Text {
                    visible: outputType === 2
                    text: formatNumber(netOutDisplay.outputValue)
                    color: netOutDisplay.output ? col_bg : networkOutputColor
                    anchors.centerIn: parent; font { pixelSize: 12; bold: true }
                }

                Behavior on opacity {
                    enabled: !dataManager.animDisabled
                    OpacityAnimator { duration: 64; easing.type: Easing.InCubic }
                }
            }
        }
    }

    Component.onCompleted: {
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
        var output = []
        for (var index = 0; index < outputCount; index++) {
            output.push(userOutRepeater.itemAt(index).output ? 1 : 0)
        }

        return output
    }

    function setNetworkOutput(output) {
        for (var index = 0; index < outputCount; index++) {
            netOutRepeater.itemAt(index).outputValue = output[index]
        }
    }

    function formatNumber(num) {
        num = Number(num).toFixed(2).toString()
        if (num === "1.00") return "1.0"
        else return num.slice(1)
    }
}
