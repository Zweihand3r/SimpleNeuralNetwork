import QtQuick 2.7

Rectangle {
    implicitWidth: 16
    implicitHeight: 16
    color: "transparent"
    border { width: 2; color: "black" }

    property bool clickable: true
    property bool checked: false

    Rectangle {
        color: "black"
        visible: checked
        anchors { fill: parent; margins: 4 }
    }

    MouseArea {
        anchors.fill: parent
        enabled: clickable
        onClicked: checked = !checked
    }
}
