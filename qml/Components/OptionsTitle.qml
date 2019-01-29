import QtQuick 2.7
import QtQuick.Layouts 1.3

RowLayout {
    id: rootOT

    property string text: "Title"
    property color color: col_prim

    Rectangle { Layout.preferredHeight: 5; Layout.preferredWidth: 5; rotation: 45; color: color }
    Rectangle { Layout.preferredHeight: 6; Layout.preferredWidth: 6; rotation: 45; color: color }
    Rectangle { Layout.preferredHeight: 7; Layout.preferredWidth: 7; rotation: 45; color: color }

    Text {
        text: rootOT.text.toUpperCase(); color: rootOT.color
        font { pixelSize: 17; bold: true }
    }

    Rectangle { Layout.preferredHeight: 7; Layout.preferredWidth: 7; rotation: 45; color: color }
    Rectangle { Layout.preferredHeight: 6; Layout.preferredWidth: 6; rotation: 45; color: color }
    Rectangle { Layout.preferredHeight: 5; Layout.preferredWidth: 5; rotation: 45; color: color }
}
