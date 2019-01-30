import QtQuick 2.7
import QtQuick.Layouts 1.3

import '../Controls'

ColumnLayout {
    id: rootSwitchPanel; anchors { centerIn: parent }
    /* width: 48 */

    property bool gridHovered: hoverIndex === 0 && input.withinBounds

    /* In order of appearance */
    property int hoverIndex: 0

    property int selectorIndex: 0

    property real randomDensity: 0.5

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

        Rectangle { anchors.fill: parent; opacity: 0.5; color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1) }

        MouseArea {
            anchors.fill: parent; hoverEnabled: true
            onEntered: function() {
                hoverIndex = 1
            }
        }
    }

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
                selectorIndex = index
            }
            else _selector.selected = false
        })
    }

    function getRandomised() {
        var random = []
        for (var index = 0; index < Math.pow(randomSelector.dimension, 2); index++) {
            random.push(Math.random() > 0.5 ? 1 : 0)
        }
        return random
    }

    function generateAction() {
        switch (selectorIndex) {
        case 0: grid.populateTrack(); break
        case 1: grid.populateRandom(randomDensity); break
        }

        perp.relocate()
    }
}
