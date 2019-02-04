import QtQuick 2.7
import QtQuick.Layouts 1.3

import '../Controls'

ColumnLayout {
    id: rootSwitchPanel; anchors { centerIn: parent }
    /* width: 48 */

    property bool gridHovered: hoverIndex === 0 && input.withinBounds
    property bool networkHovered: hoverIndex === 2 && input.withinBounds

    /* In order of appearance */
    property int hoverIndex: 0

    property int popSelectorIndex: 0

    property int trackIndex: 0
    property real randomDensity: 0.2

    property bool playActive: false

    property bool bakedMover: false

    property bool trainOnCrash: false
    property bool trainFromBaked: false

    readonly property var selectors: [trackSelector, randomSelector]

    Item {
        id: gridButton
        Layout.preferredWidth: 48; Layout.preferredHeight: 48
        Rectangle { anchors { fill: gridContainer; margins: -4 } radius: 10; color: col_bg }

        Item {
            id: gridBounds
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
                        onClicked: function() {
                            if (selected) {
                                trackIndex = trackIndex === 0 ? 1 : 0
                                setModel(getTrack())
                            } else cellSelectionHandler(this)
                        }
                    }

                    CellSelector {
                        id: randomSelector
                        onClicked: function() {
                            if (selected) {
                                if (randomDensity > 0.4) randomDensity = 0.1
                                else randomDensity += 0.1
                                setModel(getRandomised())
                            } else cellSelectionHandler(this)
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
                var globalOrigin = gridBounds.mapToItem(rootContent, gridBounds.x, gridBounds.y)

                hoverIndex = 0
                input.checkBounds = true
                input.setBounds(Qt.rect(globalOrigin.x - gridBounds.x, globalOrigin.y - gridBounds.y, gridBounds.width, gridBounds.height))
            }
        }
    }

    Item {
        id: playButton
        Layout.preferredWidth: 48; Layout.preferredHeight: 48; z: 1

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

    Item {
        id: networkButton
        Layout.preferredWidth: 48; Layout.preferredHeight: 48; z: 0
        Rectangle { anchors { fill: networkContainer; margins: -4 } radius: 10; color: col_bg }

        Item {
            id: networkBounds
            height: networkContent.height; width: parent.width + networkContent.width
            anchors { right: parent.right; verticalCenter: parent.verticalCenter }
        }

        Item {
            id: networkContainer; clip: true
            height: networkContent.height; width: (networkHovered ? parent.width + networkContent.width : 0)
            anchors { right: parent.right; verticalCenter: parent.verticalCenter }
            Behavior on width { NumberAnimation { duration: 120; easing.type: Easing.OutQuad }}

            Rectangle { /* Icon bg */
                anchors { right: parent.right; verticalCenter: parent.verticalCenter }
                color: col_prim; width: parent.width + 6; height: networkButton.height; radius: 6
            }

            Rectangle { /* Content bg */
                width: networkContent.width; height: networkContent.height; radius: 6
                anchors { right: parent.right; rightMargin: 48 } color: col_prim
            }

            ColumnLayout {
                id: networkContent
                opacity: networkHovered ? 1 : 0
                anchors { right: parent.right; rightMargin: 48 }
                Behavior on opacity { OpacityAnimator { duration: 120; easing.type: Easing.OutQuad } }

                ColumnLayout {
                    Layout.fillWidth: true; Layout.topMargin: 4; spacing: 0

                    Switch_ {
                        id: useBakedSwitch
                        Layout.preferredWidth: 242; Layout.preferredHeight: 32
                        _col_prim: col_bg; _col_bg: col_prim; text: "Use Baked Network"; contentMargin: 8; fontSize: 18
                        onClicked: function() {
                            if (checked) {
                                trainTypeSwitch.setText("Train From Baked")
                                trainTypeSwitch.checked = trainFromBaked
                            }
                            else {
                                trainTypeSwitch.setText("Train Only On Crash", false)
                                trainTypeSwitch.checked = trainOnCrash
                            }

                            bakedMover = checked
                        }
                    }

                    Switch_ {
                        id: trainTypeSwitch
                        Layout.preferredWidth: 242; Layout.preferredHeight: 32
                        _col_prim: col_bg; _col_bg: col_prim; text: "Train Only On Crash"; contentMargin: 8; fontSize: 18
                        onClicked: function() {
                            switch (text) {
                            case "Train From Baked": trainFromBaked = checked; break
                            case "Train Only On Crash": trainOnCrash = checked; break
                            }
                        }
                    }
                }

                Button_ {
                    id: wipeButton
                    Layout.preferredWidth: 64; Layout.fillWidth: true
                    text: "Wipe Network"; _col_prim: col_bg; _col_bg: col_prim
                    Layout.leftMargin: 8; Layout.rightMargin: 8; Layout.bottomMargin: 8
                    onClicked: neural.resetNetwork()
                }
            }

            MouseArea {
                anchors { fill: networkContent; margins: 2 } hoverEnabled: true; visible: playActive
                Rectangle { anchors.fill: parent; color: col_bg; opacity: 0.9; radius: 6 }

                Text {
                    anchors.centerIn: parent
                    text: "Please stop the run\nto access this panel"
                    color: col_prim; font.pixelSize: 20; horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        Image_ {
            tint: networkHovered ? col_bg : col_prim
            source: 'qrc:/assets/Images/Icon_Network.png'
            anchors { fill: parent; margins: 8 } fillMode: Image.Stretch
        }

        MouseArea {
            id: networkHovery; anchors.fill: parent; hoverEnabled: true
            onEntered: function() {
                var globalOrigin = networkBounds.mapToItem(rootContent, networkBounds.x, networkBounds.y)

                hoverIndex = 2
                input.checkBounds = true
                input.setBounds(Qt.rect(globalOrigin.x - networkBounds.x, globalOrigin.y - networkBounds.y, networkBounds.width, networkBounds.height))
            }
        }
    }

    Component.onCompleted: function() {
        trackSelector.setModel(getTrack())
        randomSelector.setModel(getRandomised())
    }

    function playAction() {
        if (!playActive) {
            if (bakedMover) {
                if (perp.crashed) perp.reorient()
                startBaked()
            } else startNetwork()

            playActive = true
        }
        else {
            if (bakedMover) stopBaked()
            else stopNetwork()
            playActive = false
        }
    }

    function generateAction() {
        switch (popSelectorIndex) {
        case 0: grid.populateTrack(trackIndex); break
        case 1: grid.populateRandom(randomDensity); break
        }

        perp.relocate()
        setOrigin()
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
        for (var index = 0; index < Math.pow(randomSelector.rows, randomSelector.columns, 2); index++) {
            random.push(Math.random() > randomDensity ? 0 : 1)
        }
        return random
    }

    function getTrack() {
        switch (trackIndex) {
        case 0: return [
                    1, 1, 1, 1, 1, 1, 1,
                    1, 0, 0, 0, 0, 0, 1,
                    1, 0, 1, 1, 1, 0, 1,
                    1, 0, 0, 0, 0, 0, 1,
                    1, 1, 1, 1, 1, 1, 1
                ]

        case 1: return [
                    1, 1, 1, 1, 1, 1, 1,
                    1, 1, 0, 0, 0, 1, 1,
                    1, 0, 0, 1, 0, 0, 1,
                    1, 1, 0, 0, 0, 1, 1,
                    1, 1, 1, 1, 1, 1, 1
                ]
        }
    }
}
