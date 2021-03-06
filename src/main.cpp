#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtCore>
#include <QQuickStyle>

#ifdef OAUTH2
#include "Auth.h"
#endif

#include "asyncsettings.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    app.setOrganizationName(QStringLiteral("Pygoscelis"));
    app.setOrganizationDomain(QStringLiteral("pygoscelis.org"));
    app.setApplicationName(QStringLiteral("DevOps Console"));

//    QTranslator translator;
//    translator.load("DevOps_fr_CA");
//    QCoreApplication::installTranslator(&translator);

    QQmlApplicationEngine engine;

#ifdef OAUTH2
//    TODO: remove hardcoded client id for OAuth2 authentication
    QScopedPointer<Auth> auth(new Auth("devops-console"));
    qmlRegisterSingletonInstance("QtPygo.auth", 1, 0, "Auth", auth.get());
#endif

    qmlRegisterType<AsyncSettings>("QtPygo.storage", 1, 0, "Settings");

#ifdef Q_OS_WASM
    const QUrl url(QStringLiteral("qrc:/entrypoint/WebEntry.qml"));
#else
//    TODO: Switch back to GenericEntry once we will provide external OAuth2 configuration
//    const QUrl url(QStringLiteral("qrc:/entrypoint/GenericEntry.qml"));
    const QUrl url(QStringLiteral("qrc:/entrypoint/WebEntry.qml"));
#endif

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
