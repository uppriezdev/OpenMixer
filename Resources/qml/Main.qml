// main.qml
import QtQuick
import QtQuick.Window
import QtQuick.Controls

ApplicationWindow {
    id: window
    visible: true
    visibility: Qt.WindowFullScreen
    flags: Qt.Window | Qt.FramelessWindowHint
    
    // Add these properties to track screen dimensions
    property int screenWidth: Screen.width
    property int screenHeight: Screen.height
    width: screenWidth
    height: screenHeight

    // Professional color scheme
    readonly property color backgroundColor: "#1A1A1A"
    readonly property color controlColor: "#252525"
    readonly property color accentColor: "#FFA000"
    readonly property color textColor: "#DEDEDE"
    readonly property color dimTextColor: "#808080"

    // Add FontLoaders at the top
    FontLoader {
        id: interDisplayRegular
        source: "qrc:/fonts/InterDisplay-Regular.ttf"
    }
    FontLoader {
        id: interDisplayMedium
        source: "qrc:/fonts/InterDisplay-Medium.ttf"
    }
    FontLoader {
        id: interDisplaySemiBold
        source: "qrc:/fonts/InterDisplay-SemiBold.ttf"
    }
    FontLoader {
        id: interDisplayBold
        source: "qrc:/fonts/InterDisplay-Bold.ttf"
    }

    // Font properties
    property alias regularFont: interDisplayRegular.name
    property alias mediumFont: interDisplayMedium.name
    property alias semiBoldFont: interDisplaySemiBold.name
    property alias boldFont: interDisplayBold.name

    // Add a Loader for the main content
    Loader {
        id: mainLoader
        anchors.fill: parent
        visible: false  // Initially hidden
    }

    // Add the Splash screen
    Splash {
        id: splashScreen
        anchors.fill: parent
        
        onFinished: {
            mainLoader.visible = true  // Show main content
            splashScreen.visible = false  // Hide splash screen
        }
    }

    // Load the main content
    Component.onCompleted: {
        // Start loading the main content
        mainLoader.setSource("MainContent.qml", {
            "regularFont": window.regularFont,
            "mediumFont": window.mediumFont,
            "semiBoldFont": window.semiBoldFont,
            "boldFont": window.boldFont,
            "backgroundColor": window.backgroundColor,
            "controlColor": window.controlColor,
            "accentColor": window.accentColor,
            "textColor": window.textColor,
            "dimTextColor": window.dimTextColor
        })
        
        // Simulate some loading time (remove this in production)
        timer.start()
    }

    // Timer to simulate loading (remove in production)
    Timer {
        id: timer
        interval: 3000  // Adjust as needed
        running: false
        repeat: false
        onTriggered: {
            splashScreen.setLoaded()
        }
    }
}
