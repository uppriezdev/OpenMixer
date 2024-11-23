import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

ApplicationWindow {
    visible: true
    width: 600
    height: 400
    title: "Audio Mixer App"

    palette {
        window: "#121212"
        text: "#ffffff"
        buttonText: "#ffffff"
        highlight: "#bb86fc"
    }

    Button {
        text: "Show Error Dialog"
        anchors.centerIn: parent
        onClicked: errorWindow.visible = true
    }

    Window {
        id: errorWindow
        title: "Audio Mixer Error"
        width: 400
        height: 250
        visible: false
        flags: Qt.Dialog | Qt.WindowTitleHint | Qt.CustomizeWindowHint
        color: "#1f1f1f"

        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            // Error title
            Text {
                text: "Error: Unable to initialize audio device"
                wrapMode: Text.Wrap
                color: "#ff6666"
                font.pixelSize: 18
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Error message
            Text {
                text: "The selected audio interface could not be initialized. Please check your device connections and settings."
                wrapMode: Text.Wrap
                color: "white"
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            // Action buttons
            Row {
                spacing: 15
                anchors.horizontalCenter: parent.horizontalCenter

                Button {
                    text: "Retry"
                    background: Rectangle {
                        color: "#333333"
                        radius: 6
                    }
                    onClicked: {
                        errorWindow.visible = false
                        // Logic for retrying audio initialization
                        console.log("Retrying audio device initialization...")
                    }
                }

                Button {
                    text: "Open Settings"
                    background: Rectangle {
                        color: "#333333"
                        radius: 6
                    }
                    onClicked: {
                        errorWindow.visible = false
                        // Logic for navigating to settings page
                        console.log("Opening settings...")
                    }
                }

                Button {
                    text: "Close"
                    background: Rectangle {
                        color: "#333333"
                        radius: 6
                    }
                    onClicked: errorWindow.visible = false
                }
            }
        }
    }
}
