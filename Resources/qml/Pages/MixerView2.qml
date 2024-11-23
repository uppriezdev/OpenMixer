// MixerView2.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Components"

Item {
    id: mixerView2

    // Properties
    property color accentColor
    property color backgroundColor
    property color controlColor
    property color textColor
    property color dimTextColor

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Left Tool Panel
        Rectangle {
            Layout.preferredWidth: 250
            Layout.fillHeight: true
            color: backgroundColor
            border.color: "#404040"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 4
                spacing: 4

                // Effect Browser Section
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    color: controlColor
                    radius: 2

                    Label {
                        anchors.centerIn: parent
                        text: "Effect Browser"
                        color: textColor
                        font.pixelSize: 12
                        font.bold: true
                    }
                }

                // Effect Categories
                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: ["Dynamics", "EQ", "Filters", "Modulation", "Delay", "Reverb", "Distortion", "Utility"]

                    delegate: ItemDelegate {
                        width: parent.width
                        height: 30

                        contentItem: Text {
                            text: modelData
                            color: textColor
                            font.pixelSize: 11
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: 8
                        }

                        background: Rectangle {
                            color: parent.hovered ? Qt.darker(controlColor, 1.2) : controlColor
                            radius: 2
                        }
                    }
                }
            }
        }

        // Center Track Area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: backgroundColor

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                // Track Header
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    color: controlColor

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 4
                        spacing: 8

                        Label {
                            text: "FX Channels"
                            color: textColor
                            font.pixelSize: 12
                            font.bold: true
                        }

                        Item { Layout.fillWidth: true }

                        Button {
                            text: "Add FX"
                            implicitWidth: 80
                            implicitHeight: 28

                            contentItem: Text {
                                text: parent.text
                                color: parent.hovered ? accentColor : textColor
                                font.pixelSize: 11
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            background: Rectangle {
                                color: parent.hovered ? Qt.darker(controlColor, 1.2) : controlColor
                                radius: 4
                                border.color: "#404040"
                                border.width: 1
                            }
                        }
                    }
                }

                // Tracks ScrollView
                ScrollView {
                    id: trackScrollView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    ScrollBar.horizontal.policy: ScrollBar.AsNeeded
                    ScrollBar.vertical.policy: ScrollBar.AsNeeded

                    Item {
                        width: Math.max(trackScrollView.width, trackRow.width)
                        height: Math.max(trackScrollView.height, trackRow.height)

                        RowLayout {
                            id: trackRow
                            anchors.left: parent.left
                            anchors.top: parent.top
                            spacing: 2
                            height: parent.height

                            Repeater {
                                model: 12 // Number of FX channels

                                EffectTrackItem {
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: 100
                                    Layout.minimumWidth: 80
                                    Layout.maximumWidth: 128
                                    channelNumber: index + 1

                                    accentColor: mixerView2.accentColor
                                    backgroundColor: mixerView2.backgroundColor
                                    controlColor: mixerView2.controlColor
                                    textColor: mixerView2.textColor
                                    dimTextColor: mixerView2.dimTextColor
                                }
                            }

                            // Spacer
                            Item {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                            }
                        }
                    }
                }
            }
        }

        // Right Tool Panel
        Rectangle {
            Layout.preferredWidth: 300
            Layout.fillHeight: true
            color: backgroundColor
            border.color: "#404040"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 4
                spacing: 4

                // Effect Parameters Section
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    color: controlColor
                    radius: 2

                    Label {
                        anchors.centerIn: parent
                        text: "Effect Parameters"
                        color: textColor
                        font.pixelSize: 12
                        font.bold: true
                    }
                }

                // Parameters Area (placeholder)
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: controlColor
                    radius: 2

                    Label {
                        anchors.centerIn: parent
                        text: "Select an effect to edit parameters"
                        color: dimTextColor
                        font.pixelSize: 11
                    }
                }

                // Presets Section
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
                    color: controlColor
                    radius: 2

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 4
                        spacing: 4

                        Label {
                            text: "Presets"
                            color: textColor
                            font.pixelSize: 12
                            font.bold: true
                        }

                        ComboBox {
                            Layout.fillWidth: true
                            model: ["Default", "Preset 1", "Preset 2", "Preset 3"]
                            currentIndex: 0

                            background: Rectangle {
                                color: parent.hovered ? Qt.darker(controlColor, 1.2) : controlColor
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

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 4

                            Button {
                                Layout.fillWidth: true
                                text: "Save"
                                implicitHeight: 24

                                contentItem: Text {
                                    text: parent.text
                                    color: parent.hovered ? accentColor : textColor
                                    font.pixelSize: 11
                                    horizontalAlignment: Text.AlignHCenter
                                }

                                background: Rectangle {
                                    color: parent.hovered ? Qt.darker(controlColor, 1.2) : controlColor
                                    radius: 2
                                    border.color: "#404040"
                                    border.width: 1
                                }
                            }

                            Button {
                                Layout.fillWidth: true
                                text: "Delete"
                                implicitHeight: 24

                                contentItem: Text {
                                    text: parent.text
                                    color: parent.hovered ? "#FF4040" : textColor
                                    font.pixelSize: 11
                                    horizontalAlignment: Text.AlignHCenter
                                }

                                background: Rectangle {
                                    color: parent.hovered ? Qt.darker(controlColor, 1.2) : controlColor
                                    radius: 2
                                    border.color: "#404040"
                                    border.width: 1
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
