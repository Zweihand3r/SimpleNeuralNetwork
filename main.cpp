#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "cpp/util/input.h"
#include "cpp/util/filemanager.h"
#include "cpp/neural.h"
#include "cpp/cpptests.h"
#include "cpp/pixelextractor.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);

    /* Need to change this. Or try initilizing class as well */
    qmlRegisterType<FileManager>("FileManager", 1, 1, "FileManager");

    QQmlApplicationEngine engine;

    Input *input = new Input(&app, &engine);
    engine.rootContext()->setContextProperty("input", input);

    Neural *neural = new Neural();
    engine.rootContext()->setContextProperty("neural", neural);

    CppTests *cppTests = new CppTests(neural);
    engine.rootContext()->setContextProperty("cppTests", cppTests);

    PixelExtractor *pixelExtractor = new PixelExtractor();
    engine.rootContext()->setContextProperty("pixelExtractor", pixelExtractor);

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    input->initializeTarget();

    return app.exec();
}
