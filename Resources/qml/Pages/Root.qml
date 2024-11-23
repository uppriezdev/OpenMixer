// Root.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root

    // Properties passed from MainContent
    property string regularFont
    property string mediumFont
    property string semiBoldFont
    property string boldFont
    property color backgroundColor
    property color controlColor
    property color accentColor
    property color textColor
    property color dimTextColor

    // Loading component
    Loading {
        id: loadingPopup
    }

    StackView {
        id: pageStack
        anchors.fill: parent
        initialItem: mixerView1

        pushEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 200
            }
        }

        pushExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 200
            }
        }

        replaceEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 200
            }
        }

        replaceExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 200
            }
        }
    }

    // Timer properties
    property Timer loadTimer: Timer {
        id: loadTimer
        interval: 100
        repeat: false
        property string pageName: ""

        onTriggered: {
            progressTimer.pageName = pageName;
            progressTimer.start();
        }
    }

    property Timer progressTimer: Timer {
        id: progressTimer
        interval: 20
        repeat: true
        property real progress: 0
        property string pageName: ""

        onTriggered: {
            progress += 0.1;
            loadingPopup.updateProgress(progress);

            if (progress >= 1) {
                stop();
                performPageSwitch(pageName);
            }
        }
    }

    // Components
    Component {
        id: mixerView1
        MixerView {
            accentColor: root.accentColor
            backgroundColor: root.backgroundColor
            controlColor: root.controlColor
            textColor: root.textColor
            dimTextColor: root.dimTextColor
        }
    }

    Component {
        id: mixerView2
        MixerView2 {
            accentColor: root.accentColor
            backgroundColor: root.backgroundColor
            controlColor: root.controlColor
            textColor: root.textColor
            dimTextColor: root.dimTextColor
        }
    }

    // Functions
    function navigateToPage(pageName) {
        console.log("Navigating to:", pageName);

        loadingPopup.show("Loading " + pageName + "...", true);

        // Stop any running timers
        if (loadTimer.running) loadTimer.stop();
        if (progressTimer.running) progressTimer.stop();

        // Reset progress
        progressTimer.progress = 0;

        // Start transition sequence
        loadTimer.pageName = pageName;
        loadTimer.start();
    }

    function performPageSwitch(pageName) {
        console.log("Performing switch to:", pageName);

        try {
            switch(pageName) {
                case "Mix 1":
                    pageStack.replace(mixerView1);
                    break;
                case "Mix 2":
                    pageStack.replace(mixerView2);
                    break;
                default:
                    console.log("Unhandled page:", pageName);
            }
        } catch (error) {
            console.error("Error switching page:", error);
        } finally {
            Qt.callLater(loadingPopup.hide);
        }
    }

    // Cleanup
    Component.onDestruction: {
        if (loadTimer.running) loadTimer.stop();
        if (progressTimer.running) progressTimer.stop();
    }
}
