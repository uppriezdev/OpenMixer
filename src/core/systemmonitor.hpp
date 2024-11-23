// SystemMonitor.hpp
#pragma once

#include <QObject>
#include <QTimer>
#include <memory>

#ifdef Q_OS_WIN
#include <windows.h>
#include <psapi.h>
#elif defined(Q_OS_LINUX)
#include <sys/sysinfo.h>
#include <sys/statvfs.h>
#endif

class SystemMonitor : public QObject {
    Q_OBJECT
    Q_PROPERTY(double cpuUsage READ cpuUsage NOTIFY cpuUsageChanged)
    Q_PROPERTY(double ramUsage READ ramUsage NOTIFY ramUsageChanged)
    Q_PROPERTY(double dspUsage READ dspUsage NOTIFY dspUsageChanged)
    Q_PROPERTY(QString latency READ latency NOTIFY latencyChanged)
    Q_PROPERTY(QString sampleRate READ sampleRate NOTIFY sampleRateChanged)

public:
    explicit SystemMonitor(QObject *parent = nullptr);
    ~SystemMonitor();

    double cpuUsage() const { return m_cpuUsage; }
    double ramUsage() const { return m_ramUsage; }
    double dspUsage() const { return m_dspUsage; }
    QString latency() const { return m_latency; }
    QString sampleRate() const { return m_sampleRate; }

public slots:
    void startMonitoring();
    void stopMonitoring();

signals:
    void cpuUsageChanged();
    void ramUsageChanged();
    void dspUsageChanged();
    void latencyChanged();
    void sampleRateChanged();

private slots:
    void updateMetrics();

private:
    void updateCPUUsage();
    void updateRAMUsage();
    void updateDSPUsage();
    void updateAudioMetrics();

    QTimer m_updateTimer;
    double m_cpuUsage;
    double m_ramUsage;
    double m_dspUsage;
    QString m_latency;
    QString m_sampleRate;

#ifdef Q_OS_WIN
    ULARGE_INTEGER m_lastCPU;
    ULARGE_INTEGER m_lastSysCPU;
    ULARGE_INTEGER m_lastUserCPU;
    int m_numProcessors;
#endif
};
