#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "cpp/filemanager.h"
#include "cpp/neural.h"
#include "cpp/cpptests.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);

    /* Need to change this. Or try initilizing class as well */
    qmlRegisterType<FileManager>("FileManager", 1, 1, "FileManager");

    QQmlApplicationEngine engine;

    Neural *neural = new Neural();
    engine.rootContext()->setContextProperty("neural", neural);

    CppTests *cppTests = new CppTests();
    engine.rootContext()->setContextProperty("cppTests", cppTests);

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
