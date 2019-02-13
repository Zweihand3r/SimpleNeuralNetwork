import QtQuick 2.7

Item {
    id: rootMIn
    width: 48; height: 44

    property bool presented: false

    MouseArea {
        id: tapable
        hoverEnabled: true
        anchors { fill: parent }
        onClicked: menu.presented = !menu.presented
    }

    Item {
        id: content
        width: 44; height: 44; anchors {
            top: parent.top; right: parent.right; bottom: parent.bottom
        }

        Rectangle {
            radius: 4
            anchors { fill: parent; margins: 4 }
            color: tapable.containsMouse ? col_prim : col_bg
            Behavior on color { enabled: !dataManager.animDisabled; ColorAnimation { duration: 120 }}
        }

        Rectangle {
            id: mid
            x: 10; y: 21
            width: 24; height: 2; radius: height / 2
            color: tapable.containsMouse ? col_bg : col_prim
            Behavior on color { enabled: !dataManager.animDisabled; ColorAnimation { duration: 120 }}
        }

        Rectangle {
            id: bottom
            x: 10; y: 29
            width: 24; height: 2; radius: height / 2
            color: tapable.containsMouse ? col_bg : col_prim
            Behavior on color { enabled: !dataManager.animDisabled; ColorAnimation { duration: 120 }}
        }

        Rectangle {
            id: top
            x: 10; y: 13
            width: 24; height: 2; radius: height / 2
            color: tapable.containsMouse ? col_bg : col_prim
            Behavior on color { enabled: !dataManager.animDisabled; ColorAnimation { duration: 120 }}
        }
    }

    states: [
        State {
            name: "presented"
            when: presented

            PropertyChanges { target: top; x: 12 }
            PropertyChanges { target: top; y: 15 }
            PropertyChanges { target: top; height: 3 }
            PropertyChanges { target: top; width: 18 }
            PropertyChanges { target: top; rotation: -45 }

            PropertyChanges { target: bottom; x: 12 }
            PropertyChanges { target: bottom; y: 27 }
            PropertyChanges { target: bottom; height: 3 }
            PropertyChanges { target: bottom; width: 18 }
            PropertyChanges { target: bottom; rotation: 45 }

            PropertyChanges { target: mid; x: 14 }
            PropertyChanges { target: mid; width: 2 }
        }
    ]

    transitions: [
        Transition {
            enabled: !dataManager.animDisabled
            NumberAnimation { properties: "x, y, width, height, rotation"; easing.type: Easing.InCurve; duration: 160 }
        }
    ]
}
