import QtQuick 2.7

Item {
    id: rootGrid
    width: columns * 24
    height: rows * 24

    /* Debug */
    property bool enableCheckLogs: false

    property int rows: 17
    property int columns: 21

    property var cells: []
    property var population: []

    property bool boundsVisible: perp.boundsCheck()

    Item { id: gridContainer; anchors { fill: parent } }

    Rectangle {
        anchors { fill: parent; margins: -2 } opacity: boundsVisible ? 1 : 0
        color: "#00000000"; radius: 2; border { width: 2; color: col_prim }
        Behavior on opacity { OpacityAnimator { duration: 120 } }
    }


    function checkFwd() {
        switch (perp.orientation) {
        case 0: return check(perp.currentX - 1, perp.currentY)
        case 1: return check(perp.currentX, perp.currentY + 1)
        case 2: return check(perp.currentX + 1, perp.currentY)
        case 3: return check(perp.currentX, perp.currentY - 1)
        }
    }

    function checkLeft() {
        switch (perp.orientation) {
        case 0: return check(perp.currentX, perp.currentY - 1)
        case 1: return check(perp.currentX - 1, perp.currentY)
        case 2: return check(perp.currentX, perp.currentY + 1)
        case 3: return check(perp.currentX + 1, perp.currentY)
        }
    }

    function checkRight() {
        switch (perp.orientation) {
        case 0: return check(perp.currentX, perp.currentY + 1)
        case 1: return check(perp.currentX + 1, perp.currentY)
        case 2: return check(perp.currentX, perp.currentY - 1)
        case 3: return check(perp.currentX - 1, perp.currentY)
        }
    }

    function check(x, y) {
        if (x < 0 || x > rows - 1) return true
        if (y < 0 || y > columns - 1) return true

        if (enableCheckLogs)
            console.log("MoverGrid.qml: checking " + cells[x][y] + ": " + population[x][y])

        return population[x][y]
    }


    /* ------------- Grid -------------- */

    function create() {
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
