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
                model: ["Extract Images", "Grab image pixels", "Initialise", "Train", "Test Random", "Test Simple"]

                Button {
                    text: modelData
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    Layout.preferredHeight: 32

                    onClicked: {
                        switch (text) {
                        case "Extract Images": extractImages(); break
                        case "Grab image pixels": grabImagePixels(); break
                        case "Initialise": initialise(); break
                        case "Train": train(); break
                        case "Test Random": testRandom(); break
                        case "Test Simple": testSimple(); break
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
            id: gridLt; rows: 28; columns: 28; rowSpacing: 0; columnSpacing: 0; anchors {
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

        Text {
            id: outputTxt; anchors {
                left: gridLt.right; top: gridLt.top; right: parent.right; margins: 20
            }

            wrapMode: Text.WordWrap; font.pixelSize: 19
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

            const iterTrainPaths = iterTrainNames.map(function(name) {
                return trainPath + "/" + name
            })

            const iterTestPaths = iterTestNames.map(function(name) {
                return testPath + "/" + name
            })

            trainPaths.push(iterTrainPaths)
            testPaths.push(iterTestPaths)

            trainCount += iterTrainPaths.length
            testCount += iterTestPaths.length
        }

        console.log("ImageClassifier.qml: Loaded " + trainCount + " training images and " + testCount + " testing images")
    }

    function grabImagePixels() {
        const numRandIndex = Math.floor(Math.random() * trainPaths.length)
        const numArr = trainPaths[numRandIndex]

        const randIndex = Math.floor(Math.random() * numArr.length)
        const imagePath = numArr[randIndex]

        console.log("ImageClassifier.qml: Fetching pixel data for image at path: " + imagePath)

        const pixelData = pixelExtractor.getPixelBrightnessFromImage(imagePath)
        pixelData.forEach(function(dat, index) {
            gridRep.itemAt(index).color = Qt.rgba(dat, dat, dat, 1)
        })
    }

    function initialise() {
        neural.initializeNetwork(784, 10, 498)
    }

    function train() {
        let progress = 0

        trainPaths.forEach(function(numPaths, index) {
            let outputArr = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            outputArr[index] = 1

            let outputs = [outputArr.join(" ")]

            numPaths.forEach(function(path, _index) {
                const pixelData = pixelExtractor.getPixelBrightnessFromImage(path)
                const inputs = [pixelData.join(" ")]

//                console.log(path + ":")
//                console.log("inputs: " + inputs)
//                console.log("outputs: " + outputs)

                const res = neural.train(inputs, outputs)
                console.log(`${index} > ${res}`)

//                console.log(`Trained images: ${++progress}/60000`)
            })
        })
    }

    function testRandom() {
        const numRandIndex = Math.floor(Math.random() * testPaths.length)
        const numArr = testPaths[numRandIndex]

        const randIndex = Math.floor(Math.random() * numArr.length)
        const imagePath = numArr[randIndex]

        console.log("ImageClassifier.qml: Fetching pixel data for image at path: " + imagePath)

        const pixelData = pixelExtractor.getPixelBrightnessFromImage(imagePath)
        pixelData.forEach(function(dat, index) {
            gridRep.itemAt(index).color = Qt.rgba(dat, dat, dat, 1)
        })

        const res = neural.compute([pixelData.join(" ")])
        const resArr = res[0].split(" ")

        let currentMax = 0
        let currentMaxIndex = 0

        for (let i = 0; i < resArr.length; i++) {
            const current = parseFloat(resArr[i])
            if (currentMax < current) {
                console.log(currentMax + " < " + current + " at index " + i)
                currentMax = current
                currentMaxIndex = i
            }
        }

        outputTxt.text = `<b>Neural output:</b> <br>${resArr.join("<br>")}<br><b>Output:</b> ${currentMaxIndex}`
    }

    function testSimple() {
        const baseI = [
                        "0 0 0",
                        "0 0 1",
                        "0 1 0",
                        "0 1 1",
                        "1 0 0",
                        "1 0 1",
                        "1 1 0",
                        "1 1 1"
                    ]

        const baseO = ["0", "1", "0", "1", "0", "1", "0", "1"]

        neural.initializeNetwork(3, 1, 4)

        for (let i = 0; i < 100; i++) {
            baseI.forEach(function(item, index) {
                const inputs = [item]
                const outputs = [baseO[index]]

                neural.train(inputs, outputs)
            })
        }

        baseI.forEach(function(item) {
            const inputs = [item]
            const res = neural.compute(inputs)
            console.log(JSON.stringify(item) + " > " + JSON.stringify(res))
        })
    }
}
