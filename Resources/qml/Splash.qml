// Splash.qml
import QtQuick

Rectangle {
    id: splash
    color: "#1A1A1A"  // Same as your main backgroundColor

    property bool timeout: false
    property bool loaded: false
    signal finished()

    Image {
        id: logo
        source: "qrc:/icon/logo.svg"
        width: 64  // Adjust size as needed
        height: width
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
        opacity: 0

        SequentialAnimation {
            running: true

            // Fade in animation
            NumberAnimation {
                target: logo
                property: "opacity"
                from: 1
                to: 1
                duration: 1000
                easing.type: Easing.InOutQuad
            }

            // Wait a bit
            PauseAnimation {
                duration: 1000
            }

            // Fade out animation
            NumberAnimation {
                target: logo
                property: "opacity"
                from: 1
                to: 0
                duration: 1000
                easing.type: Easing.InOutQuad
            }

            onFinished: {
                splash.timeout = true
                if (splash.loaded) splash.finished()
            }
        }
    }

    function setLoaded() {
        loaded = true
        if (timeout) finished()
    }
}
