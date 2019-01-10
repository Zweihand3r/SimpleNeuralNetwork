import QtQuick 2.7
import Qt.labs.settings 1.0

import './Data'

Item {
    id: rootDm

    property Themes themes: Themes {}

    property int themeIndex: 0

    Settings {
        property alias themeIndex: rootDm.themeIndex
    }
}
