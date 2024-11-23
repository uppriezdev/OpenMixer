// EffectTrackItem.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: effectSlot
    implicitWidth: 128  // Default width if not constrained
    implicitHeight: contentColumn.implicitHeight 
    Layout.fillHeight: true  // Fill available height
    Layout.minimumWidth: 80  // Minimum width
    Layout.maximumWidth: 128 // Maximum width
    color: backgroundColor

    // Properties
    property int minimumWidth: 80
    property int maximumWidth: 128
    property color accentColor: "#FFA000"
    property color textColor: "#DEDEDE"
    property color dimTextColor: "#808080"
    property color backgroundColor: "#1A1A1A"
    property color controlColor: "#252525"
    property color buttonHoverColor: "#303030"
    property int channelNumber: 1

    // Layout behavior
    Behavior on width {
        NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 2
        spacing: 2

        // Header with FX number and On/Off
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
                    text: "FX " + channelNumber
                    color: textColor
                    font.pixelSize: 12
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                }

                Button {
                    Layout.preferredWidth: 45
                    Layout.preferredHeight: 22
                    text: "ON"
                    checkable: true
                    checked: true

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

        // 10 Effect Slots
        Repeater {
            model: 10

            ComboBox {
                Layout.fillWidth: true
                Layout.preferredHeight: 24
                model: ["No Effect", "Reverb", "Delay", "Chorus", "Flanger", "Phaser", "EQ", "Comp"]
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
                        model: parent.parent.popup.visible ? parent.parent.delegateModel : null
                        clip: true
                    }
                }
            }
        }

        // 4 Send Controls
        Repeater {
            model: 4

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 24
                color: controlColor
                radius: 2

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 2
                    spacing: 2

                    Label {
                        text: "S" + (index + 1)
                        color: dimTextColor
                        font.pixelSize: 10
                    }

                    Slider {
                        Layout.fillWidth: true
                        value: 0.0

                        background: Rectangle {
                            color: "#1A1A1A"
                            radius: 2
                            border.color: "#505050"
                            border.width: 1
                        }

                        handle: Rectangle {
                            x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                            y: parent.topPadding + parent.availableHeight / 2 - height / 2
                            width: 12
                            height: parent.height - 8
                            radius: 2
                            color: parent.pressed ? accentColor : "#909090"
                            border.color: "#404040"
                            border.width: 1
                        }
                    }
                }
            }
        }

        // Output Selection
        ComboBox {
            Layout.fillWidth: true
            Layout.preferredHeight: 24
            model: ["Main L/R", "Bus 1-2", "Bus 3-4", "Bus 5-6"]
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
        }

        // Fader Section
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
                    color: "#00FF00"
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
