import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.1

Item {
    id: rootIc

    property var trainPaths: []
    property var testPaths: []

    Rectangle {
        anchors { fill: parent; rightMargin: parent.width - 180 }

        Rectangle {
            width: 2; height: parent.height
            anchors { left: parent.right }
            color: "black"
        }

        ColumnLayout {
            anchors { left: parent.left; top: parent.top; right: parent.right; margins: 8 }

            Repeater {
                model: ["Extract Images", "Grab image pixels"]

                Button {
                    text: modelData
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    Layout.preferredHeight: 32

                    onClicked: {
                        switch (text) {
                        case "Extract Images": extractImages(); break
                        case "Grab image pixels": grabImagePixels(); break
                        }
                    }
                }
            }
        }
    }

    Item {
        anchors {
            fill: parent; leftMargin: 180
        }

        GridLayout {
            rows: 28; columns: 28; rowSpacing: 0; columnSpacing: 0; anchors {
                left: parent.left; top: parent.top; margins: 20
            }

            Repeater {
                id: gridRep
                model: 28 * 28

                Rectangle {
                    Layout.preferredWidth: 4
                    Layout.preferredHeight: 4
                }
            }
        }
    }

    function extractImages() {
        const exists = fileManager.checkIfDirExists(fileManager.currentPath + "/MNIST")
        if (!exists) {
            fileManager.extractMnist()
            console.log("ImageClassifier.qml: Extracted MNIST DB")
        } else {
            console.log("ImageClassifier.qml: MNIST DB already exists")
        }

        trainPaths = []
        testPaths = []

        let trainCount = 0
        let testCount = 0

        for (let i = 0; i < 10; i++) {
            const trainPath = fileManager.currentPath + "/MNIST/mnist_png/training/" + i
            const testPath = fileManager.currentPath + "/MNIST/mnist_png/testing/" + i

            const iterTrainNames = fileManager.getDirFileNames(trainPath, ["*.png"])
            const iterTestNames = fileManager.getDirFileNames(testPath, ["*.png"])

            iterTrainNames.forEach(function(name) {
                trainPaths.push(trainPath + "/" + name)
            })

            iterTestNames.forEach(function(name) {
                testPaths.push(testPath + "/" + name)
            })
        }

        console.log("ImageClassifier.qml: Loaded " + trainPaths.length + " training images and " + testPaths.length + " testing images")
    }

    function grabImagePixels() {
        const randIndex = Math.floor(Math.random() * trainPaths.length)
        const imagePath = trainPaths[randIndex]

        console.log("ImageClassifier.qml: Fetching pixel data for image at path: " + imagePath)

        const pixelData = pixelExtractor.getPixelBrightnessFromImage(imagePath)
        pixelData.forEach(function(dat, index) {
            gridRep.itemAt(index).color = Qt.rgba(dat, dat, dat, 1)
        })
    }
}
