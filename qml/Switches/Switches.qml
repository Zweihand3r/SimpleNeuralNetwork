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
    property int outputCount: 2

    property int trainStepIndex: 0
    property int totalStepsTrained: 0
    property int trainBatchCount: 10000

    property var inputs: []
    property var outputs: []
    property var weights: []

    Flickable {
        anchors {
            left: parent.left; right: parent.right; top: parent.top; bottom: controls.top
            leftMargin: 20; rightMargin: 20; topMargin: 20; bottomMargin: 8
        }

        contentWidth: parent.width; contentHeight: column.height
        flickableDirection: Flickable.VerticalFlick; /*clip: true*/

        ColumnLayout {
            id: column
            spacing: 12
            anchors {
                horizontalCenter: parent.horizontalCenter
                horizontalCenterOffset: -20
            }

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

    ColumnLayout {
        id: controls; anchors {
            bottomMargin: 8; bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "Steps trained: " + totalStepsTrained
            font.pixelSize: 17; color: "#FFFFFF"
        }

        RowLayout {
            Button_ {
                Layout.preferredHeight: 36
                Layout.preferredWidth: 64
                fontSize: 17; text: "Test"
//                visible: false
                onClickDelay: test()
            }

            Button_ {
                Layout.preferredHeight: 36
                Layout.preferredWidth: 164
                fontSize: 17; text: "Train " + trainBatchCount + " steps"
                onClickDelay: trainNetwork()
            }
            Button_ {
                Layout.preferredHeight: 36
                Layout.preferredWidth: 144
                fontSize: 17; text: "Wipe Network"
                onClickDelay: clearNetwork()
            }

            Button_ {
                Layout.preferredHeight: 36
                Layout.preferredWidth: 244
                fontSize: 17; text: "Compute Network Output"
                onClickDelay: computeNetworkOutput()
            }
        }
    }

    MouseArea {
        anchors.fill: parent
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

    Component.onCompleted: {
        createGrid()
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
