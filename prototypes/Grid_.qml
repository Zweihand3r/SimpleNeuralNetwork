import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

import '../js/Permutation.js' as Permute
import '../js/NeuralFunctions.js' as Nfunc

Item {
    id: rootGrid

    property int rows: 10
    property int cols: 10

    property var population: []

    /*
     *   0
     * 3 * 1
     *   2
     */
    property int orientation: 0

    property var moves: []
    property var weights: []

    property var trainOutputs: []

    property int movetime: 80
    property bool busy: false

    Item {
        id: sidepanel
        width: 240
        height: parent.height

        ColumnLayout {
            Repeater {
                model: ["000", "001", "010", "011", "100", "101", "110", "111"]
                RowLayout {
                    Layout.preferredHeight: 32;
                    Toggle { clickable: false; checked: parseInt(modelData.charAt(0)) === 1; Layout.alignment: Qt.AlignBottom }
                    Toggle { clickable: false; checked: parseInt(modelData.charAt(1)) === 1 }
                    Toggle { clickable: false; checked: parseInt(modelData.charAt(2)) === 1; Layout.alignment: Qt.AlignBottom }

                    Text { text: ">>"; Layout.alignment: Qt.AlignVCenter }

                    Toggle { Layout.alignment: Qt.AlignBottom; onCheckedChanged: trainOutputs[index][0] = checked ? 1 : 0 }
                    Toggle {                                   onCheckedChanged: trainOutputs[index][1] = checked ? 1 : 0 }
                    Toggle { Layout.alignment: Qt.AlignBottom; onCheckedChanged: trainOutputs[index][2] = checked ? 1 : 0 }
                }
            }

            Button {
                text: "Train"
                onClicked: train("10")
            }

            Button {
                text: (ai_timer.running ? "Stop" : "Start") + " AI"
                onClicked: {
                    if (ai_timer.running) ai_timer.stop()
                    else ai_timer.start()
                }
            }
        }
    }

    Item {
        anchors { fill: parent; leftMargin: sidepanel.width }

        Item {
            id: grid
            anchors.centerIn: parent

            Rectangle {
                anchors { fill: parent; margins: -6 }
                border { width: 4; color: "black" }
            }
        }

        Item {
            anchors.fill: grid

            Rectangle {
                id: perp
                width: 34
                height: 34
                color: "#CA3434"
                visible: false

                property int _x: -1
                property int _y: -1

                Behavior on x { NumberAnimation { duration: movetime; easing.type: Easing.InCubic } }
                Behavior on y { NumberAnimation { duration: movetime; easing.type: Easing.InCubic } }

                TextField {
                    id: stealer
                    anchors.fill: parent
                    background: Item {}

                    Keys.onLeftPressed: movement("lt")
                    Keys.onUpPressed: movement("up")
                    Keys.onRightPressed: movement("rt")
                    Keys.onDownPressed: movement("dn")

                    Keys.onPressed:  {
                        switch (event.key) {
                        case Qt.Key_W: movefwd(); break
                        case Qt.Key_A: turnLeft(); break
                        case Qt.Key_D: turnRight(); break
                        }
                    }
                }

                Rectangle {
                    id: perpRotator
                    radius: width / 2; color: "#FFFFFF"
                    anchors { fill: parent; margins: 4 }

                    Behavior on rotation { RotationAnimation { duration: movetime; easing.type: Easing.InCubic } }

                    Rectangle {
                        width: 4
                        color: "#CA3434"
                        radius: width / 2
                        height: parent.height / 2
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                MouseArea {
                    id: clicky
                    anchors.fill: parent
                }
            }
        }
    }

    RowLayout {
        anchors { right: parent.right }
        TextField {
            id: tf
            implicitWidth: 240
            Layout.fillWidth: true

            Keys.onReturnPressed: {
                switch (text[0]) {
                case ":":
                    var args = []
                    var func = text.substring(1).split(' ')
                    func.forEach(function(arg, index) {
                        if (index > 0) args.push(arg)
                    })

                    try { rootGrid[func[0]].apply(this, args) }
                    catch (e) { console.log(e) }
                    break
                }

                selectAll()
            }

            Keys.onTabPressed: stealer.forceActiveFocus()
        }
    }

    Component.onCompleted: {
        population = []

        grid.width = cols * 34 - 2
        grid.height = rows * 34 - 2

        for (var y = 0; y < rows; y++) {
            var row = []

            for (var x = 0; x < cols; x++) {
                var cell = Qt.createQmlObject('import QtQuick 2.7;
                                               Rectangle {
                                                    x: ' + x + ' * 34; y: ' + y + ' * 34;
                                                    width: 32; height: 32; color: "#000000"
                                               }', grid, 'grid_' + x + '_' + y)
                row.push(cell)
            }

            population.push(row)
        }

        draw("rand", 1)

        for (var index = 0; index < 8; index++) {
            trainOutputs.push([0, 0, 0])
        }
    }

    function mark(x, y, alive) {
        cell(x, y).visible = alive === "1" ? true : false
    }

    function draw(type, modifier) {
        switch (type) {
        case "rand":
            if (modifier === undefined) modifier = 5
            population.forEach(function(row) {
                row.forEach(function(cell) {
                    cell.visible = Math.random() > (10 - modifier) / 10
                })
            })
            break
        }
    }

    function drop(x, y) {
        move(parseInt(x), parseInt(y))
        perp.visible = true
    }

    function move(x, y) {
        perp.x = population[y][x].x - 1
        perp.y = population[y][x].y - 1

        perp._x = x
        perp._y = y
    }

    function cell(x, y) {
        return population[parseInt(y)][parseInt(x)]
    }

    function check(x, y) {
        if (x < 0 || x > cols - 1) return true
        if (y < 0 || y > rows - 1) return true

        return population[y][x].visible
    }

    function start(ai) {
        if (ai === "ai") {
            ai_timer.start()
            return
        }

        movementTimer.start()
    }

    function stop(ai) {
        if (ai === "ai") {
            ai_timer.stop()
            return
        }

        movementTimer.stop()
    }

    function movefwd() {
        var dir = ""

        switch (orientation) {
        case 0: dir = "up"; break
        case 1: dir = "rt"; break
        case 2: dir = "dn"; break
        case 3: dir = 'lt'; break
        }

        var status = movement(dir)
        console.log("Moved fwd: " + status)

        return status
    }

    function turnLeft() {
        if (orientation < 1) orientation = 3
        else orientation--

        perpRotator.rotation -= 90
        console.log("Turned left")
    }

    function turnRight() {
        if (orientation > 2) orientation = 0
        else orientation++

        perpRotator.rotation += 90
        console.log("Turned right")
    }

    function getfwd() {
        var x = perp._x
        var y = perp._y

        switch (orientation) {
        case 0: return check(x, y - 1) ? 1 : 0
        case 1: return check(x + 1, y) ? 1 : 0
        case 2: return check(x, y + 1) ? 1 : 0
        case 3: return check(x - 1, y) ? 1 : 0
        }
    }

    function getLeft() {
        var x = perp._x
        var y = perp._y

        switch (orientation) {
        case 0: return check(x - 1, y) ? 1 : 0
        case 1: return check(x, y - 1) ? 1 : 0
        case 2: return check(x + 1, y) ? 1 : 0
        case 3: return check(x, y + 1) ? 1 : 0
        }
    }

    function getRight() {
        var x = perp._x
        var y = perp._y

        switch (orientation) {
        case 0: return check(x + 1, y) ? 1 : 0
        case 1: return check(x, y + 1) ? 1 : 0
        case 2: return check(x - 1, y) ? 1 : 0
        case 3: return check(x, y - 1) ? 1 : 0
        }
    }

    function mapMovement(outputs, type) {
        switch (type) {
        case "weights": return map_weightsbased(outputs)
        }

        return true
    }

    function map_weightsbased(outputs) {
        var max = Math.max(outputs[0], outputs[1], outputs[2])
        var index = outputs.indexOf(max)

        switch (index) {
        case 0: turnLeft(); break
        case 2: turnRight(); break
        }

        return movefwd()
    }

    function movement(dir) {
        var x = perp._x
        var y = perp._y

        switch (dir) {
        case "lt":
            if (!check(x - 1, y)) {
                move(x - 1, y)
            } else return false
            break

        case "up":
            if (!check(x, y - 1)) {
                move(x, y - 1)
            } else return false
            break

        case "rt":
            if (!check(x + 1, y)) {
                move(x + 1, y)
            } else return false
            break

        case "dn":
            if (!check(x, y + 1)) {
                move(x, y + 1)
            } else return false
            break
        }

        return true
    }

    Timer {
        id: movementTimer

        repeat: true
        interval: movetime + 10
        onTriggered: applyMoves()
    }

    Timer {
        id: ai_timer
        repeat: true
        interval: movetime + 10
        onTriggered: ai_Moves()
    }

    function ai_Moves() {
        var input = [getLeft(), getfwd(), getRight()]
        var output = Nfunc.predict(input, weights)

        if (!mapMovement(output, "weights")) {
            ai_timer.stop()
            console.log("Perp crashed")
        }
    }

    function applyMoves() {
        if (moves.length > 0) {
            rootGrid[moves[0]]()
            moves.shift()
        }
    }


    /* Network stuff */

    function train(times) {
        var mat = []
        var mat_ = []
        var inputs = []
        var outputs = trainOutputs.slice()
        var steps = 1000

        if (times !== undefined) steps = parseInt(times)

        for (var index = 0; index < 3; index++) {
            mat.push([0, 1])
            mat_.push([1, 0])
        }

        inputs = Permute.variant(mat)

        weights = Nfunc.train(inputs, outputs, steps, 6)

        inputs.forEach(function(input, index) {
            var netout = Nfunc.predict(input, weights)
            console.log(netout)
        })
    }

    function getInputs() {
        return [getLeft(), getfwd(), getRight()]
    }
}
