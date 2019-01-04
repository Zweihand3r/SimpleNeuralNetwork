import QtQuick 2.7
import QtGraphicalEffects 1.0

Item {
    id: rootImage
    implicitWidth: image.implicitWidth
    implicitHeight: image.implicitHeight

    property url source: ''
    property color tint: "#FFFFFF"

    property int fillMode: Image.Pad

    property int paintedWidth: image.paintedWidth
    property int paintedHeight: image.paintedHeight

    Image {
        id: image
        visible: false
        source: rootImage.source
        fillMode: rootImage.fillMode
        anchors.fill: parent
    }

    ColorOverlay {
        anchors.fill: parent
        source: image
        color: tint
    }
}
