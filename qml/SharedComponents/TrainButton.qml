import QtQuick 2.7

Item {
    id: rootTB
    implicitWidth: 180
    implicitHeight: 32

    Rectangle {
        width: 120; height: 32
        color: "#000000"; border {
            color: "#FFFFFF"; width: 2
        } radius: 6

        Text {
            anchors.centerIn: parent
            font.pixelSize: 19; text: "Train"; color: "#FFFFFF"
        }
    }
}
