// ErrorDialog.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Popup {
    id: errorDialog
    
    // Public properties
    property string title: "Error"
    property string message: ""
    property bool isWarning: false  // false = error, true = warning
    
    // Size and positioning
    width: 400
    height: contentColumn.height + 80
    modal: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    anchors.centerIn: parent
    
    // Background
    background: Rectangle {
        color: "#2D2D2D"
        radius: 8
        border.color: errorDialog.isWarning ? "#FFB100" : "#FF4444"
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
            
            // Warning/Error Icon
            Image {
                source: errorDialog.isWarning ? "qrc:/icons/warning.svg" : "qrc:/icons/error.svg"
                Layout.preferredWidth: 24
                Layout.preferredHeight: 24
                
                // Fallback if image is missing
                Text {
                    visible: parent.status === Image.Error
                    text: errorDialog.isWarning ? "⚠️" : "⛔"
                    color: errorDialog.isWarning ? "#FFB100" : "#FF4444"
                    font.pixelSize: 20
                    anchors.centerIn: parent
                }
            }
            
            // Title
            Label {
                text: errorDialog.title
                color: "white"
                font.pixelSize: 18
                font.bold: true
                Layout.fillWidth: true
            }
        }
        
        // Message
        Label {
            text: errorDialog.message
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
            
            // OK Button
            Button {
                text: "OK"
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
                
                onClicked: errorDialog.close()
            }
        }
    }
}