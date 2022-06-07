#include "filemanager.h"

FileManager::FileManager(QObject *parent) : QObject(parent)
{

}

void FileManager::saveFile(const QString string, const QString path, const QString fileName)
{
    QDir dir(path);
    if (!dir.exists()) dir.mkpath(".");

    QFile file(path + "/" + fileName);
    if (file.open(QIODevice::WriteOnly | QIODevice::Truncate)) {
        QTextStream textStream;
        textStream.setDevice(&file);
        textStream << string;
        file.close();
    }
}

QString FileManager::loadFile(const QString path)
{
    return "";
}

bool FileManager::checkIfDirExists(const QString path)
{
    QDir dir(path);
    return dir.exists();
}

QStringList FileManager::getDirFileNames(const QString dirPath, const QStringList filters)
{
    QDir dir(dirPath);
    if (dir.exists()) {
        return  dir.entryList(filters, QDir::Files | QDir::NoDotAndDotDot);
    } else {
        qDebug() << "filemanager.cpp: Directory at path " << dirPath << " does not exist";
        return {};
    }
}
