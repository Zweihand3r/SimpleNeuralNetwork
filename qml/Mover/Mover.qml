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

    Component.onCompleted: function() {
        grid.create()
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
        }
    }

    /* Commands */
    function drop(x, y, orientation) {
        return perp.drop(parseInt(x), parseInt(y), parseInt(orientation))
    }

    function setCheckLogs(log) { grid.enableCheckLogs = parseInt(log) }
}
