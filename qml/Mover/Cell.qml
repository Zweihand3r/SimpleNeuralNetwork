import QtQuick 2.7

Item {
    id: rootCell
    implicitWidth: 24
    implicitHeight: 24
    objectName: "Cell " + rowIndex + " | " + colIndex

    property bool fill: true

    property int rowIndex: 0
    property int colIndex: 0

    Item {
        anchors { fill: parent; margins: -1 }

        Rectangle {
            width: parent.width; height: parent.height
            scale: fill ? 1 : 0; color: col_prim; radius: 2
            Behavior on scale { ScaleAnimator { duration: 80 } }
        }

        /*Text {
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter; font.pixelSize: 9
            text: rowIndex + " " + colIndex; color: fill ? col_bg : col_prim
        }*/
    }
}
