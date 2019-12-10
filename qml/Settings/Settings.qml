import QtQuick 2.7
import QtQuick.Layouts 1.3

import '../Controls'
import '../Components'

Item {
    id: rootSettings
    width: parent.width
    height: parent.height

    ColumnLayout {
        width: 240; anchors {
            top: parent.top; topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }

        OptionsTitle {
            Layout.alignment: Qt.AlignHCenter
            text: "Look & Feel"; color: col_prim; lineWidth: 40
        }

        Item { Layout.preferredHeight: 1 }

        Repeater {
            model: ["Dark Theme", "Disable Animations"]

            Switch_ {
                text: modelData
                Layout.fillWidth: true
                Layout.leftMargin: 12; Layout.rightMargin: 12

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

        Item { Layout.preferredHeight: 8 }

        OptionsTitle {
            Layout.alignment: Qt.AlignHCenter
            text: "Tests"; color: col_prim; lineWidth: 40
        }

        Item { Layout.preferredHeight: 1 }

        Text {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            text: "Used for development"; color: col_prim
        }

        Button_ {
            Layout.fillWidth: true
            text: "Switch to Tests"
            onClicked: switchToTests()
        }
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

    function switchToTests() {
        rootContent.visible = false
        tests.visible = true
    }
}
