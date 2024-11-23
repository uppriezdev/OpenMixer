// MainContent.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Components"
import "Pages"
Item {
    id: mainContent
    anchors.fill: parent

    // Properties passed from main.qml
    property string regularFont
    property string mediumFont
    property string semiBoldFont
    property string boldFont
    property color backgroundColor
    property color controlColor
    property color accentColor
    property color textColor
    property color dimTextColor

    // Property to track fullscreen state
    property bool isFullscreen: false

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Header {
            id: header
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            regularFont: mainContent.regularFont
            mediumFont: mainContent.mediumFont
            boldFont: mainContent.boldFont

            // Add function to handle navigation
            function navigateToPage(pageName) {
                rootPage.navigateToPage(pageName)
            }
        }
        SignalOverview {
            id: signalOverview
            Layout.fillWidth: true
            Layout.preferredHeight: 64
            regularFont: mainContent.regularFont
            mediumFont: mainContent.mediumFont
            boldFont: mainContent.boldFont
        }

        Root {
             id: rootPage
             Layout.fillWidth: true
             Layout.fillHeight: true

             regularFont: mainContent.regularFont
             mediumFont: mainContent.mediumFont
             semiBoldFont: mainContent.semiBoldFont
             boldFont: mainContent.boldFont
             backgroundColor: mainContent.backgroundColor
             controlColor: mainContent.controlColor
             accentColor: mainContent.accentColor
             textColor: mainContent.textColor
             dimTextColor: mainContent.dimTextColor
         }

        // Status Bar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 24
            color: controlColor

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                spacing: 20

                // Status indicators
                Row {
                    spacing: 20
                    Layout.alignment: Qt.AlignLeft

                    // Network Status
                    Row {
                        spacing: 4
                        Rectangle {
                            width: 8
                            height: 8
                            radius: 4
                            color: "#00FF00"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: "Network"
                            color: textColor
                            font.family: regularFont
                            font.pixelSize: 11
                        }
                    }

                    // Sync Status
                    Row {
                        spacing: 4
                        Rectangle {
                            width: 8
                            height: 8
                            radius: 4
                            color: "#00FF00"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: "Sync"
                            color: textColor
                            font.family: regularFont
                            font.pixelSize: 11
                        }
                    }

                    // Sample Rate
                    Text {
                        text: "48kHz"
                        color: textColor
                        font.family: regularFont
                        font.pixelSize: 11
                    }

                    // Buffer Size
                    Text {
                        text: "Buffer: 256"
                        color: textColor
                        font.family: regularFont
                        font.pixelSize: 11
                    }
                }

                // Center status
                Text {
                    Layout.alignment: Qt.AlignCenter
                    text: "Ready"
                    color: textColor
                    font.family: mediumFont
                    font.pixelSize: 11
                }

                // Right status with clock
                Row {
                    Layout.alignment: Qt.AlignRight
                    spacing: 20

                    Text {
                        id: timeText
                        color: textColor
                        font.family: regularFont
                        font.pixelSize: 11
                    }
                }
            }
        }
    }

    // Handle key events
    Item {
        focus: true
        Keys.onPressed: (event) => {
            // F11 for fullscreen toggle
            if (event.key === Qt.Key_F11) {
                toggleFullscreen()
                event.accepted = true
            }
            // ESC to exit fullscreen
            else if (event.key === Qt.Key_Escape && window.visibility === Window.FullScreen) {
                window.showNormal()
                isFullscreen = false
                event.accepted = true
            }
        }
    }

    // Function to toggle fullscreen
    function toggleFullscreen() {
        if (window.visibility === Window.FullScreen) {
            window.showNormal()
            isFullscreen = false
        } else {
            window.showFullScreen()
            isFullscreen = true
        }
    }

    // Clock timer
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            timeText.text = Qt.formatDateTime(new Date(), "hh:mm:ss")
        }
    }

    // Set initial time
    Component.onCompleted: {
        timeText.text = Qt.formatDateTime(new Date(), "hh:mm:ss")
    }
}
