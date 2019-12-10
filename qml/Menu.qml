import QtQuick 2.7
import QtQuick.Layouts 1.3

import './Controls'
import './Components'

Item {
    id: rootMenu
    width: windowWidth; height: windowHeight

    property bool presented: false

    property int currentStackIndex: 0

    property int panelWidth: 240
    property int animDuration: 240

    onPresentedChanged: function() {
        if (dataManager.animDisabled) menuIndicator.presented = presented
        else delayTimer.start()
    }

    Item {
        id: content
        width: panelWidth; height: parent.height

        Rectangle {
            anchors.fill: parent; color: col_prim
            Behavior on color { enabled: !dataManager.animDisabled; ColorAnimation { duration: 120 }}
        }

        ColumnLayout {
            spacing: 0; anchors {
                fill: parent; leftMargin: 0; topMargin: 12; rightMargin: 0; bottomMargin: 12
            }

            Image_ {
                Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                source: 'qrc:/assets/Images/Neural_Brain.png'; fillMode: Image.PreserveAspectFit
                Layout.preferredWidth: 90; Layout.preferredHeight: paintedHeight; tint: col_bg
            }

            Item { Layout.preferredHeight: 6 }

            Repeater {
                model: ["Switches", "Mover", "Settings"]
                MenuButton {
                    text: modelData
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    selected: currentStackIndex === index
                    onDelayedClick: function() {
                        currentStackIndex = index
                        presented = false
                    }
                }
            }

            Item { Layout.preferredHeight: 1; Layout.fillHeight: true }
        }
    }

    Timer {
        id: delayTimer
        interval: animDuration
        onTriggered: menuIndicator.presented = presented
    }
}
