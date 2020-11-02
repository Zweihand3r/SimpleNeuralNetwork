import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtCharts 2.1

import './Scripts/Matrix.js' as Matrix
import '../js/NeuralFunctions.js' as Nef

Item {

    property var inputs: []
    property var outputs: []
    property var weights: []
    property var weights_1: []
    property var weights_2: []
    property int trainSteps: parseInt(testStepTf.text)

    property int loopIndex: 0
    property int operatorIndex: 0

    property int maxLoops: parseInt(testLoopsTf.text)
    property int stepsTrained: 0

    property int min: 0
    property int max: 100

    property int totalRandomOpsGenerated: 0
    property real totalDiff: 0
    property real avgDiff: 0

    property bool randomiseInputs: true

    property var logs: []

    Rectangle {
        anchors { fill: parent; rightMargin: parent.width - 180 }
        color: "#FFFFFF"

        Rectangle {
            width: 2; height: parent.height
            anchors { left: parent.right }
            color: "black"
        }

        ColumnLayout {
            anchors { left: parent.left; top: parent.top; right: parent.right; margins: 8 }

            RowLayout {
                Text { text: "Operator:" }

                ComboBox {
                    model: ["+", "-", "*", "/"]
                    Layout.preferredHeight: 30; Layout.fillWidth: true

                    onActivated: operatorIndex = currentIndex
                }
            }

            Repeater {
                model: ["Initialize", "Train", "Generate Random Ops"]

                Button {
                    text: modelData
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    Layout.preferredHeight: 32

                    onClicked: {
                        switch (text) {
                        case "Initialize": initialize(); break
                        case "Train": train(); break
                        case "Generate Random Ops": generateRandom(); break
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Train Steps:"
                    Layout.alignment: Qt.AlignVCenter
                }

                TextField {
                    id: testStepTf
                    text: "10"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 32
                    validator: RegExpValidator { regExp: /[0-9]+/ }
                }
            }

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Train Loops:"
                    Layout.alignment: Qt.AlignVCenter
                }

                TextField {
                    id: testLoopsTf
                    text: "1000"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 32
                    validator: RegExpValidator { regExp: /[0-9]+/ }
                }
            }

            Rectangle {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: 2; color: "black"
            }

            Text {
                text: "Tests"
            }

            Repeater {
                model: ["Normalize Test", "Add Net Test"]

                Button {
                    text: modelData
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    Layout.preferredHeight: 32

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

                            for (var index = 0; index < array_A.length; index++) {
                                array_Sum.push(array_A[index] + array_B[index])
                            }

                            /* for in array causing function() in array */

                            var normalized_A = normalize(array_A)
                            var normalized_B = normalize(array_B)
                            var normalized_Sum = normalize(array_Sum)

                            inputs = []
                            outputs = []
                            for (index = 0; index < normalized_A.length; index++) {
                                console.log("normalisedA" + normalized_A[index])
                                inputs.push([normalized_A[index], normalized_B[index]])
                                outputs.push([normalized_Sum[index]])
                            }

                            printArray(inputs, "Inputs")
                            printArray(outputs, "Outputs")

                            train_2Layer()

                            var a = [1, 14, 55, 73, 54, 23, 10, 26, 64, 85]
                            var b = [21, 28, 93, 2, 74, 52, 32, 77, 12, 5]

                            for (index = 0; index < a.length; index++) {
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

    Item {
        anchors { fill: parent; leftMargin: 180 }

        Text {
            id: mainText
            anchors.centerIn: parent
            font.pixelSize: 21
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        ColumnLayout {
            anchors.centerIn: parent

            Repeater {
                id: sumsRepeater
                model: 10

                RowLayout {
                    property string text: "1 + 1 = 2 | 1.999"
                    property var numbers: [1, 1]

                    Text {
                        font.pixelSize: 21
                        text: parent.text
                    }

                    Button {
                        text: "Graph"
                        Layout.preferredHeight: 32
                        onClicked: logResult(parent.numbers[0], parent.numbers[1])
                    }
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                Text { text: "Average Diff (This Cycle): " }
                Text { id: avgCycleText; text: "1.99" }
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                Text { text: "Average Diff (Cumulative): " }
                Text { id: avgText; text: avgDiff.toFixed(3) }
            }
        }
    }

    Item {
        id: chartFrame
        visible: false
        anchors { fill: parent; leftMargin: 180 }

        ChartView {
            id: chartView
            anchors { fill: parent }
            theme: ChartView.ChartThemeBlueIcy
            antialiasing: true

            LineSeries {
                id: lineSeries
                name: "Network Output"
                axisX: xAxis
                axisY: yAxis
            }

            LineSeries {
                id: avgSeries
                name: "Network Average"
                axisX: xAxis
                axisY: yAxis
            }

            LineSeries {
                id: actualSeries
                axisX: xAxis
                axisY: yAxis
                color: "#EC1111"
            }

            ValueAxis {
                id: xAxis
            }

            ValueAxis {
                id: yAxis
            }
        }

        RowLayout {
            anchors { bottom: parent.bottom }

            Button {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                padding: 0
                text: "+"

                onClicked: chartView.zoomIn()
            }

            Button {
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
                padding: 0
                text: "-"

                onClicked: chartView.zoomOut()
            }

            Button {
                Layout.preferredHeight: 32
                padding: 0
                text: "Exit"

                onClicked: chartFrame.visible = false
            }
        }
    }

    Item {
        anchors.fill: parent
        visible: trainTimer.running

        Rectangle {
            anchors.fill: parent
            color: "black"; opacity: 0.95

            ProgressBar {
                anchors.centerIn: parent
                from: 0; to: maxLoops; value: loopIndex
            }
        }
    }

    Timer {
        id: trainTimer
        repeat: true
        interval: 10
        onTriggered: trainLoop()
    }

    function initialize() {
        weights = Nef.initializeWeights("random", 2, 1, 4)

        loopIndex = 0
        stepsTrained = 0
        logs = []

        totalRandomOpsGenerated = 0
        totalDiff = 0
        avgDiff = 0
    }

    function train() {
        if (weights.length === 0) {
            console.log("Weights not initialized")
            return
        }

        loopIndex = 0
        var arr_a = []
        var arr_b = []
        var arr_c = []

        console.log("Actual Values for session " + loopIndex)
        for (var index = 0; index < 10; index++) {
            var a = parseInt(Math.random() * 99) + 1
            var b = parseInt(Math.random() * 99) + 1

            if (a < b) {
                const c = b
                b = a
                a = c
            }

            console.log(operationString(a, b))

            arr_a.push(_normalize(a, min, max))
            arr_b.push(_normalize(b, min, max))
            arr_c.push(_normalize(operation(a, b), min, getMax()))
        }

        inputs = []
        outputs = []
        for (index = 0; index < arr_a.length; index++) {
            inputs.push([arr_a[index], arr_b[index]])
            outputs.push([arr_c[index]])
        }

        initializeLoop()
        trainTimer.start()
    }

    function initializeLoop() {
        var a = 0
        var b = 0
        var arr_a = []
        var arr_b = []
        var arr_c = []

        if (randomiseInputs) {
            console.log("Actual Values for loop " + loopIndex)
            for (var index = 0; index < 10; index++) {
                a = parseInt(Math.random() * 99) + 1
                b = parseInt(Math.random() * 99) + 1

                if (a < b) {
                    const c = b
                    b = a
                    a = c
                }

                console.log(operationString(a, b))

                arr_a.push(_normalize(a, min, max))
                arr_b.push(_normalize(b, min, max))
                arr_c.push(_normalize(operation(a, b), min, getMax()))
            }

            inputs = []
            outputs = []
            for (index = 0; index < arr_a.length; index++) {
                inputs.push([arr_a[index], arr_b[index]])
                outputs.push([arr_c[index]])
            }
        }

        printArray(inputs, "Inputs")
        printArray(outputs, "Outputs")
    }

    function trainLoop() {
        if (loopIndex < maxLoops) {
            weights = Nef.trainBatch(inputs, outputs, weights, trainSteps, 4)

            loopIndex += 1

            logWeights()
            initializeLoop()
        }
        else {
            trainTimer.stop()
        }
    }

    function _normalize(number, min, max) {
        return (number - min) / (max - min)
    }

    function _deNormalize(normalized, min, max) {
        return (normalized * (max - min)) + min
    }

    function logWeights() {
        logs.push(weights)
    }

    function logResult(a, b) {
        var results = []
        var a_norm = _normalize(a, min, max)
        var b_norm = _normalize(b, min, max)
        var loopIndex = 0
        var yMin = 200
        var yMax = 0

        lineSeries.clear()
        avgSeries.clear()
        actualSeries.clear()

        var avg = 0

        logs.forEach(function(weights, index) {
            var res_norm = Nef.predict([a_norm, b_norm], weights)
            var res = _deNormalize(res_norm, min, getMax())

            yMin = Math.min(yMin, res)
            yMax = Math.max(yMax, res)

            lineSeries.append(index, res)

            results.push(res)

            avg += res
        })

        avg = Number(avg / (logs.length - 1)).toFixed(2)

        actualSeries.append(0, operation(a, b))
        actualSeries.append(logs.length - 1, operation(a, b))
        actualSeries.name = "Actual: " + operationString(a, b)

        avgSeries.append(0, avg)
        avgSeries.append(logs.length - 1, avg)
        avgSeries.name = "Avg: " + avg

        xAxis.min = 0
        xAxis.max = logs.length

        yAxis.min = yMin
        yAxis.max = yMax

        chartFrame.visible = true

        return results
    }

    function generateRandom() {
        if (weights.length === 0) {
            console.log("Weights not initialized")
            return
        }

        mainText.text = ""

        let cycleAvg = 0

        for (var index = 0; index < 10; index++) {
            var a = parseInt(Math.random() * 100)
            var b = parseInt(Math.random() * 100)
            if (a < b) { const c = b; b = a; a = c }
            const opOut = operation(a, b)
            var inputs = [_normalize(a, min, max), _normalize(b, min, max)]
            var res_normal = Nef.predict(inputs, weights)
            var res = _deNormalize(res_normal, min, getMax())

//            mainText.text += (a + " + " + b + " = " + (a + b) + " | " + res + "\n")
            sumsRepeater.itemAt(index).text = operationString(a, b) + " | " + res.toFixed(4)
            sumsRepeater.itemAt(index).numbers = [a, b]

            totalDiff += Math.abs(res - opOut)
            totalRandomOpsGenerated += 1

            cycleAvg += Math.abs(res - opOut)
        }

        avgDiff = totalDiff / totalRandomOpsGenerated
        avgCycleText.text = Number(cycleAvg / 10).toFixed(3)
    }

    function operation(a, b) {
        switch (operatorIndex) {
        case 0: return a + b
        case 1: return a - b
        case 2: return a * b
        case 3: return a / b
        }
    }

    function operationString(a, b) {
        switch (operatorIndex) {
        case 0: return `${a} + ${b} = ${a + b}`
        case 1: return `${a} - ${b} = ${a - b}`
        case 2: return `${a} * ${b} = ${a * b}`
        case 3: return `${a} / ${b} = ${a / b}`
        }
    }

    function getMax() {
        switch (operatorIndex) {
        case 0: return max * 2
        case 2: return Math.pow(max, 2)
        default: return max
        }
    }


    /* Testing */

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

            console.log("Trained step: " + (index + 1))
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
