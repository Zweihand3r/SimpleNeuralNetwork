import QtQuick 2.7
import QtQuick.Layouts 1.3

import '../../js/Permutation.js' as Permute
import '../../js/NeuralFunctions.js' as NeuralFunctions

Item {
    id: rootSwitches
    width: parent.width
    height: parent.height
    Rectangle { anchors.fill: parent; color: "#000000" }

    property int switchCount: 3
    property int outputCount: 3

    Flickable {
        anchors { fill: parent; margins: 20 }
        contentWidth: parent.width; contentHeight: column.height
        flickableDirection: Flickable.VerticalFlick

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

    MouseArea {
        width: 44
        height: 44
        anchors { top: parent.top; right: parent.right }
        onClicked: test()

        Rectangle {
            anchors.fill: parent
            color: "red"
        }
    }

    function test() {
        var io = getInputsAndOutputs()

        var res = NeuralFunctions.train(io.inputs, io.outputs, 1000, 4)

        var inputs = []

        for (var index = 0; index < gridRepeater.model; index++) {
            var switchRow = gridRepeater.itemAt(index)
            inputs.push(switchRow.getSwitchInputs())
        }

        inputs.forEach(function(input, index) {
            var netout = NeuralFunctions.predict(input, res)
            gridRepeater.itemAt(index).setNetworkOutput(netout)
        })
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
