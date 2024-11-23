// Components/TrackView.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: trackViewRoot
    color: "#1A1A1A"

    // Properties for customization
    property int trackCount: 128
    property int tracksPerLayer: 16
    property int currentLayer: 0
    property color accentColor: "#FFA000"
    property color backgroundColor: "#1A1A1A"
    property color controlColor: "#252525"
    property color textColor: "#DEDEDE"
    property color dimTextColor: "#808080"

    RowLayout {
        anchors.fill: parent
        spacing: 2

        // Left Panel - Function Controls
        // Left Panel - Function Controls
        Rectangle {
            Layout.preferredWidth: 180
            Layout.fillHeight: true
            color: controlColor

            Column {
                anchors.fill: parent
                anchors.margins: 4
                spacing: 4

                // Global Controls
                Rectangle {
                    width: parent.width
                    height: 120
                    color: "transparent"
                    border.color: dimTextColor
                    border.width: 1
                    radius: 4

                    Column {
                        anchors.fill: parent
                        anchors.margins: 4
                        spacing: 4

                        // Title
                        Text {
                            text: "Global Controls"
                            color: textColor
                            font.pixelSize: 11
                            font.bold: true
                        }

                        // Clear Buttons
                        Row {
                            width: parent.width
                            height: 24
                            spacing: 4

                            Button {
                                width: (parent.width - 4) / 2
                                height: parent.height
                                text: "Clear Mute"

                                contentItem: Text {
                                    text: parent.text
                                    color: textColor
                                    font.pixelSize: 10
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }

                                background: Rectangle {
                                    color: parent.pressed ? "#402020" : controlColor
                                    border.color: "#FF4040"
                                    radius: 2
                                }
                            }

                            Button {
                                width: (parent.width - 4) / 2
                                height: parent.height
                                text: "Clear Solo"

                                contentItem: Text {
                                    text: parent.text
                                    color: textColor
                                    font.pixelSize: 10
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }

                                background: Rectangle {
                                    color: parent.pressed ? "#403020" : controlColor
                                    border.color: accentColor
                                    radius: 2
                                }
                            }
                        }

                        // View Mode Selection
                        ComboBox {
                            width: parent.width
                            height: 24
                            model: ["All Channels", "Input Only", "Mix Buses", "FX Returns"]

                            contentItem: Text {
                                text: parent.displayText
                                color: textColor
                                font.pixelSize: 10
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 8
                            }

                            background: Rectangle {
                                color: controlColor
                                border.color: dimTextColor
                                radius: 2
                            }
                        }

                        // Auto Sync Toggle
                        CheckBox {
                            width: parent.width
                            height: 24
                            text: "Auto Sync"
                            checked: true

                            contentItem: Text {
                                text: parent.text
                                color: textColor
                                font.pixelSize: 10
                                leftPadding: parent.indicator.width + 4
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                }

                // DCA Section
                Rectangle {
                    width: parent.width
                    height: 140
                    color: "transparent"
                    border.color: dimTextColor
                    border.width: 1
                    radius: 4

                    Column {
                        anchors.fill: parent
                        anchors.margins: 4
                        spacing: 4

                        // Title
                        Text {
                            text: "DCA"
                            color: textColor
                            font.pixelSize: 11
                            font.bold: true
                        }

                        // DCA Grid
                        Grid {
                            width: parent.width
                            columns: 2
                            spacing: 4

                            Repeater {
                                model: ["1", "2", "3", "4", "5", "6", "7", "8"]

                                Button {
                                    width: (parent.width - 4) / 2
                                    height: 24
                                    text: modelData

                                    contentItem: Text {
                                        text: parent.text
                                        color: textColor
                                        font.pixelSize: 10
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }

                                    background: Rectangle {
                                        color: parent.pressed ? "#303030" : controlColor
                                        border.color: dimTextColor
                                        radius: 2
                                    }
                                }
                            }
                        }
                    }
                }

                // Utility Section
                Rectangle {
                    width: parent.width
                    height: 120
                    color: "transparent"
                    border.color: dimTextColor
                    border.width: 1
                    radius: 4

                    Column {
                        anchors.fill: parent
                        anchors.margins: 4
                        spacing: 4

                        // Title
                        Text {
                            text: "Utilities"
                            color: textColor
                            font.pixelSize: 11
                            font.bold: true
                        }

                        // Utility Buttons
                        Column {
                            width: parent.width
                            spacing: 4

                            Repeater {
                                model: ["Copy Channel", "Paste Channel", "Reset Channel"]

                                Button {
                                    width: parent.width
                                    height: 24
                                    text: modelData

                                    contentItem: Text {
                                        text: parent.text
                                        color: textColor
                                        font.pixelSize: 10
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }

                                    background: Rectangle {
                                        color: parent.pressed ? "#303030" : controlColor
                                        border.color: dimTextColor
                                        radius: 2
                                    }
                                }
                            }
                        }
                    }
                }

                // Spacer
                Item {
                    width: parent.width
                    height: parent.height - 400 // Adjust this value based on the total height of other components
                }
            }
        }

        // Center Panel - Track Area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: backgroundColor

            Row {
                anchors.fill: parent
                spacing: 0

                Repeater {
                    model: tracksPerLayer
                    TrackItems {
                        channelNumber: index + 1 + (currentLayer * tracksPerLayer)
                        height: parent.height
                    }
                }
            }
        }

        // Right Panel - Layer Selection
        Rectangle {
            Layout.preferredWidth: 80
            Layout.fillHeight: true
            color: controlColor

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 2
                spacing: 1

                Label {
                    text: "LAYERS"
                    color: textColor
                    font.bold: true
                    font.pixelSize: 11
                    Layout.alignment: Qt.AlignHCenter
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 1
                    model: Math.ceil(trackCount / tracksPerLayer)

                    delegate: Button {
                        required property int index
                        width: parent ? parent.width : 0
                        height: 30
                        text: ((index * tracksPerLayer) + 1) + "-" +
                              Math.min((index + 1) * tracksPerLayer, trackCount)
                        checkable: true
                        checked: index === currentLayer

                        contentItem: Text {
                            text: parent.text
                            color: parent.checked ? accentColor : textColor
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.bold: parent.checked
                            font.pixelSize: 10
                        }

                        background: Rectangle {
                            color: parent.checked ? "#303030" :
                                   parent.hovered ? "#252525" : controlColor
                            border.color: parent.checked ? accentColor : dimTextColor
                            border.width: parent.checked ? 2 : 1
                            radius: 2
                        }

                        onClicked: currentLayer = index
                    }
                }
            }
        }
    }
}
