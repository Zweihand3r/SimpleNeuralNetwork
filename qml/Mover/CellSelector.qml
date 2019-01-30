import QtQuick 2.7
import QtQuick.Layouts 1.3

MouseArea {
    id: rootCS
    hoverEnabled: true
    implicitWidth: 64; implicitHeight: 64

    property bool selected: false

    readonly property int dimension: 6

    Rectangle {
        anchors.fill: parent; radius: 6
        color: selected ? col_bg : "transparent"
        Behavior on color { ColorAnimation { duration: 80 } }
    }

    GridLayout {
        id: layout; anchors.centerIn: parent
        columns: dimension; rows: dimension; columnSpacing: 1; rowSpacing: 1
        scale: containsMouse ? 1.1 : 1
        Behavior on scale { ScaleAnimator { duration: 80 } }

        Repeater {
            model: populationModel

            Rectangle {
                opacity: _alive; color: selected ? col_prim : col_bg
                Layout.preferredWidth: 6; Layout.preferredHeight: 6
                Behavior on opacity { OpacityAnimator { duration: 80 } }
            }
        }
    }

    Rectangle {
        anchors { fill: layout; margins: -2 }
        color: "transparent"; scale: containsMouse ? 1.1 : 1; border {
            color: selected ? col_prim : col_bg; width: 1
        } Behavior on scale { ScaleAnimator { duration: 80 } }
    }

    ListModel {
        id: populationModel

        ListElement { _alive: 1 }
    }

    function initializeModel() {
        populationModel.clear()
        for (var index = 0; index < Math.pow(dimension, 2); index++) {
            populationModel.append({ "_alive": 1 })
        }
    }

    function setModel(model) {
        if (populationModel.count === 1) initializeModel()

        for (var index = 0; index < Math.pow(dimension, 2); index++) {
            populationModel.setProperty(index, "_alive", model[index])
        }
    }
}
