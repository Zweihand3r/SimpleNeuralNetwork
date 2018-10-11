import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import FileManager 1.1

import "./Tests"

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Simple Neural Network")

    FileManager {
        id: fileManager
    }

    Component.onCompleted: {
        var path = fileManager.getPath(FileManager.CurrentDirectory)
        console.log(path)
        fileManager.saveFile("Hey you", path + "Data/Test.txt")
    }
}
