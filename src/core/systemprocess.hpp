// systemprocess.h
#ifndef SYSTEMPROCESS_HPP
#define SYSTEMPROCESS_HPP

#include <QObject>
#include <QProcess>

class SystemProcess : public QObject
{
    Q_OBJECT

public:
    explicit SystemProcess(QObject *parent = nullptr);

    Q_INVOKABLE bool startDetached(const QString &program, const QStringList &arguments = QStringList());

private:
    QProcess m_process;
};

#endif // SYSTEMPROCESS_HPP
