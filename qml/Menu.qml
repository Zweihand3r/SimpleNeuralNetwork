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

    onPresentedChanged: delayTimer.start()

    Item {
        id: content
        width: panelWidth; height: parent.height

        Rectangle { anchors.fill: parent; color: col_prim }

        ColumnLayout {
            anchors { fill: parent; leftMargin: 0; topMargin: 12; rightMargin: 0; bottomMargin: 12 }

            Image_ {
                Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                source: 'qrc:/assets/Images/Neural_Brain.png'; fillMode: Image.PreserveAspectFit
                Layout.preferredWidth: 90; Layout.preferredHeight: paintedHeight; tint: col_bg
            }

            Item { Layout.preferredHeight: 2 }

            Repeater {
                model: ["Switches", "Mover"]
                MenuButton {
                    text: modelData
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    selected: currentStackIndex === index
                    onClicked: currentStackIndex = index
                }
            }

            Item { Layout.preferredHeight: 1; Layout.fillHeight: true }

            Button_Dropdown {
                id: themeDropdown; text: "Theme"
                currentIndex: dataManager.themeIndex
                Layout.leftMargin: 12; Layout.rightMargin: 12
                Layout.fillWidth: true; Layout.alignment: Qt.AlignBottom
                dropdownItems: ["Dark", "Light"]; _col_prim: col_bg; _col_bg: col_prim
                onDelayedClick: applyTheme()
            }
        }
    }

    Timer {
        id: delayTimer
        interval: animDuration
        onTriggered: menuIndicator.presented = presented
    }

    Component.onCompleted: applyTheme()

    function applyTheme() {
        theme = themeDropdown.currentItem.toLowerCase()
        dataManager.themeIndex = themeDropdown.currentIndex
    }
}
