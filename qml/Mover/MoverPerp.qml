import QtQuick 2.7

Item {
    id: rootPerp
    implicitWidth: 128
    implicitHeight: 128

    /*
     *   0
     * 3 * 1
     *   2
     */
    property int orientation: 2

    property int currentX: 1
    property int currentY: 1

    property int moveDuration: 120

    property int crashIndex: 0

    property bool crashed: false

    readonly property Item head: perp_head
    readonly property Item neck: perp_neck
    readonly property Item body: perp_body
    readonly property Item feet: perp_feet

    readonly property var parts: ["head", "neck", "body", "feet"]

    signal crashAnimCompleted()

    Item {
        id: perp_feet; x: 24; y: 24; width: 24; height: 24

        Rectangle {
            anchors.centerIn: parent; width: 18; height: 18; radius: 2; color: col_accent
            Behavior on color { enabled: !dataManager.animDisabled; ColorAnimation { duration: 120 }}
        }

        Behavior on x { enabled: !dataManager.animDisabled; NumberAnimation { duration: moveDuration } }
        Behavior on y { enabled: !dataManager.animDisabled; NumberAnimation { duration: moveDuration } }
    }

    Item {
        id: perp_body; x: 24; y: 24; width: 24; height: 24

        Rectangle {
            anchors.centerIn: parent; width: 18; height: 18; radius: 2; color: col_accent
            Behavior on color { enabled: !dataManager.animDisabled; ColorAnimation { duration: 120 }}
        }

        Behavior on x { enabled: !dataManager.animDisabled; NumberAnimation { duration: moveDuration } }
        Behavior on y { enabled: !dataManager.animDisabled; NumberAnimation { duration: moveDuration } }
    }

    Item {
        id: perp_neck; x: 24; y: 24; width: 24; height: 24

        Rectangle {
            anchors.centerIn: parent; width: 18; height: 18; radius: 2; color: col_accent
            Behavior on color { enabled: !dataManager.animDisabled; ColorAnimation { duration: 120 }}
        }

        Behavior on x { enabled: !dataManager.animDisabled; NumberAnimation { duration: moveDuration } }
        Behavior on y { enabled: !dataManager.animDisabled; NumberAnimation { duration: moveDuration } }
    }

    Item {
        id: perp_head; x: 24; y: 24; width: 24; height: 24

        Rectangle {
            anchors.centerIn: parent; width: 20; height: 20; radius: 2; color: col_accent
            Behavior on color { enabled: !dataManager.animDisabled; ColorAnimation { duration: 120 }}
        }

        Behavior on x { enabled: !dataManager.animDisabled; NumberAnimation { duration: moveDuration } }
        Behavior on y { enabled: !dataManager.animDisabled; NumberAnimation { duration: moveDuration } }

        /*Text { anchors.centerIn: parent; text: orientation }*/

        Item {
            width: 14; height: 14
            anchors.centerIn: parent; rotation: {
                switch (orientation) {
                case 0: return 0
                case 1: return 90
                case 2: return 180
                case 3: return 270
                }
            }

            Rectangle { width: 4; height: 4; color: col_bg; anchors.left: parent.left }
            Rectangle { width: 4; height: 4; color: col_bg; anchors.right: parent.right }
        }
    }

    Timer {
        id: crashTimer
        repeat: true; interval: moveDuration
        onTriggered: crashLoop()
    }

    Timer {
        id: crashAnimFinishTimer
        interval: moveDuration
        onTriggered: rootPerp.crashAnimCompleted()
    }


    function drop(x, y, _orientation) {
        if (!grid.population[x][y]) {
            parts.forEach(function(part) {
                rootPerp[part].x = grid.cells[x][y].x
                rootPerp[part].y = grid.cells[x][y].y
            })

            orientation = _orientation
            currentX = x
            currentY = y
            crashed = false
            return true
        }
        else {
            console.log("MoverPerp.qml: Cell at " + x + ", " + y + " occupied")
            return false
        }
    }

    function moveFwd() {
        switch (orientation) {
        case 0: return up(currentX, currentY)
        case 1: return right(currentX, currentY)
        case 2: return down(currentX, currentY)
        case 3: return left(currentX, currentY)
        }
    }

    function moveLeft() {
        switch (orientation) {
        case 0: return left(currentX, currentY)
        case 1: return up(currentX, currentY)
        case 2: return right(currentX, currentY)
        case 3: return down(currentX, currentY)
        }
    }

    function moveRight() {
        switch (orientation) {
        case 0: return right(currentX, currentY)
        case 1: return down(currentX, currentY)
        case 2: return left(currentX, currentY)
        case 3: return up(currentX, currentY)
        }
    }

    function forceFwd() {
        switch (orientation) {
        case 0: up_forced(currentX, currentY); break
        case 1: right_forced(currentX, currentY); break
        case 2: down_forced(currentX, currentY); break
        case 3: left_forced(currentX, currentY); break
        }
    }

    function forceLeft() {
        switch (orientation) {
        case 0: left_forced(currentX, currentY); break
        case 1: up_forced(currentX, currentY); break
        case 2: right_forced(currentX, currentY); break
        case 3: down_forced(currentX, currentY); break
        }
    }

    function forceRight() {
        switch (orientation) {
        case 0: right_forced(currentX, currentY); break
        case 1: down_forced(currentX, currentY); break
        case 2: left_forced(currentX, currentY); break
        case 3: up_forced(currentX, currentY); break
        }
    }

    function boundsCheck() {
        if (currentX === 0 || currentX === grid.rows - 1 ||
                currentY === 0 || currentY === grid.columns - 1) return true
        else return false
    }

    function move(x, y) {
        for (var index = 3; index > 0; index--) {
            rootPerp[parts[index]].x = rootPerp[parts[index - 1]].x
            rootPerp[parts[index]].y = rootPerp[parts[index - 1]].y
        }

        perp_head.x = grid.cells[x][y].x
        perp_head.y = grid.cells[x][y].y
        currentX = x
        currentY = y
    }

    function moveOutOfBounds(dir) {
        for (var index = 3; index > 0; index--) {
            rootPerp[parts[index]].x = rootPerp[parts[index - 1]].x
            rootPerp[parts[index]].y = rootPerp[parts[index - 1]].y
        }

        console.log("MoverPerp.qml: Out of bounds: " + dir)

        switch (dir) {
        case "up":
            perp_head.y = grid.cells[currentX][currentY].y - 24
            currentX -= 1
            break

        case "right":
            perp_head.x = grid.cells[currentX][currentY].x + 24
            currentY += 1
            break

        case "down":
            perp_head.y = grid.cells[currentX][currentY].y + 24
            currentX += 1
            break

        case "left":
            perp_head.x = grid.cells[currentX][currentY].x - 24
            currentY -= 1
            break
        }
    }

    function crash() {
        crashed = true
        crashCount += 1

        crashIndex = 0
        crashTimer.start()
    }

    function up(x, y) {
        if (!grid.check(x - 1, y)) {
            move(x - 1, y)
            orientation = 0
            console.log("MoverPerp.qml: moved up")
            return true
        } else return false
    }

    function right(x, y) {
        if (!grid.check(x, y + 1)) {
            move(x, y + 1)
            orientation = 1
            console.log("MoverPerp.qml: moved right")
            return true
        } else return false
    }

    function down(x, y) {
        if (!grid.check(x + 1, y)) {
            move(x + 1, y)
            orientation = 2
            console.log("MoverPerp.qml: moved down")
            return true
        } else return false
    }

    function left(x, y) {
        if (!grid.check(x, y - 1)) {
            move(x, y - 1)
            orientation = 3
            console.log("MoverPerp.qml: moved left")
            return true
        } else return false
    }

    function up_forced(x, y) {
        if (boundsCheck()) moveOutOfBounds("up")
        else move(x - 1, y)

        orientation = 0
        console.log("MoverPerp.qml: forced moved up")
    }

    function right_forced(x, y) {
        if (boundsCheck()) moveOutOfBounds("right")
        else move(x, y + 1)

        orientation = 1
        console.log("MoverPerp.qml: forced moved right")
    }

    function down_forced(x, y) {
        if (boundsCheck()) moveOutOfBounds("down")
        else move(x + 1, y)

        orientation = 2
        console.log("MoverPerp.qml: forced moved down")
    }

    function left_forced(x, y) {
        if (boundsCheck()) moveOutOfBounds("left")
        else move(x, y - 1)

        orientation = 3
        console.log("MoverPerp.qml: forced moved left")
    }

    function crashLoop() {
        if (crashIndex < 3) {
            for (var index = 3; index > 0; index--) {
                rootPerp[parts[index]].x = rootPerp[parts[index - 1]].x
                rootPerp[parts[index]].y = rootPerp[parts[index - 1]].y
            }

            crashIndex += 1
        } else {
            crashTimer.stop()
            crashAnimFinishTimer.start()
        }
    }

    function crashFinisher() {
        rootPerp.crashAnimCompleted()
        console.log("MoverPerp.qml: Perp crashed")
    }

    function dropRandom() {
        if (!drop(parseInt(Math.random() * grid.rows), parseInt(Math.random() * grid.columns), parseInt(Math.random() * 3))) {
            dropRandom()
        }
    }

    function relocate() {
        /* Only moves if current cell occupied */
        if (grid.check(currentX, currentY)) {
            dropRandom()
        } else drop(currentX, currentY, orientation)
    }

    function reorient() {
        if (orientation < 3) orientation += 1
        else orientation = 0
    }
}
