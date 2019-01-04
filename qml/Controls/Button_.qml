import QtQuick 2.7

MouseArea {
    id: button_
    implicitWidth: 144
    implicitHeight: 36
    hoverEnabled: true; clip: true
    onClicked: clickHandler(mouseX, mouseY)

    property color col_accent: "#FFFFFF"
    property color col_bg: "#000000"

    property string text: "Button"

    property int borderWidth: 2
    property int contentMargin: 4
    property int fontSize: height / 2
    property int radius: 4
    property int innerRadius: 2

    property int horizontalAlignment: Text.AlignLeft

    property int paintedWidth: { return buttonText.paintedWidth }

    signal delayedClick()

    Rectangle {
        anchors { fill: parent; margins: contentMargin } radius: innerRadius
        color: col_accent; opacity: parent.containsMouse ? 1 : 0
        Behavior on opacity { OpacityAnimator { duration: 120 } }
    }
    Rectangle { id: clickIndicator; visible: false; color: col_bg; radius: width / 2 ; anchors.centerIn: parent }
    Rectangle { anchors.fill: parent; radius: parent.radius; color: "#00000000"; border { color: col_accent; width: borderWidth } }

    Text {
        id: buttonText; anchors.fill: parent; text: button_.text ; font.pixelSize: fontSize
        color: parent.containsMouse ? col_bg : col_accent; wrapMode: Text.WordWrap
        verticalAlignment: Text.AlignVCenter; horizontalAlignment: button_.horizontalAlignment
        leftPadding: 12; rightPadding: 12
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
