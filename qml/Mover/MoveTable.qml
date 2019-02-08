import QtQuick 2.7
import QtQuick.Layouts 1.3

GridLayout {
    id: test
    columns: 2; columnSpacing: 8

    property bool empty: false

    readonly property var map: {
        "1 1 1": 0, "0 1 0": 1, "1 0 1": 2, "0 0 1": 3,
        "0 1 1": 4, "1 0 0": 5, "1 1 0": 6, "0 0 0": 7
    }

    Repeater {
        id: movesRepeater

        model: ListModel {
            id: movesModel
            ListElement { _i0: 1; _i1: 1; _i2: 1; _o0: 0; _o1: 0; _o2: 0 }
            ListElement { _i0: 0; _i1: 1; _i2: 0; _o0: 0; _o1: 0; _o2: 0 }
            ListElement { _i0: 1; _i1: 0; _i2: 1; _o0: 0; _o1: 0; _o2: 0 }
            ListElement { _i0: 0; _i1: 0; _i2: 1; _o0: 0; _o1: 0; _o2: 0 }
            ListElement { _i0: 0; _i1: 1; _i2: 1; _o0: 0; _o1: 0; _o2: 0 }
            ListElement { _i0: 1; _i1: 0; _i2: 0; _o0: 0; _o1: 0; _o2: 0 }
            ListElement { _i0: 1; _i1: 1; _i2: 0; _o0: 0; _o1: 0; _o2: 0 }
            ListElement { _i0: 0; _i1: 0; _i2: 0; _o0: 0; _o1: 0; _o2: 0 }
        }

        Item {
            Layout.preferredWidth: 58; Layout.preferredHeight: 39; opacity: 0.32
            Behavior on opacity { OpacityAnimator { duration: 120; easing.type: Easing.OutQuad } }

            Rectangle {
                y: 19; width: 20; height: 20; border { width: 1; color: col_bg } color: _i0 === 1 ? col_prim : col_bg
                /*Rectangle { anchors { fill: parent; margins: 3 } color: "transparent"; border { width: 1; color: col_accent } }*/

                Rectangle {
                    width: parent.width - 8; height: width * _o0; color: col_accent
                    anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 4 }
                }
            }

            Rectangle {
                x: 19; width: 20; height: 20; border { width: 1; color: col_bg } color: _i1 === 1 ? col_prim : col_bg
                /*Rectangle { anchors { fill: parent; margins: 3 } color: "transparent"; border { width: 1; color: col_accent } }*/

                Rectangle {
                    width: parent.width - 8; height: width * _o1; color: col_accent
                    anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 4 }
                }
            }

            Rectangle {
                x: 38; y: 19; width: 20; height: 20; border { width: 1; color: col_bg } color: _i2 === 1 ? col_prim : col_bg
                /*Rectangle { anchors { fill: parent; margins: 3 } color: "transparent"; border { width: 1; color: col_accent } }*/

                Rectangle {
                    width: parent.width - 8; height: width * _o2; color: col_accent
                    anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 4 }
                }
            }
        }
    }

    function setMoves(inputs, out_0, out_1, out_2) {
        var inputKey = inputs[0]
        movesModel.set(map[inputKey], {
                           "_o0": out_0,
                           "_o1": out_1,
                           "_o2": out_2
                       })

        movesRepeater.itemAt(map[inputKey]).opacity = 1
        /*if (empty) empty = false*/
    }

    function wipe() {
        for (var index = 0; index < movesModel.count; index++) {
            movesModel.set(index, { "_o0": 0, "_o1": 0, "_o2": 0 })
            movesRepeater.itemAt(index).opacity = 0.32
        }
    }
}
