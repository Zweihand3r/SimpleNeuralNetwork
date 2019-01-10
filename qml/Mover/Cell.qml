import QtQuick 2.7

Item {
    id: rootCell
    implicitWidth: 24
    implicitHeight: 24
    objectName: "Cell " + rowIndex + " | " + colIndex

    property bool fill: true

    property int rowIndex: 0
    property int colIndex: 0

    property var perpX: {
        "head": x + 2,
        "neck": x + 4,
        "body": x + 6,
        "feet": x + 8
    }

    property var perpY: {
        "head": y + 2,
        "neck": y + 4,
        "body": y + 6,
        "feet": y + 8
    }

    Item {
        anchors { fill: parent; margins: -1 }

        Rectangle {
            width: parent.width; height: parent.height
            scale: fill ? 1 : 0; color: col_prim; radius: 2
            Behavior on scale { ScaleAnimator { duration: 80 } }
        }

        Text {
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter; font.pixelSize: 9
            text: rowIndex + " " + colIndex; color: fill ? col_bg : col_prim
        }
    }

    onXChanged: function() {
        perpX = {
            "head": x + 2,
            "neck": x + 4,
            "body": x + 6,
            "feet": x + 8
        }
    }

    onYChanged: function() {
        perpY = {
            "head": y + 2,
            "neck": y + 4,
            "body": y + 6,
            "feet": y + 8
        }
    }
}
