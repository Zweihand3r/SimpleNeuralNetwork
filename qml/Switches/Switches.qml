import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

import '../../js/Permutation.js' as Permute
import '../../js/NeuralFunctions.js' as NeuralFunctions

import '../SharedComponents'

Item {
    id: rootSwitches
    width: parent.width
    height: parent.height
    Rectangle { anchors.fill: parent; color: "#000000" }

    property int switchCount: 3
    property int outputCount: 1

    property int trainStepIndex: 0
    property int totalStepsTrained: 0
    property int trainBatchCount: parseInt(stepsDropdown.currentItem)

    property var inputs: []
    property var outputs: []
    property var weights: []

    Component.onCompleted: createGrid()

    Flickable {
        anchors {
            right: controlsPanel.left; left: parent.left; top: parent.top; bottom: parent.bottom
            rightMargin: 20; leftMargin: 20; topMargin: 20; bottomMargin: 20
        }

        contentWidth: parent.width; contentHeight: column.height
        flickableDirection: Flickable.VerticalFlick; /*clip: true*/

        ColumnLayout {
            id: column
            spacing: 12

            Repeater {
                id: gridRepeater
                model: 8

                SwitchRow {
                    switchCount: rootSwitches.switchCount
                    outputCount: rootSwitches.outputCount
                }
            }
        }
    }

    Item {
        id: controlsPanel
        width: 280; clip: true; anchors {
            top: parent.top; right: parent.right; bottom: parent.bottom
            topMargin: 8; rightMargin: 20; bottomMargin: 20
        }

        /*Rectangle {
            anchors.fill: parent
            color: "#00000000"; radius: 8
            border { width: 2; color: "#FFFFFF" }
        }*/

        Flickable {
            contentHeight: setConColumn.height; contentWidth: width
            anchors { left: parent.left; top: parent.top; right: parent.right }

            ColumnLayout {
                id: setConColumn
                width: parent.width

                Item { Layout.preferredHeight: 1 }

                /* Settings */

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter

                    Rectangle { Layout.preferredHeight: 5; Layout.preferredWidth: 5; rotation: 45 }
                    Rectangle { Layout.preferredHeight: 6; Layout.preferredWidth: 6; rotation: 45 }
                    Rectangle { Layout.preferredHeight: 7; Layout.preferredWidth: 7; rotation: 45 }

                    Text {
                        text: "SETTINGS"; color: "#FFFFFF"
                        font { pixelSize: 17; bold: true }
                    }

                    Rectangle { Layout.preferredHeight: 7; Layout.preferredWidth: 7; rotation: 45 }
                    Rectangle { Layout.preferredHeight: 6; Layout.preferredWidth: 6; rotation: 45 }
                    Rectangle { Layout.preferredHeight: 5; Layout.preferredWidth: 5; rotation: 45 }
                }

                Button_Dropdown {
                    id: inputDropdown
                    text: "Input Count"
                    Layout.fillWidth: true
                    currentIndex: 1
                    dropdownItems: ["Two", "Three", "Four"]
                }

                Button_Dropdown {
                    id: outputDropdown
                    text: "Output Count"
                    Layout.fillWidth: true
                    dropdownItems: ["One", "Two", "Three"]
                }

                RowLayout {
                    Layout.fillWidth: true

                    Button_ {
                        Layout.preferredHeight: 30; Layout.fillWidth: true
                        text: "Revert"; horizontalAlignment: Text.AlignHCenter
                        onClicked: {
                            inputDropdown.setCurrentIndex(switchCount - 2)
                            outputDropdown.setCurrentIndex(outputCount - 1)
                        }
                    }

                    Button_ {
                        Layout.preferredHeight: 30; Layout.fillWidth: true
                        text: "Apply"; horizontalAlignment: Text.AlignHCenter
                        onClicked: loadingScreen.showAnim()
                    }
                }

                Item { Layout.preferredHeight: 4 }

                /* Controls */

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter

                    Rectangle { Layout.preferredHeight: 5; Layout.preferredWidth: 5; rotation: 45 }
                    Rectangle { Layout.preferredHeight: 6; Layout.preferredWidth: 6; rotation: 45 }
                    Rectangle { Layout.preferredHeight: 7; Layout.preferredWidth: 7; rotation: 45 }

                    Text {
                        text: "CONTROLS"; color: "#FFFFFF"
                        font { pixelSize: 17; bold: true }
                    }

                    Rectangle { Layout.preferredHeight: 7; Layout.preferredWidth: 7; rotation: 45 }
                    Rectangle { Layout.preferredHeight: 6; Layout.preferredWidth: 6; rotation: 45 }
                    Rectangle { Layout.preferredHeight: 5; Layout.preferredWidth: 5; rotation: 45 }
                }

                /*Button_ {
                    Layout.fillWidth: true
                    fontSize: 17; text: "Test"
                }*/

                Button_Dropdown {
                    id: stepsDropdown
                    text: "Train Steps"
                    Layout.fillWidth: true
                    dropdownItems: ["10", "1000",  "100000", "10000000"]
                }

                Button_ {
                    Layout.fillWidth: true
                    text: "Train Network"
                    onClicked: trainNetwork()
                }

                Button_ {
                    Layout.fillWidth: true
                    text: "Wipe Network"
                    onClicked: clearNetwork()
                }

                Button_ {
                    Layout.fillWidth: true
                    text: "Compute Network Output"
                    onClicked: computeNetworkOutput()
                }

                Item { Layout.preferredHeight: 1 }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: forceActiveFocus()
        visible: trainTimer.running
        Rectangle { anchors.fill: parent; opacity: 0.8; color: "#000000" }

        ProgressBar {
            id: pb
            from: 0; to: trainBatchCount - 1
            value: trainStepIndex
            anchors.centerIn: parent

            background: Rectangle {
                implicitWidth: 200
                implicitHeight: 6
                color: "#00000000"; radius: height / 2
                border { width: 1; color: "#FFFFFF" }
            }

            contentItem: Item {
                implicitWidth: 200
                implicitHeight: 4

                Rectangle {
                    width: pb.visualPosition * parent.width
                    height: parent.height
                    radius: parent.height / 2
                    color: "#FFFFFF"
                }
            }
        }
    }

    Timer {
        id: trainTimer
        interval: 1
        repeat: true
        onTriggered: trainLoop()
    }

    function test() {
        var io = getInputsAndOutputs()
        clearNetworkOutputs()
        weights = NeuralFunctions.train(io.inputs, io.outputs, trainBatchCount, 4)
    }

    function trainNetwork() {
        var io = getInputsAndOutputs()

        inputs = io.inputs
        outputs = io.outputs

        if (weights.length === 0)
            weights = NeuralFunctions.initializeWeights("random", inputs[0].length, outputs[0].length, 4)

        trainStepIndex = 0
        clearNetworkOutputs()
        trainTimer.start()
    }

    function trainLoop() {
        if (trainStepIndex < trainBatchCount) {
            weights = NeuralFunctions.trainStep(inputs, outputs, weights, 4)
            trainStepIndex++
            totalStepsTrained++
        } else {
            // Complete training

            trainTimer.stop()
        }
    }

    function computeNetworkOutput() {
        var inputs = []
        for (var index = 0; index < gridRepeater.model; index++) {
            var switchRow = gridRepeater.itemAt(index)
            inputs.push(switchRow.getSwitchInputs())
        }

        inputs.forEach(function(input, index) {
            var netout = NeuralFunctions.predict(input, weights)
            gridRepeater.itemAt(index).setNetworkOutput(netout)
        })
    }

    function clearNetwork() {
        weights = []
        totalStepsTrained = 0
        clearNetworkOutputs()
    }

    function clearNetworkOutputs() {
        for (var index = 0; index < gridRepeater.model; index++) {
            gridRepeater.itemAt(index).setNetworkOutput([0, 0, 0])
        }
    }

    function createGrid() {
        var mat = []
        var inputArray = []

        for (var index = 0; index < switchCount; index++) {
            mat.push([0, 1])
        }

        inputArray = Permute.variant(mat)

        gridRepeater.model = Math.pow(2, switchCount)

        inputArray.forEach(function(inputs, index) {
            gridRepeater.itemAt(index).setSwitchInputs(inputs)
        })
    }

    function getInputsAndOutputs() {
        var inputs = []
        var outputs = []

        for (var index = 0; index < gridRepeater.model; index++) {
            var switchRow = gridRepeater.itemAt(index)

            if (switchRow.checked) {
                inputs.push(switchRow.getSwitchInputs())
                outputs.push(switchRow.getUserOutput())
            }
        }

        return { "inputs": inputs, "outputs": outputs }
    }
}
