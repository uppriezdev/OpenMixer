#include "gui/app.hpp"
#include "core/systemmonitor.hpp"

int main(int argc, char *argv[]) {
    qmlRegisterType<SystemMonitor>("com.openmixer.system", 1, 0, "SystemMonitor");
    App::run(argc, argv);
    return 0;
}
