// systemprocess.cpp
#include "systemprocess.hpp"
#include <QDebug>

SystemProcess::SystemProcess(QObject *parent)
    : QObject(parent)
{
}

bool SystemProcess::startDetached(const QString &program, const QStringList &arguments)
{
    qDebug() << "Starting process:" << program << arguments;
    return QProcess::startDetached(program, arguments);
}
