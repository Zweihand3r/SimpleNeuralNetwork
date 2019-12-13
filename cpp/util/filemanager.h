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
    Q_PROPERTY(QString currentPath READ currentPath CONSTANT)

public:
    explicit FileManager(QObject *parent = nullptr);

    QString currentPath() { return QDir::currentPath(); }

signals:

public slots:
    /* General */
    void saveFile(const QString string, const QString path, const QString fileName);
    QString loadFile(const QString path);

    bool checkIfDirExists(const QString path);

    QStringList getDirFileNames(const QString dirPath, const QStringList filters);

    /* Specific */
    void extractMnist();
};

#endif // FILEMANAGER_H
