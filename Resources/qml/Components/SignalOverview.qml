import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: headerArea
    width: parent.width
    height: 64
    color: "#252525"

    // Constants for consistent spacing
    readonly property int groupSpacing: 2
    readonly property int channelSpacing: 1
    readonly property int numberOfGroups: 8
    readonly property int channelsPerGroup: 16
    property string regularFont
    property string mediumFont
    property string boldFont

    Column {
        anchors.fill: parent
        spacing: 2

        // Header row
        Row {
            width: parent.width
            height: 20
            spacing: groupSpacing

            Repeater {
                model: numberOfGroups
                Rectangle {
                    width: (parent.width - (groupSpacing * (numberOfGroups - 1))) / numberOfGroups
                    height: parent.height
                    color: "#2d2d2d"

                    Text {
                        anchors.centerIn: parent
                        text: (index * channelsPerGroup + 1) + "-" + (index * channelsPerGroup + channelsPerGroup)
                        color: "#808080"
                        font.pixelSize: 10
                        font.family: "Inter Display"
                    }
                }
            }
        }

        // VU meters row
        Row {
            width: parent.width
            height: parent.height - 24
            spacing: groupSpacing

            Repeater {
                model: numberOfGroups

                // Group container
                Rectangle {
                    width: (parent.width - (groupSpacing * (numberOfGroups - 1))) / numberOfGroups
                    height: parent.height
                    color: "#252525"

                    // Channels within group
                    Row {
                        anchors.fill: parent
                        spacing: channelSpacing

                        Repeater {
                            model: channelsPerGroup

                            Rectangle {
                                width: (parent.width - (channelSpacing * (channelsPerGroup - 1))) / channelsPerGroup
                                height: parent.height
                                color: "#1a1a1a"

                                Column {
                                    anchors.fill: parent
                                    spacing: 1

                                    // VU Meter
                                    Rectangle {
                                        width: parent.width
                                        height: parent.height
                                        color: "#0a0a0a"

                                        Rectangle {
                                            id: vuMeter
                                            width: parent.width - 2
                                            height: parent.height * Math.random()
                                            anchors.bottom: parent.bottom
                                            anchors.horizontalCenter: parent.horizontalCenter

                                            gradient: Gradient {
                                                GradientStop { position: 0.0; color: "#ff0000" }
                                                GradientStop { position: 0.1; color: "#ffff00" }
                                                GradientStop { position: 0.3; color: "#00ff00" }
                                            }
                                        }

                                        Column {
                                            anchors.fill: parent
                                            spacing: parent.height / 8
                                            Repeater {
                                                model: 1
                                                Rectangle {
                                                    width: parent.width
                                                    height: 1
                                                    color: "#333333"
                                                }
                                            }
                                        }
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true

                                    ToolTip.visible: containsMouse
                                    ToolTip.text: "Channel " + (index + 1 + (modelData * channelsPerGroup))

                                    onEntered: parent.color = "#252525"
                                    onExited: parent.color = "#1a1a1a"
                                }
                            }
                        }
                    }

                    Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        border.color: "#353535"
                        border.width: 1
                    }
                }
            }
        }
    }
}
