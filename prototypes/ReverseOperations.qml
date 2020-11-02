import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

import './Scripts/Matrix.js' as Matrix
import '../js/NeuralFunctions.js' as Nef

Item {

    property var inputs: []
    property var outputs: []
    property var weights: []

    property int min: 0
    property int max: 100

    readonly property var ops: ["+", "-", "*", "/"]

    Component.onCompleted: {
//        test()
    }

    function test() {
        weights = Nef.initializeWeights("random", 5, 2, 5)

        for (let x = 0; x < 100; x++) {
            inputs = []
            outputs = []

            for (let i = 0; i < 5; i++) {
                var a = parseInt(Math.random() * 99) + 1
                var b = parseInt(Math.random() * 99) + 1
                if (a < b) { const t = b; b = a; a = t }

                var an = _normalize(a, min, max)
                var bn = _normalize(b, min, max)

                var c = a + b
                var cn = _normalize(c, min, max * 2)

                inputs.push([an, bn, cn, 1, 0])
                outputs.push([1, 0])

                c = a - b
                cn = _normalize(c, min, max * 2)

                inputs.push([an, bn, cn, 0, 1])
                outputs.push([0, 1])
            }

            weights = Nef.trainBatch(inputs, outputs, weights, 10, 4)
        }

        console.log("Test training done")

        for (x = 0; x < 10; x++) {
            a = parseInt(Math.random() * 99) + 1
            b = parseInt(Math.random() * 99) + 1
            if (a < b) { const t = b; b = a; a = t }

            an = _normalize(a, min, max)
            bn = _normalize(b, min, max)

            let _inputs = []

            const plus = x % 2 === 0

            if (plus) {
                c = a + b
                cn = _normalize(c, min, max * 2)
                _inputs = [an, bn, cn, 1, 0]
            } else {
                c = a - b
                cn = _normalize(c, min, max * 2)
                _inputs = [an, bn, cn, 0, 1]
            }

            const res = Nef.predict(_inputs, weights)
            console.log(`${a} ${_inputs[3] === 1 ? "+" : "-"} ${b} = ${c} | ${res[0] > res[1] ? "+" : "-"} | ${res}`)
        }
    }

    function _normalize(number, min, max) {
        return (number - min) / (max - min)
    }

    function _deNormalize(normalized, min, max) {
        return (normalized * (max - min)) + min
    }
}
