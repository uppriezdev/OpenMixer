#include "app.hpp"
#include <QDebug>
#include <QStandardPaths>
#include <QFile>
#include <QTextStream>
#include <QOperatingSystemVersion>
#include <QSysInfo>

QString App::logFile;

QmlEngine::QmlEngine() : QQmlApplicationEngine() {}

void QmlEngine::handleWarning(const QString& warning) {
    warnings.append(warning);
    qWarning() << "QML Warning:" << warning;
}

void App::setupLogging() {
    // Create logs directory if it doesn't exist
    QDir dir;
    if (!dir.exists("logs")) {
        dir.mkpath("logs");
    }

    // Setup logging with timestamp in filename
    QString timestamp = QDateTime::currentDateTime().toString("yyyyMMdd_hhmmss");
    logFile = QString("logs/output_%1.log").arg(timestamp);

    // Redirect qDebug output to file
    qInstallMessageHandler(qtMessageHandler);
}

void App::qtMessageHandler(QtMsgType type,
                         const QMessageLogContext& context,
                         const QString& message) {
    QString filename = context.file ? context.file : "Unknown";
    int line = context.line;
    QString function = context.function ? context.function : "Unknown";

    QString formattedMessage =
        QString("%1:%2: %3").arg(filename).arg(line).arg(message);

    QFile file(logFile);
    if (file.open(QIODevice::WriteOnly | QIODevice::Append)) {
        QTextStream stream(&file);
        QString timestamp = QDateTime::currentDateTime().toString("yyyy-MM-dd hh:mm:ss.zzz");

        switch (type) {
            case QtDebugMsg:
                stream << QString("%1 [DEBUG] %2\n").arg(timestamp).arg(formattedMessage);
                break;
            case QtInfoMsg:
                stream << QString("%1 [INFO] %2\n").arg(timestamp).arg(formattedMessage);
                break;
            case QtWarningMsg:
                stream << QString("%1 [WARNING] %2\n").arg(timestamp).arg(formattedMessage);
                break;
            case QtCriticalMsg:
                stream << QString("%1 [CRITICAL] %2\n").arg(timestamp).arg(formattedMessage);
                break;
            case QtFatalMsg:
                stream << QString("%1 [FATAL] %2\n").arg(timestamp).arg(formattedMessage);
                abort();
        }
        file.close();
    }
}

void App::logSystemInfo() {
    qInfo() << "=== System Information ===";
    qInfo() << "Qt Version:" << QT_VERSION_STR;
    qInfo() << "OS:" << QSysInfo::prettyProductName();
    qInfo() << "Kernel Type:" << QSysInfo::kernelType();
    qInfo() << "Kernel Version:" << QSysInfo::kernelVersion();
    qInfo() << "Machine Architecture:" << QSysInfo::currentCpuArchitecture();
    qInfo() << "Host Name:" << QSysInfo::machineHostName();
    qInfo() << "========================";
}

void App::run(int argc, char *argv[]) {
    try {
        setupLogging();
        qInfo() << "Application started - Log file:" << logFile;

        QGuiApplication app(argc, argv);
        qInfo() << "QGuiApplication created";

        logSystemInfo();

        // Set the current directory to the application directory
        QString appDir = QCoreApplication::applicationDirPath();
        QDir::setCurrent(appDir);
        qInfo() << "Working directory:" << appDir;

        QmlEngine engine;
        qInfo() << "QML Engine created";

        // Load the QML file
        // QString qmlFile = appDir + "/qml/Main.qml";
        // qInfo() << "Loading QML file:" << qmlFile;
        engine.load(QUrl("qrc:/qml/Main.qml"));

        // Check if QML loaded successfully
        if (engine.rootObjects().isEmpty()) {
            qCritical() << "Failed to load QML file";
            if (!engine.warnings.isEmpty()) {
                qCritical() << "QML Warnings during loading:";
                for (const QString& warning : engine.warnings) {
                    qCritical() << "  -" << warning;
                }
            }
            exit(-1);
        }

        qInfo() << "QML file loaded successfully";

        // Get the root window
        QObject* window = engine.rootObjects().first();

        // Get the primary screen
        QScreen* screen = QGuiApplication::primaryScreen();

        if (screen) {
            QRect screenGeometry = screen->geometry();
            qInfo() << "Screen resolution:"
                   << screenGeometry.width() << "x" << screenGeometry.height();

            // Set window to fullscreen
            window->setProperty("visibility", Qt::WindowFullScreen);
            window->setProperty("x", screenGeometry.x());
            window->setProperty("y", screenGeometry.y());

            qInfo() << "Application set to fullscreen mode";
        } else {
            qWarning() << "Could not detect primary screen";
        }

        qInfo() << "Starting application event loop";
        int exitCode = app.exec();
        qInfo() << "Application exited with code:" << exitCode;
        exit(exitCode);

    } catch (const std::exception& e) {
        qCritical() << "Unhandled exception occurred:" << e.what();
        exit(1);
    }
}
