import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

Item {
    id: rootMover
    width: parent.width
    height: parent.height

    property bool networkInitialised: false

    property int originX: 1
    property int originY: 1
    property int originO: 2

    MoverGrid {
        id: grid; anchors {
            verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 20
        }
    }

    MoverPerp {
        id: perp
        anchors.fill: grid
        onCrashAnimCompleted: function() {
            if (panel.playActive) {
                perp.drop(originX, originY, originO)
                startNetwork()
            }
        }
    }

    Item {
        id: controlsPanel
        width: 64; anchors {
            top: parent.top; right: parent.right; bottom: parent.bottom
            topMargin: 20; rightMargin: 0; bottomMargin: 20
        }

        MoverPanel {
            id: panel
        }
    }

    TextField {
        visible: false
        anchors { bottom: parent.bottom; right: parent.right }
        Keys.onReturnPressed: function() {
            var com_arr = text.split(" ")
            var com = com_arr.shift()
            var res = rootMover[com].apply(this, com_arr)
            if (res !== undefined) console.log("Mover.qml: res> " + res)
        }

        TextField {
            anchors { bottom: parent.top }
            Keys.onUpPressed: perp.moveFwd()
            Keys.onLeftPressed: perp.moveLeft()
            Keys.onRightPressed: perp.moveRight()
            Rectangle {
                anchors { fill: parent; margins: 8 }
                color: col_accent; visible: parent.focus
            }

            RowLayout {
                anchors { bottom: parent.top }
                Button {
                    text: bakedTimer.running ? "Stop Baked" : "Start Baked"
                    onClicked: bakedTimer.running ? bakedTimer.stop() : bakedTimer.start()
                }

                Button {
                    text: "reset Perp"; onClicked: perp.dropRandom()
                }
            }
        }
    }

    Timer {
        id: bakedTimer
        interval: 120; repeat: true
        onTriggered: bakedLoop()
    }

    Timer {
        id: networkTimer
        interval: 120; repeat: true
        onTriggered: networkLoop()
    }

    Component.onCompleted: function() {
        grid.create()
    }

    function setOrigin(x, y, orientation) {
        originX = x !== undefined ? x : perp.currentX
        originY = y !== undefined ? y : perp.currentY
        originO = orientation !== undefined ? orientation : perp.orientation
    }

    /* -------------- Network --------------- */

    function startNetwork() {
        initializeNetwork()
        networkTimer.start()
    }

    function stopNetwork() { networkTimer.stop() }

    function networkLoop() {
        var fwd = grid.checkFwd() ? 1 : 0
        var left = grid.checkLeft() ? 1 : 0
        var right = grid.checkRight() ? 1 : 0

        var inputs = [left + " " + fwd + " " + right]
        var outputs = [(1 - left) + " " + (1 - fwd) + " " + (1 - right)]

        console.log("Mover.qml: inputs: " + inputs + " >> " + outputs)

        var res = neural.train(inputs, outputs, 1)[0].split(" ")
        console.log("Mover.qml: res- " + res)

        var left_net = parseFloat(res[0])
        var fwd_net = parseFloat(res[1])
        var right_net = parseFloat(res[2])

        if (left_net > fwd_net && left_net > right_net) {
            perp.forceLeft()
//            perp.moveLeft()
        }
        else if (fwd_net > left_net && fwd_net > right_net) {
            perp.forceFwd()
//            perp.moveFwd()
        }
        else if (right_net > left_net && right_net > fwd_net) {
            perp.forceRight()
//            perp.moveRight()
        }

        if (grid.checkCurrent()) {
            networkTimer.stop()
            perp.crash()
        }
    }

    function initializeNetwork() {
        if (!networkInitialised) {
            neural.initializeNetwork(3, 3, 4)
            networkInitialised = true

//            var inputs = [
//                        "0 0 1",
//                        "0 1 1",
//                        "1 0 1",
//                        "1 1 1"
//                    ]

//            var outputs = [
//                        "1 1 0",
//                        "1 0 0",
//                        "0 1 0",
//                        "0 0 0"
//                    ]

//            var resTrain = neural.train(inputs, outputs, 1000)
//            console.log("Mover.qml: resTrain: " + resTrain)

//            /* Need a function that computes: ie only take input. */
//            /* Thats for normal neural function. For mover, train and result are needed at same time */

//            var res = neural.train(["1 0 1"], ["0 1 0"], 1)
//            console.log("Mover.qml: res: " + res)
        }
    }


    /* --------------- Baked ---------------- */

    function startBaked() { bakedTimer.start() }
    function stopBaked() { bakedTimer.stop() }

    function bakedLoop() {
        var fwd = !grid.checkFwd()
        var left = !grid.checkLeft()
        var right = !grid.checkRight()

        var moved = false

        console.log("Mover.qml: possibleMoves at (" + perp.currentX + ", " + perp.currentY + ") > fwd: " + fwd + " left: " + left + " right: " + right)

        if (fwd) {
            if (left) { if (Math.random() > 0.75) { moved = perp.moveLeft(); return } }
            if (right) { if (Math.random() > 0.75) { moved = perp.moveRight(); return } }
            moved = perp.moveFwd()
        } else {
            if (left && right) {
                if (Math.random() > 0.5) { moved = perp.moveLeft(); return }
                moved = perp.moveRight()
            } else if (left) moved = perp.moveLeft()
            else moved = perp.moveRight()
        }

        if (!moved) {
            bakedTimer.stop()
            perp.crash()

            panel.playActive = false
        }
    }

    /* Commands */
    function drop(x, y, orientation) {
        return perp.drop(parseInt(x), parseInt(y), parseInt(orientation))
    }

    function setCheckLogs(log) { grid.enableCheckLogs = parseInt(log) }
}
