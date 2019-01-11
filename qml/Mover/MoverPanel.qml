import QtQuick 2.7
import QtQuick.Layouts 1.3

import '../Controls'

Flickable {
    id: rootSwitchPanel
    contentHeight: colLt.height; contentWidth: width
    anchors { left: parent.left; top: parent.top; right: parent.right }

    ColumnLayout {
        id: colLt
    }
}
