#include "enginePlugin.h"
#include "dungeon.h"


EnginePlugin::EnginePlugin(QObject *parent) :
    QDeclarativeExtensionPlugin(parent)
{
}

void EnginePlugin::registerTypes(const char *uri)
{
    Q_ASSERT(QLatin1String(uri) == QLatin1String("Engine"));

    qmlRegisterType<Dungeon>(uri, 1, 0, "Dungeon");
}
