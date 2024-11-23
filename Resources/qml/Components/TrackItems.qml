// TrackItem.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: trackItem
    property int minimumWidth: 80
    property int maximumWidth: 128
    width: parent ? Math.max(minimumWidth, Math.min(maximumWidth, parent.width / 16)) : minimumWidth
    height: parent.height
    color: "#1A1A1A"

    // Professional X32-like color scheme
    property color accentColor: "#FFA000"      // Orange accent like X32
    property color textColor: "#DEDEDE"        // Light text
    property color dimTextColor: "#808080"     // Dimmed text
    property color backgroundColor: "#1A1A1A"  // Dark background
    property color controlColor: "#252525"     // Control background
    property color buttonHoverColor: "#303030" // Hover state
    property color meterGreen: "#00FF00"      // VU meter green
    property color meterYellow: "#FFFF00"     // VU meter yellow
    property color meterRed: "#FF0000"        // VU meter red
    property int channelNumber: 1

    GridLayout {
        anchors.fill: parent
        anchors.margins: 2
        rowSpacing: 2
        columnSpacing: 2
        columns: 1

        // Channel Number and Solo
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 28
            color: controlColor
            radius: 2

            RowLayout {
                anchors.fill: parent
                anchors.margins: 2
                spacing: 2

                Label {
                    Layout.fillWidth: true
                    text: (channelNumber < 10 ? "0" : "") + channelNumber
                    color: textColor
                    font.pixelSize: 12
                    font.bold: true
                    font.family: "Segoe UI"
                    horizontalAlignment: Text.AlignHCenter
                }

                Button {
                    Layout.preferredWidth: 45
                    Layout.preferredHeight: 22
                    text: "SOLO"
                    checkable: true

                    contentItem: Text {
                        text: parent.text
                        color: parent.checked ? "#FFFFFF" : dimTextColor
                        font.pixelSize: 10
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        color: parent.checked ? accentColor :
                               parent.hovered ? buttonHoverColor : controlColor
                        radius: 2
                        border.color: parent.checked ? accentColor : "#404040"
                        border.width: 1
                    }
                }
            }
        }

        // Input Selection
        ComboBox {
            id: inputSelector
            Layout.fillWidth: true
            Layout.preferredHeight: 24
            model: ["Input 1", "Input 2", "Input 3", "Input 4"]
            currentIndex: 0

            background: Rectangle {
                color: controlColor
                radius: 2
                border.color: "#404040"
                border.width: 1
            }

            contentItem: Text {
                text: parent.displayText
                color: textColor
                font.pixelSize: 11
                verticalAlignment: Text.AlignVCenter
                leftPadding: 8
            }

            delegate: ItemDelegate {
                width: parent.width
                height: 24

                contentItem: Text {
                    text: modelData
                    color: textColor
                    font.pixelSize: 11
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    color: parent.highlighted ? buttonHoverColor : controlColor
                }
            }

            popup: Popup {
                y: parent.height
                width: parent.width
                padding: 1
                z: 1000

                background: Rectangle {
                    color: backgroundColor
                    border.color: "#404040"
                    border.width: 1
                }

                contentItem: ListView {
                    implicitHeight: contentHeight
                    model: inputSelector.popup.visible ? inputSelector.delegateModel : null
                    clip: true
                }
            }
        }

        // 48V and Phase Controls
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 24
            spacing: 2

            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 24
                text: "48V"
                checkable: true

                contentItem: Text {
                    text: parent.text
                    color: parent.checked ? "#FF4040" : dimTextColor
                    font.pixelSize: 11
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    color: parent.checked ? "#402020" :
                           parent.hovered ? buttonHoverColor : controlColor
                    radius: 2
                    border.color: parent.checked ? "#FF4040" : "#404040"
                    border.width: 1
                }
            }

            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 24
                text: "Φ"
                checkable: true

                contentItem: Text {
                    text: parent.text
                    color: parent.checked ? accentColor : dimTextColor
                    font.pixelSize: 14
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    color: parent.checked ? "#403020" :
                           parent.hovered ? buttonHoverColor : controlColor
                    radius: 2
                    border.color: parent.checked ? accentColor : "#404040"
                    border.width: 1
                }
            }
        }

        // Gain Control
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            color: controlColor
            radius: 2
            border.color: "#404040"
            border.width: 1

            Dial {
                id: gainDial
                anchors.centerIn: parent
                width: 60
                height: 60
                from: 0
                to: 127
                value: 64
                inputMode: Dial.Vertical  // Set to respond to vertical movement

                // Optional: Adjust sensitivity
                stepSize: 1

                background: Item {
                    width: parent.width
                    height: parent.height

                    Image {
                        id: knobImage
                        source: "qrc:/images/knob2.png"
                        width: parent.width * 128
                        height: parent.height
                        x: -Math.floor(gainDial.value) * parent.width
                        fillMode: Image.PreserveAspectFit
                    }
                    clip: true
                }

                handle: Item { }

                // Custom mouse handling for more precise control
                MouseArea {
                    anchors.fill: parent
                    property real lastY: 0

                    onPressed: {
                        lastY = mouseY
                    }

                    onPositionChanged: {
                        var delta = (lastY - mouseY) / 2 // Adjust divisor to change sensitivity
                        gainDial.value = Math.max(gainDial.from, Math.min(gainDial.to, gainDial.value + delta))
                        lastY = mouseY
                    }
                }
            }
            Text {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 4
                anchors.horizontalCenter: parent.horizontalCenter
                text: "GAIN"
                color: dimTextColor
                font.pixelSize: 10
                font.bold: true
            }

            Text {
                anchors.top: parent.top
                anchors.topMargin: 4
                anchors.horizontalCenter: parent.horizontalCenter
                text: Math.round(gainDial.value) + "dB"
                color: textColor
                font.pixelSize: 10
            }
        }

        // Trim Control
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 24
            color: controlColor
            radius: 2
            border.color: "#404040"
            border.width: 1

            Slider {
                id: trimSlider
                anchors.fill: parent
                anchors.margins: 4
                value: 0.5

                background: Rectangle {
                    color: "#1A1A1A"
                    radius: 2
                    border.color: "#505050"
                    border.width: 1

                    Rectangle {
                        width: trimSlider.visualPosition * parent.width
                        height: parent.height
                        color: "#404040"
                        radius: 2
                    }
                }

                handle: Rectangle {
                    x: trimSlider.leftPadding + trimSlider.visualPosition * (trimSlider.availableWidth - width)
                    y: trimSlider.topPadding + trimSlider.availableHeight / 2 - height / 2
                    width: 12
                    height: parent.height - 8
                    radius: 2
                    color: trimSlider.pressed ? accentColor : "#909090"
                    border.color: "#404040"
                    border.width: 1
                }
            }
        }

        // Pan Control
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 24
            color: controlColor
            radius: 2
            border.color: "#404040"
            border.width: 1

            Slider {
                id: panSlider
                anchors.fill: parent
                anchors.margins: 4
                from: -100
                to: 100
                value: 0

                background: Rectangle {
                    color: "#1A1A1A"
                    radius: 2
                    border.color: "#505050"
                    border.width: 1

                    Rectangle {
                        anchors.centerIn: parent
                        width: 1
                        height: parent.height
                        color: "#606060"
                    }
                }

                handle: Rectangle {
                    x: panSlider.leftPadding + panSlider.visualPosition * (panSlider.availableWidth - width)
                    y: panSlider.topPadding + panSlider.availableHeight / 2 - height / 2
                    width: 12
                    height: parent.height - 8
                    radius: 2
                    color: panSlider.pressed ? accentColor : "#909090"
                    border.color: "#404040"
                    border.width: 1
                }
            }
        }

        // Mute Button
        Button {
            Layout.fillWidth: true
            Layout.preferredHeight: 24
            text: "MUTE"
            checkable: true

            contentItem: Text {
                text: parent.text
                color: parent.checked ? "#FFFFFF" : dimTextColor
                font.pixelSize: 10
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                color: parent.checked ? "#FF4040" :
                       parent.hovered ? buttonHoverColor : controlColor
                radius: 2
                border.color: parent.checked ? "#FF4040" : "#404040"
                border.width: 1
            }
        }

        // Fader
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 150
            color: controlColor
            radius: 2
            border.color: "#404040"
            border.width: 1

            Rectangle {
                id: meterBackground
                width: 12
                height: parent.height - 20
                anchors.right: parent.right
                anchors.rightMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                color: "#1A1A1A"
                radius: 2
                border.color: "#404040"
                border.width: 1

                Rectangle {
                    width: parent.width - 2
                    height: parent.height * 0.7
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: meterGreen
                    radius: 1
                }
            }

            Slider {
                id: fader
                anchors.fill: parent
                anchors.margins: 4
                orientation: Qt.Vertical
                value: 0.75

                background: Rectangle {
                    x: parent.width / 2 - width / 2
                    y: parent.topPadding
                    width: 8
                    height: parent.availableHeight
                    color: "#1A1A1A"
                    radius: 2
                    border.color: "#505050"
                    border.width: 1

                    Rectangle {
                        width: parent.width
                        height: fader.visualPosition * parent.height
                        color: "#404040"
                        radius: 2
                    }
                }

                handle: Rectangle {
                    x: parent.leftPadding + parent.availableWidth / 2 - width / 2
                    y: parent.topPadding + parent.visualPosition * (parent.availableHeight - height)
                    width: 60
                    height: 20
                    radius: 2
                    color: fader.pressed ? accentColor : "#909090"
                    border.color: "#404040"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: {
                            var db = fader.value <= 0 ? -Infinity :
                                    20 * Math.log10(fader.value)
                            if (db <= -60) return "-∞"
                            return Math.round(db) + " dB"
                        }
                        color: "#000000"
                        font.pixelSize: 10
                        font.bold: true
                    }
                }
            }
        }
    }
}
