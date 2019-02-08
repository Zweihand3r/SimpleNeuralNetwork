import QtQuick 2.7

MouseArea {
    id: rootSlider
    implicitWidth: 200
    implicitHeight: 20
    hoverEnabled: true

    property real value: 1

    property bool highlightSlider: containsMouse || drag.active

    drag {
        target: handle
        axis: Drag.XAxis
        minimumX: 4
        maximumX: width - handle.width - 4
    }

    property color _col_prim: col_prim
    property color _col_bg: col_bg

    Rectangle {
        anchors { fill: parent }
        color: highlightSlider ? _col_prim : _col_bg
        radius: height / 2; border { width: 2; color: _col_prim }
        Behavior on color { ColorAnimation { duration: 120 } }
    }

    Rectangle {
        id: fill
        color: highlightSlider ? _col_bg : _col_prim
        width: handle.x + handle.width - x
        x: 4; height: 12; radius: height / 2
        anchors.verticalCenter: parent.verticalCenter
        Behavior on color { ColorAnimation { duration: 120 } }
    }

    Item {
        id: handle
        x: 4; width: 12; height: 12
        anchors.verticalCenter: parent.verticalCenter
        onXChanged: computeValue(x)

        Behavior on x {
            enabled: !drag.active
            NumberAnimation { duration: 80; easing.type: Easing.OutQuad }
        }

        Rectangle {
            anchors { fill: parent; margins: 2 }
            color: highlightSlider ? _col_prim : _col_bg; radius: width / 2
            Behavior on color { ColorAnimation { duration: 120 } }
        }
    }

    onPressedChanged: function() {
        if (!pressed && !drag.active) {
            handle.x = mouseX - handle.width / 2
        }
    }

    function computeValue(x) {
        value = (x - drag.minimumX) / (drag.maximumX - drag.minimumX)
    }

    function setValue(value) {
        handle.x = value * (drag.maximumX - drag.minimumX) + drag.minimumX
    }
}
