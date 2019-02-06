import QtQuick 2.7
import QtQuick.Layouts 1.3

RowLayout {
    id: rootOT
    spacing: 8

    property string text: "Title"
    property color color: col_prim

    Rectangle { Layout.preferredWidth: 44; Layout.preferredHeight: 1; color: color }
    Rectangle { Layout.preferredHeight: 7; Layout.preferredWidth: 7; rotation: 45; color: color; Layout.alignment: Qt.AlignVCenter }

    Text {
        font { pixelSize: 17; bold: true }
        text: rootOT.text.toUpperCase(); color: rootOT.color
    }

    Rectangle { Layout.preferredHeight: 7; Layout.preferredWidth: 7; rotation: 45; color: color; Layout.alignment: Qt.AlignVCenter }
    Rectangle { Layout.preferredWidth: 44; Layout.preferredHeight: 1; color: color }
}
