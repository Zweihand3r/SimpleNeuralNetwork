#include "filemanager.h"

FileManager::FileManager(QObject *parent) : QObject(parent)
{

}

void FileManager::saveFile(const QString string, const QString path)
{
    QDir dir(path);
    if (!dir.exists()) dir.mkpath(".");

    QFile file(path);
    if (file.open(QIODevice::WriteOnly | QIODevice::Truncate)) {
        QTextStream textStream;
        textStream.setDevice(&file);
        textStream << string;
        file.close();
    }
}

QString FileManager::loadFile(const QString path)
{

}

QString FileManager::getPath(FileManager::DefaultDirectories dir)
{
    switch (dir) {
    case FileManager::ApplicationDirectory:
        return QCoreApplication::applicationDirPath() + "/";

    case FileManager::CurrentDirectory:
    case FileManager::BuildDirectory:
        return QDir::currentPath() + "/";

    default:
        return "";
    }
}
