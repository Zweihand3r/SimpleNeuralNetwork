import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

Item {
    id: rootMover
    width: parent.width
    height: parent.height

    MoverGrid {
        id: grid; anchors {
            verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 20
        }
    }

    MoverPerp { id: perp; anchors.fill: grid }

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
            Keys.onUpPressed: moveFwd()
            Keys.onLeftPressed: moveLeft()
            Keys.onRightPressed: moveRight()
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

        /* Delete later */
        initializeNetwork()
    }

    /* -------------- Network --------------- */

    function startNetwork() {}
    function stopNetwork() {}

    function networkLoop() {
        /* Train network (all surroundings regardless of movement) at every cell */
    }

    function initializeNetwork() {
        neural.initializeNetwork(3, 1, 4)

        var inputs = [
                    "0 0 1",
                    "0 1 1",
                    "1 0 1",
                    "1 1 1"
                ]

        var outputs = [
                    "0",
                    "1",
                    "1",
                    "0"
                ]

        var resTrain = neural.train(inputs, outputs, 1000)
        console.log("Mover.qml: resTrain: " + resTrain)

        /* Need a function that computes: ie only take input. */
        /* Thats for normal neural function. For mover, train and result are needed at same time */

        var res = neural.train(["1 0 1"], ["0"], 1)
        console.log("Mover.qml: res: " + res)
    }


    /* --------------- Baked ---------------- */

    function startBaked() { bakedTimer.start() }
    function stopBaked() { bakedTimer.stop() }

    function bakedLoop() {
        var fwd = !grid.checkFwd()
        var left = !grid.checkLeft()
        var right = !grid.checkRight()

        var prevX = perp.currentX
        var prevY = perp.currentY

        console.log("Mover.qml: possibleMoves at (" + perp.currentX + ", " + perp.currentY + ") > fwd: " + fwd + " left: " + left + " right: " + right)

        if (fwd) {
            if (left) { if (Math.random() > 0.75) { perp.moveLeft(); return } }
            if (right) { if (Math.random() > 0.75) { perp.moveRight(); return } }
            perp.moveFwd()
        } else {
            if (left && right) {
                if (Math.random() > 0.5) { perp.moveLeft(); return }
                perp.moveRight()
            } else if (left) perp.moveLeft()
            else perp.moveRight()
        }

        if (prevX === perp.currentX && prevY === perp.currentY) {
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
