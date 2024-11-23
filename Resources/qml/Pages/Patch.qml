import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    width: 1200
    height: 800
    color: "black"

    // Generate 128 channels
    property var channels: {
        var arr = [];
        for(var i = 1; i <= 128; i++) {
            arr.push("CH " + i);
        }
        return arr;
    }

    // ScrollView for the entire matrix including headers
    ScrollView {
        id: mainScroll
        anchors.fill: parent
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOn
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn
        clip: true

        Rectangle {
            id: contentContainer
            width: leftLabelsWidth + (channels.length * cellSize)
            height: headerHeight + (channels.length * cellSize)
            color: "black"

            // Fixed position header for vertical channel numbers
            Row {
                id: headerRow
                x: leftLabelsWidth
                y: 0

                Repeater {
                    model: channels
                    Rectangle {
                        width: cellSize
                        height: headerHeight
                        color: "black"
                        border.color: "#333333"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            color: "white"
                            font.pixelSize: 10
                            font.family: "Arial"
                            rotation: -90
                        }
                    }
                }
            }

            // Fixed position header for horizontal channel numbers
            Column {
                id: sideHeader
                x: 0
                y: headerHeight

                Repeater {
                    model: channels
                    Rectangle {
                        width: leftLabelsWidth
                        height: cellSize
                        color: "black"
                        border.color: "#333333"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            color: "white"
                            font.pixelSize: 10
                            font.family: "Arial"
                        }
                    }
                }
            }

            // Main connection grid
            Grid {
                id: connectionGrid
                x: leftLabelsWidth
                y: headerHeight
                columns: channels.length
                spacing: 0

                property var connectionStates: []

                Component.onCompleted: {
                    // Initialize connection states array
                    for (var i = 0; i < channels.length; i++) {
                        connectionStates[i] = []
                        for (var j = 0; j < channels.length; j++) {
                            connectionStates[i][j] = false
                        }
                    }
                }

                Repeater {
                    model: channels.length * channels.length // 128x128 grid
                    Rectangle {
                        id: connectionPoint
                        width: cellSize
                        height: cellSize
                        color: checked ? "#0066FF" : "black"
                        border.color: "#333333"
                        border.width: 1

                        property bool checked: false
                        property int rowIndex: Math.floor(index / channels.length)
                        property int columnIndex: index % channels.length

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                parent.checked = !parent.checked
                                connectionStateChanged(parent.rowIndex, parent.columnIndex, parent.checked)
                            }
                        }
                    }
                }
            }
        }
    }

    // Properties
    property int cellSize: 25
    property int headerHeight: 60
    property int leftLabelsWidth: 80

    // Connection state handling
    function connectionStateChanged(row, column, state) {
        connectionGrid.connectionStates[row][column] = state
        console.log("Connection changed:",
                    channels[row], "→",
                    channels[column],
                    state ? "connected" : "disconnected")
    }

    // Control Panel
    Rectangle {
        id: controlPanel
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        width: 60
        color: "black"
        border.color: "#333333"
        border.width: 1
        z: 2 // Ensure it stays on top

        Column {
            anchors.centerIn: parent
            spacing: 10

            Button {
                width: 50
                height: 30
                text: "Clear"

                background: Rectangle {
                    color: parent.pressed ? "#0066FF" : "black"
                    border.color: "#333333"
                    border.width: 1
                }

                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 11
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    for (var i = 0; i < connectionGrid.children.length; i++) {
                        var point = connectionGrid.children[i]
                        if (point.checked) {
                            point.checked = false
                            connectionStateChanged(point.rowIndex,
                                                point.columnIndex,
                                                false)
                        }
                    }
                }
            }

            Button {
                width: 50
                height: 30
                text: "Save"

                background: Rectangle {
                    color: parent.pressed ? "#0066FF" : "black"
                    border.color: "#333333"
                    border.width: 1
                }

                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 11
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    var preset = []
                    for (var i = 0; i < channels.length; i++) {
                        preset[i] = connectionGrid.connectionStates[i].slice()
                    }
                    console.log("Saved preset")
                }
            }
        }
    }
}
