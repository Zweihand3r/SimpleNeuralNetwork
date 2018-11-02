import QtQuick 2.7
import QtQuick.Layouts 1.3

MouseArea {
    id: button_dd
    implicitWidth: 144
    implicitHeight: buttonHeight + (expanded ? dropdownLt.height : 0)
    hoverEnabled: true; clip: true

    property var dropdownItems: ["First", "Second", "Third"]

    property color accentColor: "#FFFFFF"
    property color backgroundColor: "#000000"

    property string text: "Button"

    property int currentIndex: 0
    property int buttonHeight: 36
    property int cellHeight: 24
    property int borderWidth: 2
    property int contentMargin: 4
    property int fontSize: buttonHeight / 2
    property int radius: 4

    property bool expanded: containsMouse

    property int nextIndex: 0
    property int paintedWidth: { return buttonText.paintedWidth }

    signal delayedClick()

    function setCurrentIndex(index) {
        nextIndex = index
        textChangeAnim.start()
    }

    Behavior on implicitHeight { NumberAnimation { duration: 120; easing.type: Easing.InCubic } }

    Rectangle {
        border { color: accentColor; width: borderWidth }
        anchors.fill: parent; radius: parent.radius; color: "#00000000"
    }

    RowLayout {
        id: contentLt
        width: parent.width; height: buttonHeight

        Text {
            id: buttonText; text: button_dd.text ; font.pixelSize: fontSize
            color: accentColor; wrapMode: Text.WordWrap; horizontalAlignment: Text.AlignLeft
            Layout.alignment: Qt.AlignVCenter; Layout.fillWidth: true; leftPadding: 12
        }

        Text {
            id: selectedText; text: dropdownItems[currentIndex]
            color: accentColor; horizontalAlignment: Text.AlignRight; font.pixelSize: fontSize
            Layout.alignment: Qt.AlignVCenter; Layout.fillWidth: true; rightPadding: 12
        }
    }

    ColumnLayout {
        id: dropdownLt
        width: parent.width
        anchors { top: contentLt.bottom }

        Repeater {
            model: dropdownItems

            MouseArea {
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: cellHeight
                propagateComposedEvents: true
                hoverEnabled: true

                Rectangle {
                    anchors { fill: parent; leftMargin: 4; rightMargin: 4 }
                    radius: 2; color: accentColor; opacity: parent.containsMouse ? 1 : 0
                    Behavior on opacity { OpacityAnimator { duration: 120 } }
                }

                Text {
                    anchors { fill: parent; rightMargin: 12 }
                    text: modelData ; font.pixelSize: fontSize
                    color: parent.containsMouse ? backgroundColor : accentColor
                    horizontalAlignment: Text.AlignRight; verticalAlignment: Text.AlignVCenter
                    Behavior on color { ColorAnimation { duration: 120 }}
                }

                onClicked: setCurrentIndex(index)
            }
        }

        Item { Layout.preferredHeight: 1 }
    }

    SequentialAnimation {
        id: textChangeAnim

        OpacityAnimator { target: selectedText; from: 1; to: 0; duration: 60 }
        ScriptAction { script: currentIndex = nextIndex }
        OpacityAnimator { target: selectedText; from: 0; to: 1; duration: 60 }
        ScriptAction { script: button_dd.delayedClick() }
    }
}
