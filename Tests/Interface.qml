import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import './Scripts/Giver.js' as Giver
import './Scripts/Matrix.js' as Matrix
import './Scripts/Matrix_test.js' as Matrix_t
import './Scripts/Simple.js' as MediumCode

Rectangle {
    RowLayout {
        anchors { fill: parent; margins: 20 }

        ColumnLayout {
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "Tests"; font.pixelSize: 21
            }

            Repeater {
                model: ["Call", "Matrix Multiplication", "Matrix Transpose", "Medium.com train test", "Matrix Add"]
                Button {
                    text: modelData
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    onClicked: {
                        switch (text) {
                        case "Call": Giver.evaluate(); break
                        case "Matrix Multiplication": matrixMultiply(); break
                        case "Matrix Transpose": matrixTranspose(); break
                        case "Medium.com train test": MediumCode.train_test(); break
                        case "Matrix Add": matrixAdd(); break
                        }
                    }
                }
            }
        }

        Rectangle {
            color: "black"
            Layout.preferredWidth: 2; Layout.preferredHeight: parent.height
        }

        ColumnLayout {
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "Cpp Js Comparisions"; font.pixelSize: 21
            }

            Button {
                text: "Matrix Multiplication Test"
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                onClicked: {
                    var mat_A = [
                                "1 2 3",
                                "4 5 6",
                                "1 1 1",
                                "1 1 1"
                            ]

                    var mat_B = [
                                "7 8 1 1",
                                "9 10 1 1",
                                "11 12 1 1"
                            ]

                    var cppRes = cppTests.testDot(mat_A, mat_B);
                    console.log("Interface.qml: Dot cpp res: ")
                    printArray(cppRes)

                    var res = Matrix_t.multiply(toVector(mat_A), toVector(mat_B))
                    console.log("Interface.qml: Dot js res: ")
                    printArray(res)
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                Repeater {
                    model: ["Add", "Sub", "Mul"]
                    Button {
                        text: modelData
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignTop
                        onClicked: {
                            var mat_A = [
                                        "1 1 1",
                                        "1 1 1"
                                    ]

                            var mat_B = [
                                        "2 3 4",
                                        "5 6 7"
                                    ]

                            var opIndex = 0

                            switch (text) {
                            case "Sub": opIndex = 1; break
                            case "Mul": opIndex = 2; break
                            }

                            var res = cppTests.testBasicOperation(mat_A, mat_B, opIndex)
                            printArray(res)
                        }
                    }
                }
            }

            Repeater {
                model: ["Transpose"]
                Button {
                    text: modelData
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    onClicked: {
                        switch (text) {
                        case "Transpose":
                            var str = [
                                        "1 2 3",
                                        "4 5 6"
                                    ]

                            var cppres = cppTests.testTranspose(str)
                            console.log("Interface.qml: cppRes:")
                            printArray(cppres)

                            var res = Matrix.transpose(toVector(str))
                            console.log("Interface.qml: res: ")
                            printArray(res)
                        }
                    }
                }
            }
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

    function toVector(strList) {
        var vector = []
        strList.forEach(function(str) {
            var tempArr = str.split(" ")
            var row = []

            tempArr.forEach(function(num) {
                row.push(parseFloat(num))
            })

            vector.push(row)
        })
        return vector
    }
}
