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

    property int trainCount: 0
    property int moveCount: 0
    property int crashCount: 0

    property int perp_interval: 120

    MoverGrid {
        id: grid; anchors {
            verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 20
        }
    }

    MoverPerp {
        id: perp
        anchors.fill: grid
        moveDuration: perp_interval
        onCrashAnimCompleted: function() {
            if (panel.playActive) {
                perp.drop(originX, originY, originO)
                moveCount = 0

                if (panel.alternateNetwork) startAltNetwork()
                else startNetwork()
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
    }

    Timer {
        id: bakedTimer
        interval: perp_interval; repeat: true
        onTriggered: bakedLoop()
    }

    Timer {
        id: networkTimer
        interval: perp_interval; repeat: true
        onTriggered: networkLoop()
    }

    Timer {
        id: altNetworkTimer
        interval: perp_interval; repeat: true
        onTriggered: altNetworkLoop()
    }

    Component.onCompleted: function() {
        grid.create()
        initializeNetwork()
    }

    onVisibleChanged: function() {
        if (visible) {}
        else {
            if (bakedTimer.running) bakedTimer.stop()
            if (networkTimer.running) networkTimer.stop()
            if (altNetworkTimer.running) altNetworkTimer.stop()
        }
    }

    function setOrigin(x, y, orientation) {
        originX = x !== undefined ? x : perp.currentX
        originY = y !== undefined ? y : perp.currentY
        originO = orientation !== undefined ? orientation : perp.orientation
    }

    function resetCounters() {
        trainCount = 0
        moveCount = 0
        crashCount = 0
    }

    function logMoves(inputs, out_0, out_1, out_2) {
        panel.logMoves(inputs, out_0, out_1, out_2)
    }

    /* -------------- Network --------------- */

    function initializeNetwork() {
        if (!networkInitialised) {
            neural.initializeNetwork(3, 3)
            networkInitialised = true
        }
    }

    function startNetwork() { networkTimer.start() }
    function stopNetwork() { networkTimer.stop() }

    function networkLoop() {
        switch (panel.trainTypeIndex) {
        case 0: stepLoop(); break
        case 1: crashLoop(); break
        case 2: computeLoop(); break
        }
    }

    function stepLoop() {
        var fwd = grid.checkFwd() ? 1 : 0
        var left = grid.checkLeft() ? 1 : 0
        var right = grid.checkRight() ? 1 : 0

        var inputs = [left + " " + fwd + " " + right]
        var outputs = [(1 - left) + " " + (1 - fwd) + " " + (1 - right)]

        var res = neural.train(inputs, outputs)[0].split(" ")
        console.log("Mover.qml: stepLoop > for [" + inputs + "] network output - " + res)

        forceMover(res, inputs)
    }

    function crashLoop() {
        var fwd = grid.checkFwd() ? 1 : 0
        var left = grid.checkLeft() ? 1 : 0
        var right = grid.checkRight() ? 1 : 0

        var inputs = [left + " " + fwd + " " + right]
        var res = neural.compute(inputs)[0].split(" ")
        console.log("Mover.qml: crashLoop > for [" + inputs + "] network output - " + res)

        var left_net = parseFloat(res[0])
        var fwd_net = parseFloat(res[1])
        var right_net = parseFloat(res[2])

        var blocked = false

        if (left_net > fwd_net && left_net > right_net) {
            blocked = grid.checkLeft()
            perp.forceLeft()
        }
        else if (fwd_net > left_net && fwd_net > right_net) {
            blocked = grid.checkFwd()
            perp.forceFwd()
        }
        else if (right_net > left_net && right_net > fwd_net) {
            blocked = grid.checkRight()
            perp.forceRight()
        }

        if (blocked) {
            console.log("Mover.qml: Crash imminent. Training network")

            var outputs = [(1 - left) + " " + (1 - fwd) + " " + (1 - right)]

            neural.train(inputs, outputs)
            logMoves(inputs, left_net, fwd_net, right_net)

            trainCount += 1
        }

        moveCount += 1

        if (grid.checkCurrent()) {
            networkTimer.stop()
            perp.crash()
        }
    }

    function computeLoop() {
        var fwd = grid.checkFwd() ? 1 : 0
        var left = grid.checkLeft() ? 1 : 0
        var right = grid.checkRight() ? 1 : 0

        var inputs = [left + " " + fwd + " " + right]
        var res = neural.compute(inputs)[0].split(" ")
        console.log("Mover.qml: computeLoop > for [" + inputs + "] network output - " + res)

        forceMover(res, inputs)
    }

    function forceMover(res, inputs) {
        var left_net = parseFloat(res[0])
        var fwd_net = parseFloat(res[1])
        var right_net = parseFloat(res[2])

        if (left_net > fwd_net && left_net > right_net) {
            perp.forceLeft()
        }
        else if (fwd_net > left_net && fwd_net > right_net) {
            perp.forceFwd()
        }
        else if (right_net > left_net && right_net > fwd_net) {
            perp.forceRight()
        }

        logMoves(inputs, left_net, fwd_net, right_net)

        trainCount += 1
        moveCount += 1

        if (grid.checkCurrent()) {
            networkTimer.stop()
            perp.crash()
        }
    }

    /* -------------- Alternate Network (Needs more work) ------------- */

    function startAltNetwork() { altNetworkTimer.start() }
    function stopAltNetwork() { altNetworkTimer.stop() }

    function altNetworkLoop() {
        var fwd = grid.checkFwd() ? 1 : 0
        var left = grid.checkLeft() ? 1 : 0
        var right = grid.checkRight() ? 1 : 0

        var inputs = [left + " " + fwd + " " + right]
        var res = neural.compute(inputs)[0].split(" ")
        console.log("Mover.qml: altNetworkLoop > for [" + inputs + "] network output - " + res)

        var left_net = parseFloat(res[0])
        var fwd_net = parseFloat(res[1])
        var right_net = parseFloat(res[2])

        var outputArray = ["0", "0", "0"]

        if (left_net < 0.2 && fwd_net < 0.2 && right_net < 0.2) {
            var random = parseInt(Math.random() * 3)
            console.log("Mover.qml: No viable outputs. Moving in random direction index: " + random)
            /* Need better loop correction */

            if (random === 0) {
                if (left === 0) outputArray[0] = "1"
                perp.forceLeft()
            }
            else if (random === 1) {
                if (fwd === 0) outputArray[1] = "1"
                perp.forceFwd()
            }
            else if (random === 2) {
                if (right === 0) outputArray[2] = "1"
                perp.forceRight()
            }
        }
        else {
            if (left_net > fwd_net && left_net > right_net) {
                if (left === 0) outputArray[0] = "1"
                perp.forceLeft()
            }
            else if (fwd_net > left_net && fwd_net > right_net) {
                if (fwd === 0) outputArray[1] = "1"
                perp.forceFwd()
            }
            else if (right_net > left_net && right_net > fwd_net) {
                if (right === 0) outputArray[2] = "1"
                perp.forceRight()
            }
        }

        logMoves(inputs, left_net, fwd_net, right_net)

        trainCount += 1
        moveCount += 1

        var outputs = [outputArray.join(" ")]
        neural.train(inputs, outputs)

        if (grid.checkCurrent()) {
            altNetworkTimer.stop()
            perp.crash()
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
        var moveIndex = -1

        console.log("Mover.qml: possibleMoves at (" + perp.currentX + ", " + perp.currentY + ") > fwd: " + fwd + " left: " + left + " right: " + right)

        if (fwd) {
            if (left) { if (Math.random() > 0.75) moveIndex = 0 }
            if (right && moveIndex < 0) { if (Math.random() > 0.75) moveIndex = 2 }
            if (moveIndex < 0) moveIndex = 1
        }
        else {
            if (left && right) {
                if (Math.random() > 0.5) moveIndex = 0
                if (moveIndex < 0) moveIndex = 2
            }
            else if (left) moveIndex = 0
            else if (right) moveIndex = 2
        }

        switch (moveIndex) {
        case -1:
            bakedTimer.stop()
            perp.crash()
            panel.playActive = false
            break

        case 0: perp.moveLeft(); break
        case 1: perp.moveFwd(); break
        case 2: perp.moveRight(); break
        }

        moveCount += 1

        if (panel.trainFromBaked) {
            if (moveIndex >= 0) {
                var inputs = [(left ? 0 : 1) + " " + (fwd ? 0 : 1) + " " + (right ? 0 : 1)]

                if (panel.alternateNetwork) {
                    var outputs = ["0", "0", "0"]
                    outputs[moveIndex] = "1"
                    outputs = [outputs.join(" ")]
                }
                else outputs = [(left ? 1 : 0) + " " + (fwd ? 1 : 0) + " " + (right ? 1 : 0)]

                var res = neural.train(inputs, outputs)[0].split(" ")
                console.log("Mover.qml: At moveIndex " + moveIndex + ", trained res: " + res)

                logMoves(inputs, parseFloat(res[0]), parseFloat(res[1]), parseFloat(res[2]))

                trainCount += 1
            }
        }
    }

    /* Commands */
    function drop(x, y, orientation) {
        return perp.drop(parseInt(x), parseInt(y), parseInt(orientation))
    }

    function setCheckLogs(log) { grid.enableCheckLogs = parseInt(log) }
}
