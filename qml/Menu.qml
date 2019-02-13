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
                    onDelayedClick: function() {
                        currentStackIndex = index
                        presented = false
                    }
                }
            }

            Item { Layout.preferredHeight: 1; Layout.fillHeight: true }

            OptionsTitle {
                Layout.alignment: Qt.AlignHCenter
                text: "Settings"; color: col_bg; lineWidth: 40
            }

            Repeater {
                model: ["Dark Theme", "Disable Animations"]

                Switch_ {
                    text: modelData
                    _col_prim: col_bg; _col_bg: col_prim
                    Layout.leftMargin: 12; Layout.rightMargin: 12
                    Layout.fillWidth: true; Layout.alignment: Qt.AlignBottom

                    checked: {
                        switch (modelData) {
                        case "Dark Theme": return dataManager.darkTheme
                        case "Disable Animations": return dataManager.animDisabled
                        }
                    }

                    onClicked: function() {
                        switch (modelData) {
                        case "Dark Theme": applyTheme(checked); break
                        case "Disable Animations": dataManager.animDisabled = checked; break
                        }
                    }
                }
            }

            /*Button_Dropdown {
                id: themeDropdown; text: "Theme"
                currentIndex: dataManager.themeIndex
                Layout.leftMargin: 12; Layout.rightMargin: 12
                Layout.fillWidth: true; Layout.alignment: Qt.AlignBottom
                dropdownItems: ["Dark", "Light"]; _col_prim: col_bg; _col_bg: col_prim
                onDelayedClick: applyTheme()
            }*/
        }
    }

    Timer {
        id: delayTimer
        interval: animDuration
        onTriggered: menuIndicator.presented = presented
    }

    Component.onCompleted: function() {
        applyTheme(dataManager.darkTheme)
    }

    function applyTheme(dark) {
        theme = dark ? "dark" : "light"
        if (dataManager.darkTheme !== dark)
            dataManager.darkTheme = dark

        /*theme = themeDropdown.currentItem.toLowerCase()
        dataManager.themeIndex = themeDropdown.currentIndex*/
    }
}
