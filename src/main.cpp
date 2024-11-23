#include "gui/app.hpp"
#include "core/systemmonitor.hpp"
#include "core/powerbutton.hpp" // Backend for PowerButton

int main(int argc, char *argv[]) {
    // Register SystemMonitor for QML
    qmlRegisterType<SystemMonitor>("com.openmixer.system", 1, 0, "SystemMonitor");

    // Register PowerMenu for QML as "SystemInterface"
    qmlRegisterType<PowerMenu>("com.openmixer.system", 1, 0, "SystemInterface");

    // App::engine()->rootContext()->setContextProperty("isWindows", isWindowsPlatform);

    // Run the application
    App::run(argc, argv);

    return 0;
}
