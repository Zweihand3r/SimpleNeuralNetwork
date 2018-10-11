#ifndef FILEMANAGER_H
#define FILEMANAGER_H

#include <QCoreApplication>
#include <QObject>
#include <QDebug>
#include <QFile>
#include <QDir>

class FileManager : public QObject
{
    Q_OBJECT

public:
    explicit FileManager(QObject *parent = nullptr);

    enum DefaultDirectories {
        ApplicationDirectory,
        CurrentDirectory,
        BuildDirectory
    };
    Q_ENUMS(DefaultDirectories)

signals:

public slots:
    void saveFile(const QString string, const QString path);
    QString loadFile(const QString path);
    QString getPath(DefaultDirectories dir);
};

#endif // FILEMANAGER_H
