import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import './Scripts/Matrix.js' as Matrix
import './Scripts/Simple.js' as SimpleScript

Item {
    width: parent.width
    height: parent.height

    property var inputs: []
    property var outputs: []
    property var weights: []
    property var weights_1: []
    property var weights_2: []

    property int trainSteps: 100

    Rectangle {
        id: sidepanel
        width: 168; height: parent.height
        color: "#000000"

        ColumnLayout {
            anchors { left: parent.left; top: parent.top; right: parent.right; margins: 8 }

            RowLayout {
                Text {
                    text: "Steps:"; color: "white"
                    Layout.alignment: Qt.AlignVCenter
                }

                TextField {
                    id: trainStepsTf
                    text: "10000"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 32
                    placeholderText: "Training Steps"
                    onEditingFinished: trainSteps = parseInt(text)
                }
            }

            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 32
                text: "Train"; onClicked: {
                    trainFromUI()
                    train2LyrFromUI()
                }
            }

            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 32
                text: "Solve 1 Layer"; onClicked: solve()
            }

            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 32
                text: "Solve 2 Layers"; onClicked: solve_2Layer()
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 2
            }

            Label {
                Layout.alignment: Qt.AlignHCenter
                text: "Tests"; color: "white"
            }

            Repeater {
                model: ["Test Solve", "Simplified", "Source Test", "Slightly Harder", "Test", "SH Test", "Script Test"]
                Button {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 32
                    text: modelData; onClicked: {
                        switch (modelData) {
                        case "Test Solve": testSolve(); break
                        case "Simplified": simplified(); break
                        case "Source Test": sourceTest(); break
                        case "Slightly Harder": slightlyHarder(); break
                        case "Test": test(); break
                        case "SH Test": slightlyHarderTest(); break
                        case "Script Test": SimpleScript.train_test(); break
                        }
                    }
                }
            }
        }
    }

    RowLayout {
        id: inputs_outputs
        anchors { left: sidepanel.right; top: parent.top; right: parent.right; bottom: parent.bottom }

        ColumnLayout {
            Repeater {
                id: repeater
                model: ["000 ->", "001 ->", "010 ->", "011 ->", "100 ->", "101 ->", "110 ->", "111 ->"]
                RowLayout {
                    property string text: modelData
                    property bool checked: radio.checked
                    property int  output: checky.checked ? 1 : 0

                    CheckBox {
                        id: radio
                        text: modelData
                        Layout.preferredWidth: 90
                    }

                    CheckBox {
                        id: checky

                        indicator: Rectangle {
                            implicitWidth: 26; implicitHeight: 26
                            x: checky.leftPadding; y: parent.height / 2 - height / 2
                            radius: 3; border.color: "#666666"

                            Rectangle {
                                width: 18; height: 18; x: 4; y: 4
                                radius: 2; color: "#666666"; visible: checky.checked
                            }

                            Text {
                                anchors.centerIn: parent; text: checky.checked ? 1 : 0
                                color: checky.checked ? "white" : "#666666"
                            }
                        }
                    }
                }
            }
        }

        ColumnLayout {
            Repeater {
                id: resultRepeater
                model: ["000 ->", "001 ->", "010 ->", "011 ->", "100 ->", "101 ->", "110 ->", "111 ->"]
                RowLayout {
                    Layout.preferredHeight: 40

                    Text {
                        Layout.alignment: Qt.AlignVCenter
                        text: modelData
                    }

                    Rectangle {
                        id: checkyOutput

                        property bool checked: false

                        Layout.alignment: Qt.AlignVCenter
                        implicitWidth: 26; implicitHeight: 26
                        radius: 3; border.color: "#666666"

                        Rectangle {
                            width: 18; height: 18; x: 4; y: 4
                            radius: 2; color: "#666666"; visible: checkyOutput.checked
                        }

                        Text {
                            anchors.centerIn: parent; text: checkyOutput.checked ? 1 : 0
                            color: checkyOutput.checked ? "white" : "#666666"
                        }
                    }

                    Text {
                        id: textOutput
                        Layout.alignment: Qt.AlignVCenter
                    }

                    function setValue(value) {
                        textOutput.text = Number(value).toFixed(4)
                        checkyOutput.checked = value > 0.5
                    }
                }
            }
        }
    }

    function trainFromUI() {
        setInputsAndOutputs()
        train()
    }

    function train2LyrFromUI() {
        setInputsAndOutputs()
        train_2Layer()
    }

    function train() {
        console.log("Training 1 Layer...")

        weights = []
        for (var index = 0; index < inputs[0].length; index++)
            weights.push((Math.random() * 2) - 1)
        console.log("Weights initialised to: " + weights)
        weights = [weights]

        for (var repeatIndex = 0; repeatIndex < trainSteps; repeatIndex++) {
            inputs.forEach(function(input, index) {
                var dot_product = Matrix.dot([input], Matrix.transpose(weights))
                var output = sigmoid(dot_product)
                var error = Matrix.subtract([outputs[index]], [output])
                var derivative = sigmoidDerivative(output)
                var error_derivative = Matrix.multiply(error, derivative)
                var adjustments = []
                for (var i = 0; i < input.length; i++) {
                    adjustments.push(input[i] * error_derivative)
                }
                adjustments = [adjustments]
                weights = Matrix.add(weights, adjustments)
            })
        }

        console.log("Weights after training: " + weights)
        console.log("Training 1 Layer complete")
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

    function solve() {
        var inputs = ["000", "001", "010", "011", "100", "101", "110", "111"]

        inputs.forEach(function(inputString, index) {
            var input = [inputString.split("")]
            var dot_product = Matrix.dot(input, Matrix.transpose(weights))
            var result = sigmoid(dot_product)

            resultRepeater.itemAt(index).setValue(result)
        })
    }

    function solve_2Layer() {
        var inputs = ["000", "001", "010", "011", "100", "101", "110", "111"]

        inputs.forEach(function(inputString, index) {
            var input = [inputString.split("")]
            var l1 = sigmoid(Matrix.dot(input, weights_1))
            var l2 = sigmoid(Matrix.dot(l1, weights_2))

            resultRepeater.itemAt(index).setValue(l2)
        })
    }

    /* -------------------------------------------------- */

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

    function setInputsAndOutputs() {
        inputs = []
        outputs = []

        for (var index = 0; index < 8; index++) {
            if (repeater.itemAt(index).checked) {
                var inputs_ = transposeStringToArray(repeater.itemAt(index).text)
                inputs.push(inputs_)
                outputs.push([repeater.itemAt(index).output])
            }
        }

        printArray(inputs, "Inputs")
        printArray(outputs, "Outputs")
    }

    function display(text) {
        leModel.append({ "txt": text })
    }

    function printArray(arr, title) {
        if (title) { console.log(title + " elements:") }
        arr.forEach(function(item) {
            console.log(item)
        })
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

    /* ------------------- Test Code -------------------- */

    function testSolve() {
        inputs = [
                    [0, 0, 0, 0],
                    [0, 0, 0, 1],
                    [0, 0, 1, 0],
                    [0, 0, 1, 1],
                    [0, 1, 0, 0],
                    [0, 1, 0, 1],
                    [0, 1, 1, 0],
                    [0, 1, 1, 1],
                    [1, 0, 0, 0],
                    [1, 0, 0, 1],
                    [1, 0, 1, 0],
                    [1, 0, 1, 1],
                    [1, 1, 0, 0],
                    [1, 1, 0, 1],
                    [1, 1, 1, 0],
                    [1, 1, 1, 1]
                ]

        outputs = [[0], [0], [0], [0], [0], [0], [0], [1], [0], [0], [0], [1], [0], [1], [1], [1]]

        train_2Layer()

        inputs.forEach(function(input) {
            var l1 = sigmoid(Matrix.dot([input], weights_1))
            var l2 = sigmoid(Matrix.dot(l1, weights_2))
            console.log("Input " + input + " >>> " + l2)
        })
    }

    function simplified() {
        var inputs = [[0,0,1], [1,1,1], [1,0,1], [0,1,1]]
        var outputs = Matrix.transpose([[0, 1, 1, 0]])

        var weights = []
        for (var index = 0; index < inputs[0].length; index++)
            weights.push((Math.random() * 2) - 1)
        console.log("Weights initialised to: " + weights)
        weights = [weights]

        for (var repeatIndex = 0; repeatIndex < 10000; repeatIndex++) {
            inputs.forEach(function(input, index) {
                //                console.log(input, outputs[index])

                var dot_product = Matrix.dot([input], Matrix.transpose(weights))
                //                console.log("Dot Product:", dot_product)

                var output = sigmoid(dot_product)
                //                console.log("Sigmoid Output:", output)

                var error = Matrix.subtract([outputs[index]], [output])
                //                console.log("Error:", error)

                var derivative = sigmoidDerivative(output)
                //                console.log("Derivative:", derivative)

                var error_derivative = Matrix.multiply(error, derivative)
                //                console.log("Error x Derivative:", error_derivative)

                var adjustments = []
                for (var i = 0; i < input.length; i++) {
                    adjustments.push(input[i] * error_derivative)
                }
                adjustments = [adjustments]
                //                console.log("Adjustments:", adjustments)

                weights = Matrix.add(weights, adjustments)
                //                console.log("Adjusted Weights:", weights)
            })
        }

        console.log("Weights after training: " + weights)

        var dot_product = Matrix.dot([[1, 0, 0]], Matrix.transpose(weights))
        console.log("For input [1, 0, 0]: " + sigmoid(dot_product))
    }

    function sourceTest() {
        // Training input
        var X = [
                    [0,0,1],
                    [0,1,1],
                    [1,0,1],
                    [1,1,1]
                ]

        // Training output
        var y = Matrix.transpose([[0,0,1,1]])

        // Weights
        var syn0 = random(3, 1)
        console.log("Weights initialised to: " + syn0)

        for (var iter = 0; iter < 10000; iter++) {
            var l0 = X.slice()
            var l1 = sigmoid(Matrix.dot(l0, syn0))

            var l1_error = Matrix.subtract(y, l1)

            var l1_delta = Matrix.multiply(l1_error, sigmoidDerivative(l1))

            syn0 = Matrix.add(syn0, Matrix.dot(Matrix.transpose(l0), l1_delta))
        }

        console.log("Output after training: " + l1)
    }

    function slightlyHarder() {
        var X = [
                    [0,0,1],
                    [0,1,1],
                    [1,0,1],
                    [1,1,1]
                ]

        var y = Matrix.transpose([[0,1,1,0]])

        var syn0 = random(3, 4)
        printArray(syn0, "Syn0")

        var syn1 = random(4, 1)
        printArray(syn1, "Syn1")

        for (var index = 0; index < 60000; index++) {
            var l0 = X.slice()
            var l1 = sigmoid(Matrix.dot(l0, syn0))
            //            printArray(l1, "l1")

            var l2 = sigmoid(Matrix.dot(l1, syn1))
            //            printArray(l2, "l2")

            var l2_error = Matrix.subtract(y, l2)
            //            printArray(l2_error, "l2 error")

            if (index % 1000 === 0) {
                console.log("Error: " + l2_error)
                //                var sum_ = 0
                //                for (var index_ in l2_error[0]) {
                //                    sum_ += Math.abs(l2_error[0][index_])
                //                }
                //                console.log("Error: " + sum_ / l2_error[0].length)
            }

            var l2_delta = Matrix.multiply(l2_error, sigmoidDerivative(l2))
            //            printArray(l2_delta, "l2 delta")

            var l1_error = Matrix.dot(l2_delta, Matrix.transpose(syn1))
            //            printArray(l1_error, "l1 error")

            var l1_delta = Matrix.multiply(l1_error, sigmoidDerivative(l1))
            //            printArray(l1_delta, "l1 delta")

            syn1 = Matrix.add(syn1, Matrix.dot(Matrix.transpose(l1), l2_delta))
            syn0 = Matrix.add(syn0, Matrix.dot(Matrix.transpose(l0), l1_delta))
            //            printArray(syn1, "syn1")
            //            printArray(syn0, "syn0")
        }

        l1 = sigmoid(Matrix.dot([[1,1,1]], syn0))
        l2 = sigmoid(Matrix.dot(l1, syn1))
        console.log(l2)
    }

    function test() {
        var weights = []
        var inputs = [[0,0,1], [1,1,1], [1,0,1], [0,1,1]]
        var outputs = Matrix.transpose([[0, 1, 1, 0]])

        for (var index = 0; index < inputs[0].length; index++)
            weights.push((Math.random() * 2) - 1)
        console.log("Weights initialised to: " + weights)
        weights = [weights]

        //        weights = [[-0.2, 0.1, 0.3]]

        for (var index = 0; index < 10000; index++) {
            var dot_product = Matrix.dot(inputs, Matrix.transpose(weights))
            //            printArray(dot_product, "Dot Product")

            var output = sigmoid(dot_product)
            //            printArray(output, "Sigmoid Output")

            var error = Matrix.subtract(outputs, output)
            //            printArray(error, "Error")

            var derivative = sigmoidDerivative(output)
            //            printArray(derivative, "Sigmoid Derivative")

            var error_derivative = Matrix.multiply(error, derivative)
            //            printArray(error_derivative, "Error x Drivative")

            var adjustment = Matrix.dot(Matrix.transpose(inputs), error_derivative)
            //            printArray(adjustment, "Adjustment")

            weights = Matrix.add(weights, Matrix.transpose(adjustment))
            //            printArray(weights, "Weights after adjustment")
        }

        console.log("Weights after training: " + weights)

        dot_product = Matrix.dot([[1, 0, 0]], Matrix.transpose(weights))
        console.log("For input [1, 0, 0]: " + sigmoid(dot_product))
    }

    function slightlyHarderTest() {
        var X = [
                    [0,0,1],
                    [0,1,1],
                    [1,0,1],
                    [1,1,1]
                ]

        var y = Matrix.transpose([[0,1,1,0]])

        var syn0 = [
                    [0.1, 0.3, -0.25, 0.2],
                    [-0.4, 0.2, -0.3, 0.12],
                    [0.125, -0.7, -0.12, 0.4]
                ]

        var syn1 = [
                    [0.24],
                    [-0.14],
                    [0.4],
                    [-0.6]
                ]

        for (var index = 0; index < 1; index++) {
            var l0 = X.slice()
            var l1 = sigmoid(Matrix.dot(l0, syn0))
            printArray(l1, "l1")

            var l2 = sigmoid(Matrix.dot(l1, syn1))
            printArray(l2, "l2")

            var l2_error = Matrix.subtract(y, l2)
            printArray(l2_error, "l2 error")

            if (index % 1000 === 0) {
                console.log("Error: " + l2_error)
                //                var sum_ = 0
                //                for (var index_ in l2_error[0]) {
                //                    sum_ += Math.abs(l2_error[0][index_])
                //                }
                //                console.log("Error: " + sum_ / l2_error[0].length)
            }

            var l2_delta = Matrix.multiply(l2_error, sigmoidDerivative(l2))
            printArray(l2_delta, "l2 delta")

            var l1_error = Matrix.dot(l2_delta, Matrix.transpose(syn1))
            printArray(l1_error, "l1 error")

            var l1_delta = Matrix.multiply(l1_error, sigmoidDerivative(l1))
            printArray(l1_delta, "l1 delta")

            syn1 = Matrix.add(syn1, Matrix.dot(Matrix.transpose(l1), l2_delta))
            syn0 = Matrix.add(syn0, Matrix.dot(Matrix.transpose(l0), l1_delta))
            //            printArray(syn1, "syn1")
            //            printArray(syn0, "syn0")
        }

        l1 = sigmoid(Matrix.dot([[0,1,1]], syn0))
        l2 = sigmoid(Matrix.dot(l1, syn1))
        console.log(l2)
    }
}
