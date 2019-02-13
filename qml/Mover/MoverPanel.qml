import QtQuick 2.7
import QtQuick.Layouts 1.3

import '../Controls'

Item {
    id: rootSwitchPanel; anchors { fill: parent }
    /* width: 48 */

    property bool gridHovered: hoverIndex === 0 && input.withinBounds
    property bool networkHovered: hoverIndex === 2 && input.withinBounds
    property bool infoHovered: infoHovery.containsMouse // hoverIndex === 3 && input.withinBounds

    /* In order of appearance */
    property int hoverIndex: 0

    property int popSelectorIndex: 0

    property int trackIndex: 0
    property real randomDensity: 0.2

    property bool playActive: false

    property bool bakedMover: false

    property bool alternateNetwork: false

    property int trainTypeIndex: 0
    property bool trainFromBaked: true

    readonly property var panelItems: [gridButton, networkButton, infoButton]
    readonly property var selectors: [trackSelector, randomSelector]

    function logMoves(inputs, out_0, out_1, out_2) { moveTable.setMoves(inputs, out_0, out_1, out_2) }

    ColumnLayout {
        id: layout; anchors.centerIn: parent

        Item {
            id: gridButton
            Layout.preferredWidth: 48; Layout.preferredHeight: 48
            Rectangle { anchors { fill: gridContainer; margins: -4 } visible: gridHovered; radius: 10; color: col_bg }

            Item {
                id: gridBounds
                height: gridContent.height; width: parent.width + gridContent.width
                anchors { right: parent.right; verticalCenter: parent.verticalCenter }
            }

            Item {
                id: gridContainer; clip: true
                height: gridContent.height; width: (gridHovered ? parent.width + gridContent.width : 0 )
                anchors { right: parent.right; verticalCenter: parent.verticalCenter }

                Behavior on width {
                    enabled: !dataManager.animDisabled
                    NumberAnimation { duration: 120; easing.type: Easing.OutQuad }
                }

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

                    Behavior on opacity {
                        enabled: !dataManager.animDisabled
                        OpacityAnimator { duration: 120; easing.type: Easing.OutQuad }
                    }

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
                    if (!input.withinBounds || hoverIndex !== 0) {
                        var globalOrigin = gridBounds.mapToItem(rootContent, gridBounds.x, gridBounds.y)

                        hoverIndex = 0
                        input.checkBounds = true
                        input.setBounds(Qt.rect(globalOrigin.x - gridBounds.x, globalOrigin.y - gridBounds.y, gridBounds.width, gridBounds.height))

                        pushItemDown(gridButton)
                    }
                }
            }
        }

        Item {
            id: playButton
            Layout.preferredWidth: 48; Layout.preferredHeight: 48; z: 2

            Rectangle {
                anchors { right: parent.right; top: parent.top; bottom: parent.bottom }
                color: col_prim; width: playHovery.containsMouse ? parent.width : 0; radius: 6
                Behavior on width { enabled: !dataManager.animDisabled; NumberAnimation { duration: 40 } }
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
                    enabled: !dataManager.animDisabled
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
            Rectangle { anchors { fill: networkContainer; margins: -4 } visible: networkHovered; radius: 10; color: col_bg }

            Item {
                id: networkBounds
                height: networkContent.height; width: parent.width + networkContent.width
                anchors { right: parent.right; verticalCenter: parent.verticalCenter }
            }

            Item {
                id: networkContainer; clip: true
                height: networkContent.height; width: (networkHovered ? parent.width + networkContent.width : 0)
                anchors { right: parent.right; verticalCenter: parent.verticalCenter }
                Behavior on width { enabled: !dataManager.animDisabled; NumberAnimation { duration: 160; easing.type: Easing.OutQuad }}

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

                    Behavior on opacity {
                        enabled: !dataManager.animDisabled
                        OpacityAnimator { duration: 160; easing.type: Easing.OutQuad }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true; spacing: 0
                        Layout.topMargin: 4; Layout.leftMargin: 8; Layout.rightMargin: 8

                        Switch_ {
                            id: useBakedSwitch
                            Layout.preferredWidth: 242; Layout.preferredHeight: 32
                            _col_prim: col_bg; _col_bg: col_prim; text: "Use Baked Network"; fontSize: 18
                            onClicked: function() {
                                if (checked) trainTypeDropdown.setDropdownItems(["Baked", "None"], trainFromBaked ? 0 : 1)
                                else trainTypeDropdown.setDropdownItems(["Every Step", "On Crash", "None"], trainTypeIndex)

                                bakedMover = checked
                            }
                        }

                        Switch_ {
                            id: altNetworkSwitch
                            Layout.preferredWidth: 242; Layout.preferredHeight: 32
                            _col_prim: col_bg; _col_bg: col_prim; text: "Alternate Network"; fontSize: 18
                            onClicked: alternateNetwork = !alternateNetwork
                        }

                        RowLayout {
                            Layout.preferredWidth: 242; Layout.preferredHeight: 32

                            Text {
                                id: switchText
                                Layout.alignment: Qt.AlignVCenter
                                text: "Speed"; color: col_bg; font.pixelSize: 18
                            }

                            Item { Layout.preferredWidth: 20 }

                            Slider_ {
                                _col_prim: col_bg; _col_bg: col_prim
                                Layout.fillWidth: true; Layout.preferredHeight: 20
                                onValueChanged: function() {
                                    perp_interval = (1 - value) * 300 + 60
                                }

                                Component.onCompleted: setValue(0.8)
                            }
                        }
                    }

                    Button_Dropdown {
                        id: trainTypeDropdown
                        enabled: !(alternateNetwork && !bakedMover)
                        dropdownItems: ["Every Step", "On Crash", "None"]
                        text: "Training"; _col_prim: col_bg; _col_bg: col_prim
                        Layout.preferredWidth: 64; Layout.fillWidth: true; Layout.leftMargin: 8; Layout.rightMargin: 8
                        onDelayedClick: function() {
                            if (bakedMover) trainFromBaked = currentIndex === 0
                            else trainTypeIndex = currentIndex
                        }
                    }

                    Button_ {
                        id: wipeButton
                        Layout.preferredWidth: 64; Layout.fillWidth: true
                        text: "Wipe Network"; _col_prim: col_bg; _col_bg: col_prim
                        Layout.leftMargin: 8; Layout.rightMargin: 8; Layout.bottomMargin: 8
                        onClicked: function() {
                            resetCounters()
                            moveTable.wipe()
                            neural.resetNetwork()
                        }
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
                    if (!input.withinBounds || hoverIndex !== 2) {
                        var globalOrigin = networkBounds.mapToItem(rootContent, networkBounds.x, networkBounds.y)

                        hoverIndex = 2
                        input.checkBounds = true
                        input.setBounds(Qt.rect(globalOrigin.x - networkBounds.x, globalOrigin.y - networkBounds.y - 32,
                                                networkBounds.width, networkBounds.height + 64))

                        pushItemDown(networkButton)
                    }
                }
            }
        }

        Item {
            id: infoButton
            Layout.preferredWidth: 48; Layout.preferredHeight: 48; z: 0
            Rectangle { anchors { fill: infoContainer; margins: -4 } visible: infoHovered; radius: 10; color: col_bg }

            Item {
                id: infoBounds
                height: infoContent.height; width: parent.width + infoContent.width
                anchors { right: parent.right; verticalCenter: parent.verticalCenter }
            }

            Item {
                id: infoContainer; clip: true
                height: infoContent.height; width: (infoHovered ? parent.width + infoContent.width : 0)
                anchors { right: parent.right; verticalCenter: parent.verticalCenter }

                Behavior on width {
                    enabled: !dataManager.animDisabled
                    NumberAnimation { duration: 180; easing.type: Easing.OutQuad }
                }

                Rectangle { /* Icon bg */
                    anchors { right: parent.right; verticalCenter: parent.verticalCenter }
                    color: col_prim; width: parent.width + 6; height: infoButton.height; radius: 6
                }

                Rectangle { /* Content bg */
                    width: infoContent.width; height: infoContent.height; radius: 6
                    anchors { right: parent.right; rightMargin: 48 } color: col_prim
                }

                RowLayout {
                    id: infoContent
                    opacity: infoHovered ? 1 : 0
                    anchors { right: parent.right; rightMargin: 48 }

                    Behavior on opacity {
                        enabled: !dataManager.animDisabled
                        OpacityAnimator { duration: 180; easing.type: Easing.OutQuad }
                    }

                    MoveTable {
                        id: moveTable
                        Layout.leftMargin: empty ? 0 : 12
                    }

                    ColumnLayout {
                        visible: !moveTable.empty
                        Layout.alignment: Qt.AlignVCenter; Layout.leftMargin: 16

                        Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 64; color: col_bg; Layout.leftMargin: 2.5 }
                        Rectangle { Layout.preferredHeight: 6; Layout.preferredWidth: 6; rotation: 45; color: col_bg }
                        Rectangle { Layout.preferredWidth: 1; Layout.preferredHeight: 64; color: col_bg; Layout.leftMargin: 2.5 }
                    }

                    ColumnLayout {
                        Layout.preferredWidth: 170

                        Text {
                            color: col_bg; font.pixelSize: 18
                            text: "Trained a total of\n" + trainCount + " times"
                            Layout.fillWidth: true; Layout.topMargin: 8; lineHeight: 0.8
                            horizontalAlignment: Text.AlignHCenter; wrapMode: Text.WordWrap
                        }

                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            Layout.topMargin: 6; Layout.bottomMargin: 3

                            Rectangle { Layout.preferredWidth: 44; Layout.preferredHeight: 1; color: col_bg }
                            Rectangle { Layout.preferredHeight: 6; Layout.preferredWidth: 6; rotation: 45; color: col_bg }
                            Rectangle { Layout.preferredWidth: 44; Layout.preferredHeight: 1; color: col_bg }
                        }

                        Text {
                            color: col_bg; font.pixelSize: 18
                            Layout.fillWidth: true; lineHeight: 0.8
                            text: "Moved " + moveCount + "\nsquares since last\ncrash"
                            horizontalAlignment: Text.AlignHCenter; wrapMode: Text.WordWrap
                        }

                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            Layout.topMargin: 8; Layout.bottomMargin: 3

                            Rectangle { Layout.preferredWidth: 44; Layout.preferredHeight: 1; color: col_bg }
                            Rectangle { Layout.preferredHeight: 6; Layout.preferredWidth: 6; rotation: 45; color: col_bg }
                            Rectangle { Layout.preferredWidth: 44; Layout.preferredHeight: 1; color: col_bg }
                        }

                        Text {
                            Layout.fillWidth: true; Layout.bottomMargin: -9
                            text: "Crashed a total of"; color: col_bg; font.pixelSize: 18
                            horizontalAlignment: Text.AlignHCenter; wrapMode: Text.WordWrap
                        }

                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter; Layout.bottomMargin: 8
                            Text { text: crashCount; color: "red"; font.pixelSize: 18 }
                            Text { text: "times"; color: col_bg; font.pixelSize: 18 }
                        }
                    }
                }
            }

            ColumnLayout {
                spacing: -6; anchors {
                    /*left: parent.left; right: parent.right; bottom: parent.bottom; bottomMargin: -12*/
                    centerIn: parent; verticalCenterOffset: 2
                }

                Text {
                    text: formatCount(moveCount)
                    color: infoHovered ? col_bg : col_prim
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    font.pixelSize: 25
                    text: crashCount; color: "red"
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            MouseArea {
                id: infoHovery; anchors.fill: parent; hoverEnabled: true
                onEntered: function() {
                    if (!input.withinBounds || hoverIndex !== 3) {
                        var globalOrigin = infoBounds.mapToItem(rootContent, infoBounds.x, infoBounds.y)

                        hoverIndex = 3
                        input.checkBounds = true
                        input.setBounds(Qt.rect(globalOrigin.x - infoBounds.x, globalOrigin.y - infoBounds.y, infoBounds.width, infoBounds.height))

                        pushItemDown(infoButton)
                    }
                }
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
                if (perp.crashed) {
                    moveCount = 0
                    perp.reorient()
                }

                startBaked()
            }
            else {
                if (alternateNetwork) startAltNetwork()
                else startNetwork()
            }

            playActive = true
        }
        else {
            if (bakedMover) stopBaked()
            else {
                if (alternateNetwork) stopAltNetwork()
                else stopNetwork()
            }

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

    function pushItemDown(item) {
        panelItems.forEach(function(_item) {
            _item.z = _item === item ? 0 : 1
        })
    }

    function getRandomised() {
        var random = []
        for (var index = 0; index < Math.pow(randomSelector.rows, randomSelector.columns, 2); index++) {
            random.push(Math.random() > randomDensity ? 0 : 1)
        }
        return random
    }

    function formatCount(count) {
        var countStr = count.toString()
        if (countStr.length > 6) {
            countStr = countStr.substring(0, countStr.length - 6) + "M"
        } else if (countStr.length > 4) {
            countStr = countStr.substring(0, countStr.length - 3) + "K"
        }

        return countStr
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
