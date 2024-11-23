// powerbutton.cpp
#include "powerbutton.hpp"
#include <QProcess>
#include <QDebug>

#ifdef _WIN32
#include <windows.h>
#endif

PowerMenu::PowerMenu(QObject* parent)
    : QObject(parent)
{
}

void PowerMenu::shutdown() {
#ifdef _WIN32
    // Windows shutdown command using QProcess
    QProcess::startDetached("shutdown", QStringList() << "/s" << "/t" << "0");
#else
    // Linux shutdown command using QProcess
    QProcess::startDetached("shutdown", QStringList() << "-h" << "now");
#endif
}

void PowerMenu::restart() {
#ifdef _WIN32
    // Windows restart command using QProcess
    QProcess::startDetached("shutdown", QStringList() << "/r" << "/t" << "0");
#else
    // Linux restart command using QProcess
    QProcess::startDetached("reboot");
#endif
}

void PowerMenu::switchToDesktop() {
#ifdef _WIN32
    // Disabled on Windows
    qDebug() << "Switch to Desktop is not supported on Windows.";
#else
    // Linux command to switch desktop using QProcess
    QProcess::startDetached("/home/miko/switch-desktop.sh");
#endif
}
