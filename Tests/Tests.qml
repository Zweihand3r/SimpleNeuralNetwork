import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

import '../js/NeuralFunctions.js' as Nef

Rectangle {
    id: rootTests
    anchors.fill: parent

    StackLayout {
        id: stackLt
        anchors.fill: parent
        currentIndex: tabbar.currentIndex

        Simple {

        }

        AddNetwork {

        }

        Grid_ {

        }
    }

    RowLayout {
        width: parent.width
        anchors.bottom: parent.bottom

        RowLayout {
            Layout.fillHeight: true
            spacing: 1

            Repeater {
                model: ["Back", "Compare"]

                Button {
                    text: modelData
                    Layout.fillHeight: true
                    Layout.preferredHeight: 32
                    Layout.preferredWidth: 96
//                    visible: index !== 0
                    onClicked: {
                        switch (text) {
                        case "Back": rootTests.visible = false; break
                        case "Compare":
                            var steps = 10000

                            var inputs = [
                                        [0, 0, 0],
                                        [0, 0, 1],
                                        [0, 1, 0],
                                        [0, 1, 1],
                                        [1, 0, 0],
                                        [1, 0, 1],
                                        [1, 1, 0],
                                        [1, 1, 1]
                                    ]

                            var outputs = [[0], [0], [0], [1], [0], [1], [1], [1]]

                            var weights_ = Nef.initializeWeights("random", 3, 1, 4)
                            var weights_Batch = weights_.slice()
                            var weights_Step = weights_.slice()

                            weights_ = Nef.train(inputs, outputs, steps, 4)
                            weights_Batch = Nef.trainBatch(inputs, outputs, weights_Batch, steps, 4)

                            for (var index = 0; index < steps; index++) {
                                console.log("Training step: " + (index + 1))
                                weights_Step = Nef.trainStep(inputs, outputs, weights_Step, 4)
                            }

                            console.log("weights_: " + weights_)
                            console.log("weights_Batch: " + weights_Batch)
                            console.log("weights_Step: " + weights_Step)

                            var res_ = []
                            var res_batch = []
                            var res_step = []

                            inputs.forEach(function(input) {
                                res_.push(Nef.predict(input, weights_))
                                res_batch.push(Nef.predict(input, weights_Batch))
                                res_step.push(Nef.predict(input, weights_Step))
                            })

                            console.log("res: " + res_)
                            console.log("res_batch: " + res_batch)
                            console.log("res_step: " + res_step)
                            console.log("expected: " + outputs)
                        }
                    }
                }
            }
        }

        TabBar {
            id: tabbar
            currentIndex: 1
            Layout.fillWidth: true

            Repeater {
                model: ["Simple", "Addnetwork", "Grid"]
                TabButton { text: modelData }
            }
        }
    }
}
