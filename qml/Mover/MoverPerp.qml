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

    property int currentX: 0
    property int currentY: 0

    property int crashIndex: 0

    property Item head: perp_head
    property Item neck: perp_neck
    property Item body: perp_body
    property Item feet: perp_feet

    readonly property var parts: ["head", "neck", "body", "feet"]
    readonly property int moveDuration: 120

    Item {
        id: perp_feet; width: 24; height: 24
        Rectangle { anchors.centerIn: parent; width: 14; height: 14; radius: 2; color: col_accent }

        Behavior on x { NumberAnimation { duration: moveDuration } }
        Behavior on y { NumberAnimation { duration: moveDuration } }
    }

    Item {
        id: perp_body; width: 24; height: 24
        Rectangle { anchors.centerIn: parent; width: 16; height: 16; radius: 2; color: col_accent }

        Behavior on x { NumberAnimation { duration: moveDuration } }
        Behavior on y { NumberAnimation { duration: moveDuration } }
    }

    Item {
        id: perp_neck; width: 24; height: 24
        Rectangle { anchors.centerIn: parent; width: 18; height: 18; radius: 2; color: col_accent }

        Behavior on x { NumberAnimation { duration: moveDuration } }
        Behavior on y { NumberAnimation { duration: moveDuration } }
    }

    Item {
        id: perp_head; width: 24; height: 24
        Rectangle { anchors.centerIn: parent; width: 20; height: 20; radius: 2; color: col_accent }

        Behavior on x { NumberAnimation { duration: moveDuration } }
        Behavior on y { NumberAnimation { duration: moveDuration } }

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


    function drop(x, y, _orientation) {
        if (!grid.population[x][y]) {
            parts.forEach(function(part) {
                rootPerp[part].x = grid.cells[x][y].x
                rootPerp[part].y = grid.cells[x][y].y
            })

            orientation = _orientation
            currentX = x
            currentY = y
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

    function crash() {
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
        move(x - 1, y)
        orientation = 0
        console.log("MoverPerp.qml: forced moved up")
    }

    function right_forced() {
        move(x, y + 1)
        orientation = 1
        console.log("MoverPerp.qml: forced moved right")
    }

    function down_forced() {
        move(x + 1, y)
        orientation = 2
        console.log("MoverPerp.qml: forced moved down")
    }

    function left_forced() {
        move(x + 1, y)
        orientation = 2
        console.log("MoverPerp.qml: forced moved down")
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
            console.log("MoverPerp.qml: Perp crashed")
        }
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
        }
    }
}
