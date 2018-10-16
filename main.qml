import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import FileManager 1.1

import './qml/Switches'
import './Tests'

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Simple Neural Network")

    /* UI */

    Tests {
        id: tests
//        visible: false
    }

    Switches {
        id: swithes
        visible: false
    }

    FileManager {
        id: fileManager
    }

    Component.onCompleted: {
//        var inputs = [
//                    [1, 0, 0],
//                    [1, 0, 1],
//                    [1, 1, 0],
//                    [1, 1, 1],
//                ]

//        var outputs = [
//                    [0],
//                    [1],
//                    [0],
//                    [1]
//                ]

//        var res = NeuralFunctions.train(inputs, outputs, 10000)
//        console.log(NeuralFunctions.predict([0, 1, 0], res))
    }

    function printArray(arr, title) {
        if (title) { console.log(title) }
        arr.forEach(function(item) {
            console.log(item)
        })
    }
}
