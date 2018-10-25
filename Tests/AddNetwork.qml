import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import './Scripts/Matrix.js' as Matrix

Item {
    anchors.fill: parent

    property var inputs: []
    property var outputs: []
    property var weights_1: []
    property var weights_2: []
    property int trainSteps: 1000

    Rectangle {
        anchors { fill: parent; rightMargin: parent.width - 240 }
        color: "#000000"

        ColumnLayout {
            anchors { fill: parent; margins: 20 }

            Repeater {
                model: ["Normalize Test", "Add Net Test"]

                Button {
                    text: modelData
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop

                    onClicked: {
                        switch (modelData) {
                        case "Normalize Test":
                            var array = [0, 23, 55, 23, 54, 23, 10, 23, 54, 100]
                            console.log(normalize(array))
                            break

                        case "Add Net Test":
                            var array_A = [1, 14, 55, 73, 54, 23, 10, 26, 64, 85]
                            var array_B = [21, 28, 93, 2, 74, 52, 32, 77, 12, 5]
                            var array_Sum = []
                            for (var index in array_A) array_Sum.push(array_A[index] + array_B[index])

                            /* for in array causing function() in array */

                            var normalized_A = normalize(array_A)
                            var normalized_B = normalize(array_B)
                            var normalized_Sum = normalize(array_Sum)

                            inputs = []
                            outputs = []
                            for (index in normalized_A) {
                                console.log("normalisedA" + normalized_A[index])
                                inputs.push([normalized_A[index], normalized_B[index]])
                                outputs.push([normalized_Sum[index]])
                            }

                            printArray(inputs, "Inputs")
                            printArray(outputs, "Outputs")

                            train_2Layer()

                            var a = [1, 14, 55, 73, 54, 23, 10, 26, 64, 85]
                            var b = [21, 28, 93, 2, 74, 52, 32, 77, 12, 5]

                            for (index in a) {
                                var input = [[getNormalised(a[index], array_A), getNormalised(b[index], array_B)]]
                                var l1 = sigmoid(Matrix.dot(input, weights_1))
                                var l2 = sigmoid(Matrix.dot(l1, weights_2))

                                console.log(a[index] + " + " + b[index] + " = " + (a[index] + b[index]) + " | " + getFromNormalised(l2, array_Sum))
                            }
                        }
                    }
                }
            }
        }
    }

    function train_2Layer(nodecount) {
        console.log("Training 2 Layer...")
        if (nodecount === undefined) nodecount = 4

        weights_1 = random(inputs[0].length, nodecount)
        weights_2 = random(nodecount, 1)

        for (var index = 0; index < trainSteps; index++) {
            var l0 = inputs.slice()
            var l1 = sigmoid(Matrix.dot(l0, weights_1))
            var l2 = sigmoid(Matrix.dot(l1, weights_2))

            var l2_error = Matrix.subtract(outputs, l2)

            var l2_delta = Matrix.multiply(l2_error, sigmoidDerivative(l2))
            var l1_error = Matrix.dot(l2_delta, Matrix.transpose(weights_2))
            var l1_delta = Matrix.multiply(l1_error, sigmoidDerivative(l1))

            weights_2 = Matrix.add(weights_2, Matrix.dot(Matrix.transpose(l1), l2_delta))
            weights_1 = Matrix.add(weights_1, Matrix.dot(Matrix.transpose(l0), l1_delta))
        }
        console.log("Training 2 Layer complete")
    }

    function sigmoid(x) {
        var res = []
        x.forEach(function(arr) {
            var res_arr = []
            arr.forEach(function(num) {
                res_arr.push(1 / (1 + Math.exp(-num)))
            })
            res.push(res_arr)
        })
        return res
    }

    function sigmoidDerivative(x) {
        var res_ = []
        x.forEach(function(arr) {
            var res_arr = []
            arr.forEach(function(num) {
                res_arr.push(1 - num)
            })
            res_.push(res_arr)
        })
        return Matrix.multiply(x, res_)
    }

    function transposeStringToArray(str) {
        var arr = str.split(" ")
        var inputs = arr[0].split("")
        return inputs
    }

    function random(rows, cols) {
        var res = []
        for (var index = 0; index < rows; index++) {
            var arr = []
            for (var index_ = 0; index_ < cols; index_++) {
                arr.push((Math.random() * 2) - 1)
            }
            res.push(arr)
        }
        return res
    }

    function normalize(array) {
        var min = array[0]
        var max = array[0]

        array.forEach(function(number) {
            if (number < min) min = number
            if (number > max) max = number
        })

        var normalisedArray = []

        array.forEach(function(number) {
            var normalizedNumber = (number - min) / (max - min)
            normalisedArray.push(normalizedNumber)
        })

        return normalisedArray
    }

    function getNormalised(number, array) {
        var min = array[0]
        var max = array[0]

        array.forEach(function(number) {
            if (number < min) min = number
            if (number > max) max = number
        })

        return (number - min) / (max - min)
    }

    function getFromNormalised(normalised, array) {
        var min = array[0]
        var max = array[0]

        array.forEach(function(number) {
            if (number < min) min = number
            if (number > max) max = number
        })

        return (normalised * (max - min)) + min
    }
}
