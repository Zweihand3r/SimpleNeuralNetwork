import QtQuick 2.7
import Qt.labs.settings 1.0

import './Data'

Item {
    id: rootDm

    property Themes themes: Themes {}

    property bool darkTheme: false
    property bool animDisabled: false

    /*property int themeIndex: 0*/

    Settings {
        property alias darkTheme: rootDm.darkTheme
        property alias animDisabled: rootDm.animDisabled

        /*property alias themeIndex: rootDm.themeIndex*/
    }
}
