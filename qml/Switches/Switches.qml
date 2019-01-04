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

    property int switchCount: 3
    property int outputCount: 1
    property int outputType: 0

    property int trainStepIndex: 0
    property int totalStepsTrained: 0
    property int trainBatchCount: switchPanel.stepCount

    property var inputs: []
    property var outputs: []
    property var weights: []

    Component.onCompleted: createGrid()

    Flickable {
        anchors {
            right: controlsPanel.left; left: parent.left; top: parent.top; bottom: footer.top
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
                    outputType: rootSwitches.outputType
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

        SwitchPanel {
            id: switchPanel
        }
    }

    Item {
        id: footer
        height: 44
        anchors { left: parent.left; bottom: parent.bottom; right: parent.right }
        Rectangle { anchors.fill: parent; color: col_bg; opacity: 0.85 }

        Text {
            anchors { centerIn: parent }
            font.pixelSize: 21; color: col_prim
            text: "Network trained <b>" + totalStepsTrained + "</b> times"
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: forceActiveFocus()
        visible: trainTimer.running
        Rectangle { anchors.fill: parent; opacity: 0.8; color: "#000000" }

        ProgressBar_ {
            id: pb
            from: 0; to: trainBatchCount - 1
            value: trainStepIndex
            anchors.centerIn: parent
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
