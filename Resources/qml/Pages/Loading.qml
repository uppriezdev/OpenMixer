// Loading.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects // Cross-platform effect handling

Popup {
    id: loadingPopup
    modal: true
    closePolicy: Popup.NoAutoClose
    anchors.centerIn: Overlay.overlay
    width: 300
    height: 200
    padding: 0

    // Properties
    property string message: "Loading..."
    property real progress: 0
    property bool showProgress: false
    property color accentColor: "#00A6D6"
    property string regularFont: "Segoe UI"

    // Background dimming
    Overlay.modal: Rectangle {
        color: "#80000000"
    }

    background: Rectangle {
        color: "#1E1E1E"
        border.color: "#363636"
        border.width: 1
        radius: 8

        // Cross-platform drop shadow
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "#80000000"
            shadowVerticalOffset: 2
            shadowHorizontalOffset: 0
            shadowBlur: 0.1
        }
    }

    contentItem: Item {
        ColumnLayout {
            anchors.fill: parent
            spacing: 20
            anchors.margins: 20

            // Spinner
            Item {
                Layout.alignment: Qt.AlignHCenter
                width: 48
                height: 48

                RotationAnimator {
                    target: spinner
                    from: 0
                    to: 360
                    duration: 1200
                    running: loadingPopup.visible
                    loops: Animation.Infinite
                }

                Image {
                    id: spinner
                    source: "qrc:/icon/loading.svg"
                    width: parent.width
                    height: parent.height
                    sourceSize: Qt.size(width, height)
                    smooth: true
                    antialiasing: true
                }
            }

            // Message
            Label {
                Layout.alignment: Qt.AlignHCenter
                text: loadingPopup.message
                color: "#FFFFFF"
                font.family: regularFont
                font.pixelSize: 14
            }

            // Progress Bar (visible only when showProgress is true)
            ProgressBar {
                Layout.fillWidth: true
                visible: loadingPopup.showProgress
                value: loadingPopup.progress
                from: 0
                to: 1.0

                background: Rectangle {
                    implicitWidth: 200
                    implicitHeight: 6
                    color: "#2A2A2A"
                    radius: 3
                }

                contentItem: Item {
                    implicitWidth: 200
                    implicitHeight: 6

                    Rectangle {
                        width: parent.width * loadingPopup.progress
                        height: parent.height
                        radius: 3
                        color: accentColor
                    }
                }
            }

            // Progress Text (visible only when showProgress is true)
            Label {
                Layout.alignment: Qt.AlignHCenter
                visible: loadingPopup.showProgress
                text: Math.round(loadingPopup.progress * 100) + "%"
                color: "#FFFFFF"
                font.family: regularFont
                font.pixelSize: 12
            }
        }
    }

    // Open and Close functions
    function show(msg = "Loading...", showProgressBar = false) {
        message = msg
        showProgress = showProgressBar
        progress = 0
        open()
    }

    function updateProgress(value) {
        progress = Math.min(Math.max(value, 0), 1)
    }

    function hide() {
        // Ensure any ongoing animations are completed
        progress = 1.0;
        // Use Qt.callLater to ensure proper cleanup
        Qt.callLater(close);
    }

    // Cleanup when the popup is closed
    onClosed: {
        progress = 0;
        showProgress = false;
    }

    // Cleanup when the component is destroyed
    Component.onDestruction: {
        if (visible) {
            close();
        }
    }
}
