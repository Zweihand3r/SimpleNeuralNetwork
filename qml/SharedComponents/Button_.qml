import QtQuick 2.7

MouseArea {
    id: button_
    implicitWidth: 144
    implicitHeight: 36
    hoverEnabled: true; clip: true
    onClicked: clickHandler(mouseX, mouseY)

    property color accentColor: "#FFFFFF"
    property color backgroundColor: "#000000"

    property string text: "Button"

    property int borderWidth: 2
    property int contentMargin: 4
    property int fontSize: height / 2
    property int radius: 8
    property int innerRadius: 4

    property int paintedWidth: { return buttonText.paintedWidth }

    signal delayedClick()

    Rectangle {
        anchors { fill: parent; margins: contentMargin } radius: innerRadius
        color: accentColor; opacity: parent.containsMouse ? 1 : 0
        Behavior on opacity { OpacityAnimator { duration: 120 } }
    }
    Rectangle { id: clickIndicator; visible: false; color: backgroundColor; radius: width / 2 ; anchors.centerIn: parent }
    Rectangle { anchors.fill: parent; radius: parent.radius; color: "#00000000"; border { color: accentColor; width: borderWidth } }

    Text {
        id: buttonText; anchors.fill: parent; text: button_.text ; font.pixelSize: fontSize
        color: parent.containsMouse ? backgroundColor : accentColor; wrapMode: Text.WordWrap
        verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter
        Behavior on color { ColorAnimation { duration: 120 }}
    }

    ParallelAnimation {
        id: clickAnim
        onStopped: { clickIndicator.visible = false; button_.delayedClick() }
        NumberAnimation { target: clickIndicator; property: "width"; from: 0; to: width * 1.2; duration: 360 }
        NumberAnimation { target: clickIndicator; property: "height"; from: 0; to: width * 1.2; duration: 360 }
        OpacityAnimator { target: clickIndicator; from: 1; to: 0; duration: 360; easing.type: Easing.InQuart }
    }

    function clickHandler(mouseX, mouseY) {
        clickIndicator.anchors.horizontalCenterOffset = mouseX - (width / 2)
        clickIndicator.anchors.verticalCenterOffset = mouseY - (height / 2)
        clickIndicator.visible = true
        clickAnim.start()
    }
}
