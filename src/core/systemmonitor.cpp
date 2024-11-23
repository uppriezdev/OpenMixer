// SystemMonitor.cpp
#include "SystemMonitor.hpp"
#include <QDebug>

SystemMonitor::SystemMonitor(QObject *parent)
    : QObject(parent)
    , m_cpuUsage(0)
    , m_ramUsage(0)
    , m_dspUsage(0)
    , m_latency("0.0ms")
    , m_sampleRate("48k")
{
#ifdef Q_OS_WIN
    SYSTEM_INFO sysInfo;
    GetSystemInfo(&sysInfo);
    m_numProcessors = sysInfo.dwNumberOfProcessors;
#endif

    connect(&m_updateTimer, &QTimer::timeout, this, &SystemMonitor::updateMetrics);
}

SystemMonitor::~SystemMonitor()
{
    stopMonitoring();
}

void SystemMonitor::startMonitoring()
{
    m_updateTimer.start(1000); // Update every second
}

void SystemMonitor::stopMonitoring()
{
    m_updateTimer.stop();
}

void SystemMonitor::updateMetrics()
{
    updateCPUUsage();
    updateRAMUsage();
    updateDSPUsage();
    updateAudioMetrics();
}

void SystemMonitor::updateCPUUsage()
{
#ifdef Q_OS_WIN
    FILETIME idleTime, kernelTime, userTime;
    GetSystemTimes(&idleTime, &kernelTime, &userTime);

    ULARGE_INTEGER now;
    ULARGE_INTEGER sys;
    ULARGE_INTEGER user;

    now.LowPart = idleTime.dwLowDateTime;
    now.HighPart = idleTime.dwHighDateTime;
    sys.LowPart = kernelTime.dwLowDateTime;
    sys.HighPart = kernelTime.dwHighDateTime;
    user.LowPart = userTime.dwLowDateTime;
    user.HighPart = userTime.dwHighDateTime;

    if (m_lastCPU.QuadPart != 0) {
        double percent = (1.0 - (double)(now.QuadPart - m_lastCPU.QuadPart) /
                                    (double)(sys.QuadPart - m_lastSysCPU.QuadPart +
                                              user.QuadPart - m_lastUserCPU.QuadPart)) * 100.0;
        m_cpuUsage = qBound(0.0, percent, 100.0);
        emit cpuUsageChanged();
    }

    m_lastCPU = now;
    m_lastSysCPU = sys;
    m_lastUserCPU = user;
#endif

#ifdef Q_OS_LINUX
// Implement Linux CPU monitoring
#endif
}

void SystemMonitor::updateRAMUsage()
{
#ifdef Q_OS_WIN
    MEMORYSTATUSEX memInfo;
    memInfo.dwLength = sizeof(MEMORYSTATUSEX);
    GlobalMemoryStatusEx(&memInfo);
    m_ramUsage = (double)memInfo.dwMemoryLoad;
    emit ramUsageChanged();
#endif

#ifdef Q_OS_LINUX
    struct sysinfo si;
    if (sysinfo(&si) == 0) {
        double total = si.totalram * si.mem_unit;
        double free = si.freeram * si.mem_unit;
        m_ramUsage = ((total - free) / total) * 100.0;
        emit ramUsageChanged();
    }
#endif
}

void SystemMonitor::updateDSPUsage()
{
    // Implement your DSP load calculation here
    // This is just a placeholder
    static double simulatedDSP = 0.0;
    simulatedDSP = (simulatedDSP + 1.0) > 100.0 ? 0.0 : simulatedDSP + 1.0;
    m_dspUsage = simulatedDSP;
    emit dspUsageChanged();
}

void SystemMonitor::updateAudioMetrics()
{
    // Implement your audio interface metrics here
    // This is just a placeholder
    m_latency = QString("%1ms").arg(QString::number(2.1, 'f', 1));
    m_sampleRate = "48k";
    emit latencyChanged();
    emit sampleRateChanged();
}
