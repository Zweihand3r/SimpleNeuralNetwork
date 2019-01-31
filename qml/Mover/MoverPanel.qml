import QtQuick 2.7
import QtQuick.Layouts 1.3

import '../Controls'

ColumnLayout {
    id: rootSwitchPanel; anchors { centerIn: parent }
    /* width: 48 */

    property bool gridHovered: hoverIndex === 0 && input.withinBounds

    /* In order of appearance */
    property int hoverIndex: 0

    property int popSelectorIndex: 0
    property real randomDensity: 0.2

    property bool playActive: false

    readonly property var selectors: [trackSelector, randomSelector]

    Item {
        id: gridButton
        Layout.preferredWidth: 48; Layout.preferredHeight: 48
        Rectangle { anchors { fill: gridContainer; margins: -4 } radius: 10; color: col_bg }

        Item {
            id: bounds
            height: gridContent.height; width: parent.width + gridContent.width
            anchors { right: parent.right; verticalCenter: parent.verticalCenter }
        }

        Item {
            id: gridContainer; clip: true
            height: gridContent.height; width: (gridHovered ? parent.width + gridContent.width : 0 )
            anchors { right: parent.right; verticalCenter: parent.verticalCenter }
            Behavior on width { NumberAnimation { duration: 120; easing.type: Easing.OutQuad }}

            Rectangle { /* Icon bg */
                anchors { right: parent.right; verticalCenter: parent.verticalCenter }
                color: col_prim; width: parent.width + 6; height: gridButton.height; radius: 6
            }

            Rectangle { /* Content bg */
                width: gridContent.width; height: gridContent.height; radius: 6
                anchors { right: parent.right; rightMargin: 48 } color: col_prim
            }

            ColumnLayout {
                id: gridContent
                opacity: gridHovered ? 1 : 0
                anchors { right: parent.right; rightMargin: 48 }
                Behavior on opacity { OpacityAnimator { duration: 120; easing.type: Easing.OutQuad } }

                GridLayout {
                    columns: 2; columnSpacing: 8
                    Layout.leftMargin: 8; Layout.topMargin: 8; Layout.rightMargin: 8

                    CellSelector {
                        id: trackSelector
                        selected: true
                        onClicked: cellSelectionHandler(this)
                    }

                    CellSelector {
                        id: randomSelector
                        onClicked: function() {
                            if (selected) {
                                if (randomDensity > 0.4) randomDensity = 0.1
                                else randomDensity += 0.1

                                var model = []
                                for (var index = 0; index < Math.pow(dimension, 2); index++) {
                                    model.push(Math.random() > randomDensity ? 0 : 1)
                                }
                                setModel(model)
                            }
                            else cellSelectionHandler(this)
                        }
                    }
                }

                Item { Layout.preferredHeight: 1 }

                Button_ {
                    id: generateButton
                    Layout.preferredWidth: 64; Layout.fillWidth: true
                    Layout.leftMargin: 8; Layout.rightMargin: 8; Layout.bottomMargin: 8
                    text: "Generate"; horizontalAlignment: Text.AlignHCenter; _col_prim: col_bg; _col_bg: col_prim
                    onClicked: generateAction()
                }
            }
        }

        Image_ {
            tint: gridHovered ? col_bg : col_prim
            source: 'qrc:/assets/Images/Icon_Grid.png'
            anchors { fill: parent; margins: 12 } fillMode: Image.Stretch
        }

        MouseArea {
            id: gridHovery; anchors.fill: parent; hoverEnabled: true
            onEntered: function() {
                var globalOrigin = bounds.mapToItem(rootContent, bounds.x, bounds.y)

                hoverIndex = 0
                input.checkBounds = true
                input.setBounds(Qt.rect(globalOrigin.x - bounds.x, globalOrigin.y - bounds.y, bounds.width, bounds.height))
            }
        }
    }

    Item {
        id: playButton
        Layout.preferredWidth: 48; Layout.preferredHeight: 48

        Rectangle {
            anchors { right: parent.right; top: parent.top; bottom: parent.bottom }
            color: col_prim; width: playHovery.containsMouse ? parent.width : 0; radius: 6
            Behavior on width { NumberAnimation { duration: 40 } }
        }

        Item {
            id: playContent; width: 32; height: 32; scale: 0.88
            anchors { centerIn: parent; horizontalCenterOffset: 2 }

            Rectangle { id: line1; x: -1; y: 7; width: 32; height: 4; radius: 2; rotation: 30; color: playHovery.containsMouse ? col_bg : col_prim }
            Rectangle { id: line2; x: -14; y: 14; width: 32; height: 4; radius: 2; rotation: 90; color: playHovery.containsMouse ? col_bg : col_prim }
            Rectangle { id: line3; x: -1; y: 21; width: 32; height: 4; radius: 2; rotation: -30; color: playHovery.containsMouse ? col_bg : col_prim }
            Rectangle { id: line4; x: 28; y: 14; width: 4; height: 0; radius: 4; anchors.verticalCenter: parent.verticalCenter; color: playHovery.containsMouse ? col_bg : col_prim }
        }

        MouseArea {
            id: playHovery
            anchors.fill: parent; hoverEnabled: true
            onEntered: hoverIndex = 1; onClicked: playAction()
        }

        states: [
            State {
                name: "stop"; when: playActive

                PropertyChanges { target: playContent; anchors.horizontalCenterOffset: 0 }
                PropertyChanges { target: line1; x: 0; y: 0; rotation: 0 }
                PropertyChanges { target: line3; x: 0; y: 28; rotation: 0 }
                PropertyChanges { target: line4; height: 32 }
            }
        ]

        transitions: [
            Transition {
                from: ""; to: "stop"; reversible: true
                NumberAnimation {
                    duration: 80; easing.type: Easing.OutQuad
                    properties: "x, y, height, width, rotation, anchors.horizontalCenterOffset"
                }
            }
        ]
    }

    /*Item {
        id: networkButton
        Layout.preferredWidth: 48; Layout.preferredHeight: 48

        Image {
            anchors { fill: parent; margins: 8 }
            source: 'qrc:/assets/Images/Neural_Brain.png'
        }
    }*/

    Component.onCompleted: function() {
        trackSelector.setModel([
                                   1, 1, 1, 1, 1, 1,
                                   1, 0, 0, 0, 0, 1,
                                   1, 0, 1, 1, 0, 1,
                                   1, 0, 1, 1, 0, 1,
                                   1, 0, 0, 0, 0, 1,
                                   1, 1, 1, 1, 1, 1
                               ])

        randomSelector.setModel(getRandomised())
    }

    function cellSelectionHandler(selector) {
        selectors.forEach(function(_selector, index) {
            if (selector === _selector) {
                _selector.selected = true
                popSelectorIndex = index
            }
            else _selector.selected = false
        })
    }

    function getRandomised() {
        var random = []
        for (var index = 0; index < Math.pow(randomSelector.dimension, 2); index++) {
            random.push(Math.random() > randomDensity ? 0 : 1)
        }
        return random
    }

    function generateAction() {
        switch (popSelectorIndex) {
        case 0: grid.populateTrack(); break
        case 1: grid.populateRandom(randomDensity); break
        }

        perp.relocate()
    }

    function playAction() {
        if (!playActive) {
            if (perp.crashed) perp.dropRandom()
            startBaked()
            playActive = true
        }
        else {
            stopBaked()
            playActive = false
        }
    }
}
