#include <QApplication>
#include "qmlapplicationviewer.h"
#include "box2dplugin.h"
#include "enginePlugin.h"

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    Box2DPlugin plugin;
    plugin.registerTypes("Box2D");

    QmlApplicationViewer viewer;
    viewer.addImportPath(QLatin1String("modules"));
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/ANGSC1/main.qml"));
    viewer.showExpanded();

    EnginePlugin engine;
    engine.registerTypes("Engine");





    return app->exec();
}
