import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Popup {
    id: dialogPopup

    // Public properties
    property string title: "Confirm"
    property string message: "Are you sure?"

    // Public signals
    signal confirmed()
    signal canceled()

    // Size and positioning
    width: 400
    height: 200
    modal: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    // // Center the dialog on the screen using the screen size
    // x: (Screen.width - width) / 2
    // y: (Screen.height - height) / 2

    // Background
    background: Rectangle {
        color: "#2D2D2D"
        radius: 8
        border.color: "#FFB100"
        border.width: 2
    }

    // Content
    ColumnLayout {
        id: contentColumn
        width: parent.width - 40
        spacing: 20
        anchors {
            top: parent.top
            topMargin: 20
            horizontalCenter: parent.horizontalCenter
        }

        // Icon and Title Row
        RowLayout {
            Layout.fillWidth: true
            spacing: 15

            // Confirmation Icon
            Image {
                source: "qrc:/icons/question.svg"
                Layout.preferredWidth: 24
                Layout.preferredHeight: 24

                // Fallback if image is missing
                Text {
                    visible: parent.status === Image.Error
                    text: "❓"
                    color: "#FFB100"
                    font.pixelSize: 20
                    anchors.centerIn: parent
                }
            }

            // Title
            Label {
                text: dialogPopup.title
                color: "white"
                font.pixelSize: 18
                font.bold: true
                Layout.fillWidth: true
            }
        }

        // Message
        Label {
            text: dialogPopup.message
            color: "#CCCCCC"
            font.pixelSize: 14
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.maximumWidth: parent.width
        }

        // Button Row
        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 10
            spacing: 10

            Item { Layout.fillWidth: true } // Spacer

            // Confirm Button
            Button {
                text: "Confirm"
                Layout.preferredWidth: 100

                background: Rectangle {
                    color: parent.down ? "#404040" : "#505050"
                    radius: 4
                }

                contentItem: Text {
                    text: parent.text
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    dialogPopup.close()
                    dialogPopup.confirmed()
                }
            }

            // Cancel Button
            Button {
                text: "Cancel"
                Layout.preferredWidth: 100

                background: Rectangle {
                    color: parent.down ? "#404040" : "#505050"
                    radius: 4
                }

                contentItem: Text {
                    text: parent.text
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    dialogPopup.close()
                    dialogPopup.canceled()
                }
            }
        }
    }
}
