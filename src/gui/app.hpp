#ifndef APP_HPP
#define APP_HPP

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QLoggingCategory>
#include <QDateTime>
#include <QDir>
#include <QScreen>

class QmlEngine : public QQmlApplicationEngine
{
    Q_OBJECT

public:
    QmlEngine();
    QStringList warnings;
    void handleWarning(const QString& warning);
};

class App
{
public:
    static void setupLogging();
    static void logSystemInfo();
    static void qtMessageHandler(QtMsgType type, 
                               const QMessageLogContext& context,
                               const QString& message);
    static QString logFile;
    static void run(int argc, char *argv[]);
};

#endif // APP_HPP