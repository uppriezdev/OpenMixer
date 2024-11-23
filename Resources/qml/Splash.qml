// Splash.qml
import QtQuick

Rectangle {
    id: splash
    color: "#1A1A1A"  // Same as your main backgroundColor

    property bool timeout: false
    property bool loaded: false
    signal finished()

    // Determine platform-specific splash image
    property string splashSource: {
        // Check if the current system is Arch Linux
        if (Qt.platform.os === "linux" && isArchLinux()) {
            return "qrc:/images/archsplash.png"
        } else {
            return "qrc:/images/archsplash.png"
        }
    }

    function isArchLinux() {
        // Detect Arch Linux using /etc/os-release (if available)
        try {
            var file = Qt.openFile("/etc/os-release", "r")
            if (file) {
                var content = file.readAll()
                file.close()
                return content.indexOf("Arch") !== -1
            }
        } catch (e) {
            console.error("Could not determine Linux distribution:", e)
        }
        return false
    }

    // Background image for the splash screen
    Image {
        id: splashBackground
        source: splashSource
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
    }

    Timer {
        id: splashTimer
        interval: 3000  // Adjust duration as needed (milliseconds)
        running: true
        repeat: false

        onTriggered: {
            splash.timeout = true
            if (splash.loaded) splash.finished()
        }
    }

    function setLoaded() {
        loaded = true
        if (timeout) finished()
    }
}
