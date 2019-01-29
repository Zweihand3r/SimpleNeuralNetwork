import QtQuick 2.7
import QtQuick.Layouts 1.3

import '../Controls'
import '../Components'

Flickable {
    id: rootSwitchPanel
    contentHeight: setConColumn.height; contentWidth: width
    anchors { left: parent.left; top: parent.top; right: parent.right }

    property int stepCount: parseInt(stepsDropdown.currentItem)

    ColumnLayout {
        id: setConColumn
        width: parent.width

        /* Settings */

        OptionsTitle { text: "Settings"; Layout.alignment: Qt.AlignHCenter }

        Button_Dropdown {
            id: inputDropdown
            text: "Input Count"
            Layout.fillWidth: true
            currentIndex: 1
            dropdownItems: ["Two", "Three", "Four"]
        }

        Button_Dropdown {
            id: outputDropdown
            text: "Output Count"
            Layout.fillWidth: true
            dropdownItems: ["One", "Two", "Three"]
        }

        Button_Dropdown {
            id: outputTypeDropdown
            text: "Output Type"
            Layout.fillWidth: true
            dropdownItems: ["Binary", "Fill", "Decimal"]
            onCurrentIndexChanged: {
                outputType = outputTypeDropdown.currentIndex
            }
        }

        RowLayout {
            Layout.fillWidth: true

            Button_ {
                Layout.preferredHeight: 30; Layout.fillWidth: true
                text: "Revert"; horizontalAlignment: Text.AlignHCenter
                onClicked: {
                    inputDropdown.setCurrentIndex(switchCount - 2)
                    outputDropdown.setCurrentIndex(outputCount - 1)
                }
            }

            Button_ {
                Layout.preferredHeight: 30; Layout.fillWidth: true
                text: "Apply"; horizontalAlignment: Text.AlignHCenter
                onClicked: loadingScreen.present({ "caller": rootSwitchPanel, "complete_action": "applyAction" })
            }
        }

        Item { Layout.preferredHeight: 4 }

        /* Controls */

        OptionsTitle { text: "Controls"; Layout.alignment: Qt.AlignHCenter }

        /*Button_ {
            Layout.fillWidth: true
            fontSize: 17; text: "Test"
        }*/

        Button_Dropdown {
            id: stepsDropdown
            text: "Train Steps"
            Layout.fillWidth: true
            dropdownItems: ["10", "100",  "1000", "100000"]
        }

        Button_ {
            Layout.fillWidth: true
            text: "Train Network"
            onClicked: trainNetwork()
        }

        Button_ {
            Layout.fillWidth: true
            text: "Wipe Network"
            onClicked: clearNetwork()
        }

        Button_ {
            Layout.fillWidth: true
            text: "Compute Network Output"
            onClicked: computeNetworkOutput()
        }

        Item { Layout.preferredHeight: 1 }
    }

    function applyAction() {
        switchCount = inputDropdown.currentIndex + 2
        outputCount = outputDropdown.currentIndex + 1

        createGrid()
        clearNetwork()

        loadingScreen.dismiss()
    }
}
