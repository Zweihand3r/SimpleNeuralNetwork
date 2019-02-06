import QtQuick 2.7

Item {
    id: rootSwitch
    implicitWidth: 144
    implicitHeight: 36
    clip: true; opacity: enabled ? 1 : 0.5
    Behavior on opacity { OpacityAnimator { duration: 120 }}

    property color _col_prim: col_prim
    property color _col_bg: col_bg

    property color color_off: col_prim_dim

    property string text: "Switch"

    property int fontSize: height / 2
    property int contentMargin: 4

    property bool checked: false

    signal clicked()

    /* Anim */
    property string setterText: "Switch"
    property int animModifier: 1

    function setText(text, animateRight) {
        if (animateRight === undefined) animateRight = true
        animModifier = animateRight ? 1 : -1

        setterText = text
        textChangeAnim.start()
    }

    Text {
        id: switchText
        text: rootSwitch.text; color: _col_prim; font.pixelSize: fontSize; anchors {
            left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: contentMargin
        }
    }

    MouseArea {
        id: switchClicky
        width: 48; hoverEnabled: rootSwitch.enabled; anchors {
            top: parent.top; right: parent.right; bottom: parent.bottom
        }

        onClicked: function() {
            checked = !checked
            rootSwitch.clicked()
        }

        Rectangle {
            width: 30; height: 20; anchors.centerIn: parent
            clip: true; radius: height / 2; border {
                width: 2; color: _col_prim
            } color: switchClicky.containsMouse ? _col_prim : "transparent"
            Behavior on color { ColorAnimation { duration: 120 }}

            Item {
                anchors { fill: parent; margins: 4 }

                Rectangle {
                    x: checked ? parent.width - width : 0
                    color: checked ? (switchClicky.containsMouse ? _col_bg : _col_prim) : color_off
                    width: height; height: parent.height; radius: height / 2

                    Behavior on x { NumberAnimation { duration: 64 }}
                    Behavior on color { ColorAnimation { duration: 120 }}
                }
            }
        }
    }

    SequentialAnimation {
        id: textChangeAnim

        ParallelAnimation {
            OpacityAnimator { target: switchText; from: 1; to: 0; duration: 80 }
            NumberAnimation {
                target: switchText; property: "anchors.leftMargin"
                from: contentMargin; to: contentMargin + 24 * animModifier; duration: 80
            }
        }

        ScriptAction { script: switchText.text = setterText }

        ParallelAnimation {
            OpacityAnimator { target: switchText; from: 0; to: 1; duration: 80 }
            NumberAnimation {
                target: switchText; property: "anchors.leftMargin"
                from: contentMargin - 24 * animModifier; to: contentMargin; duration: 80
            }
        }

        ScriptAction { script: text = setterText }
    }
}
