import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import './Scripts/Giver.js' as Giver
import './Scripts/Matrix.js' as Matrix
import './Scripts/Matrix_test.js' as Matrix_t
import './Scripts/Simple.js' as MediumCode

Rectangle {
    ColumnLayout {
        anchors { fill: parent; margins: 20 }

        Button {
            text: "Call"
            onClicked: Giver.evaluate()
        }

        Button {
            text: "Matrix Multiplication Test"
            onClicked: Matrix.multiply_test()
        }

        Button {
            text: "Matrix Multiplication"
            onClicked: matrixMultiply()
        }

        Button {
            text: "Matrix Transpose"
            onClicked: matrixTranspose()
        }

        Button {
            text: "Medium.com train test"
            onClicked: MediumCode.train_test()
        }

        Button {
            text: "Matrix Add"
            onClicked: matrixAdd()
        }
    }

    function matrixMultiply() {
        var mat_A = [
                    [1, 2, 3],
                    [4, 5, 6]
                ]

        var mat_B = [
                    [7, 8],
                    [9, 10],
                    [11, 12]
                ]

        var res = Matrix_t.multiply(mat_A, mat_B)
        console.log("Result:")
        res.forEach(function(res_e) {
            console.log(res_e)
        })
    }

    function matrixAdd() {
        var mat_a = [
                    [1, 2],
                    [3, 4]
                ]

        var mat_b = [
                    [4, 3],
                    [2, 1]
                ]

        printResult(Matrix.add(mat_a, mat_b))
    }

    function matrixTranspose() {
        var mat = [
                    [1, 2, 3],
                    [4, 5, 6]
                ]

        var res = Matrix_t.transpose(mat)
        console.log("Result:")
        res.forEach(function(res_e) {
            console.log(res_e)
        })
    }

    function matrixMultiply_() {
        var mat_A = [
                    [1, 2, 3],
                    [4, 5, 6]
                ]

        var mat_B = [
                    [7, 8],
                    [9, 10],
                    [11, 12]
                ]

        var res = Matrix_t.multiply(mat_A, mat_B)
        console.log("Result:")
        res.forEach(function(res_e) {
            console.log(res_e)
        })
    }

    function matrixTranspose_() {
        var mat = [
                    [1, 2, 3],
                    [4, 5, 6]
                ]

        var res = Matrix_t.transpose(mat)
        console.log("Result:")
        res.forEach(function(res_e) {
            console.log(res_e)
        })
    }

    function printResult(res) {
        console.log("Result:")
        res.forEach(function(res_e) {
            console.log(res_e)
        })
    }
}
