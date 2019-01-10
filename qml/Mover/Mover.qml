import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

Item {
    id: rootMover
    width: parent.width
    height: parent.height

    property int rows: 16
    property int columns: 24

    property var cells: []
    property var population: []

    /*
     *   0
     * 3 * 1
     *   2
     */
    property int orientation: 2
    property point currentLocation: Qt.point(0, 0)

    readonly property var parts: ["head", "neck", "body", "feet"]

    Item {
        id: gridContainer
        width: columns * 24; height: rows * 24
        anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: 26 }
    }

    Item {
        id: moverContainer
        anchors { fill: gridContainer }

        property Rectangle perp_head: perp_head
        property Rectangle perp_neck: perp_neck
        property Rectangle perp_body: perp_body
        property Rectangle perp_feet: perp_feet

        Rectangle {
            id: perp_feet
            x: 8; y: 8; width: 8; height: 8
            color: col_accent; radius: 2
            Behavior on x { NumberAnimation { duration: 120 } }
            Behavior on y { NumberAnimation { duration: 120 } }
        }

        Rectangle {
            id: perp_body
            x: 6; y: 6; width: 12; height: 12
            color: col_accent; radius: 2
            Behavior on x { NumberAnimation { duration: 120 } }
            Behavior on y { NumberAnimation { duration: 120 } }
        }

        Rectangle {
            id: perp_neck
            x: 4; y: 4; width: 16; height: 16
            color: col_accent; radius: 2
            Behavior on x { NumberAnimation { duration: 120 } }
            Behavior on y { NumberAnimation { duration: 120 } }
        }

        Rectangle {
            id: perp_head
            x: 2; y: 2; width: 20; height: 20
            color: col_accent; radius: 2
            Behavior on x { NumberAnimation { duration: 120 } }
            Behavior on y { NumberAnimation { duration: 120 } }

            Text { anchors.centerIn: parent; text: orientation }
        }
    }

    TextField {
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
        }
    }

    Timer {
        id: bakedTimer
        interval: 120; repeat: true
        onTriggered: bakedLoop()
    }

    Component.onCompleted: createGrid()

    /* Commands */
    function drop(x, y, orientation) {
        return dropPerp(parseInt(x), parseInt(y), parseInt(orientation))
    }

    /* --------------- Baked ---------------- */

    function startBaked() { bakedTimer.start() }
    function stopBaked() { bakedTimer.stop() }

    function bakedLoop() {
        var fwd = !checkFwd()
        var left = !checkLeft()
        var right = !checkRight()

        if (fwd) {
            if (left) {
                if (Math.random() > 0.75) { moveLeft(); return }
            } else if (right) {
                if (Math.random() > 0.75) { moveRight(); return }
            } moveFwd()
        } else {
            if (left && right) {
                if (Math.random() > 0.5) { moveLeft(); return }
                moveRight()
            } else if (left) moveLeft()
            else moveRight()
        }
    }


    /* -------------- Movement -------------- */

    function dropPerp(x, y, _orientation) {
        if (!population[x][y]) {
            parts.forEach(function(part) {
                moverContainer["perp_" + part].x = cells[x][y].perpX[part]
                moverContainer["perp_" + part].y = cells[x][y].perpY[part]
            })

            orientation = _orientation
            currentLocation = Qt.point(x, y)
            return true
        }
        else {
            console.log("Mover.qml: Cell at " + x + ", " + y + " occupied")
            return false
        }
    }

    function moveFwd() {
        switch (orientation) {
        case 0: return up(currentLocation.x, currentLocation.y)
        case 1: return right(currentLocation.x, currentLocation.y)
        case 2: return down(currentLocation.x, currentLocation.y)
        case 3: return left(currentLocation.x, currentLocation.y)
        }
    }

    function moveLeft() {
        switch (orientation) {
        case 0: return left(currentLocation.x, currentLocation.y)
        case 1: return up(currentLocation.x, currentLocation.y)
        case 2: return right(currentLocation.x, currentLocation.y)
        case 3: return down(currentLocation.x, currentLocation.y)
        }
    }

    function moveRight() {
        switch (orientation) {
        case 0: return right(currentLocation.x, currentLocation.y)
        case 1: return down(currentLocation.x, currentLocation.y)
        case 2: return left(currentLocation.x, currentLocation.y)
        case 3: return up(currentLocation.x, currentLocation.y)
        }
    }

    function checkFwd() {
        switch (orientation) {
        case 0: return check(x - 1, y)
        case 1: return check(x, y + 1)
        case 2: return check(x + 1, y)
        case 3: return check(x, y - 1)
        }
    }

    function checkLeft() {
        switch (orientation) {
        case 0: return check(x, y - 1)
        case 1: return check(x - 1, y)
        case 2: return check(x, y + 1)
        case 3: return check(x + 1, y)
        }
    }

    function checkRight() {
        switch (orientation) {
        case 0: return check(x, y + 1)
        case 1: return check(x + 1, y)
        case 2: return check(x, y - 1)
        case 3: return check(x - 1, y)
        }
    }

    function move(x, y) {
        for (var index = 3; index > 0; index--) {
            moverContainer["perp_" + parts[index]].x = moverContainer["perp_" + parts[index - 1]].x + 2
            moverContainer["perp_" + parts[index]].y = moverContainer["perp_" + parts[index - 1]].y + 2
        }

        perp_head.x = cells[x][y].perpX.head
        perp_head.y = cells[x][y].perpY.head
        currentLocation = Qt.point(x, y)
    }

    function check(x, y) {
        if (x < 0 || x > rows - 1) return true
        if (y < 0 || y > columns - 1) return true

        /*console.log("Mover.qml: checking " + cells[x][y] + ": " + population[x][y])*/

        return population[x][y]
    }

    function up(x, y) {
        if (!check(x - 1, y)) {
            move(x - 1, y)
            orientation = 0
            console.log("Mover.qml: moved up")
            return true
        } else return false
    }

    function right(x, y) {
        if (!check(x, y + 1)) {
            move(x, y + 1)
            orientation = 1
            console.log("Mover.qml: moved right")
            return true
        } else return false
    }

    function down(x, y) {
        if (!check(x + 1, y)) {
            move(x + 1, y)
            orientation = 2
            console.log("Mover.qml: moved down")
            return true
        } else return false
    }

    function left(x, y) {
        if (!check(x, y - 1)) {
            move(x, y - 1)
            orientation = 3
            console.log("Mover.qml: moved left")
            return true
        } else return false
    }


    /* ------------- Grid -------------- */

    function createGrid() {
        for (var i = 0; i < rows; i++) {
            var row = []
            var pop_row = []

            for (var j = 0; j < columns; j++) {
                var component = Qt.createComponent("Cell.qml")
                var fill = Math.random() > 0.75
                var cell = component.createObject(gridContainer, {
                                                      "x": j * 24,
                                                      "y": i * 24,
                                                      "rowIndex": i,
                                                      "colIndex": j,
                                                      "fill": fill
                                                  })

                row.push(cell)
                pop_row.push(fill)
            }

            cells.push(row)
            population.push(pop_row)
        }
    }
}
