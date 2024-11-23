// Header.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import com.openmixer.system 1.0
Rectangle {
    id: header
    width: parent.width
    height: 40
    color: "#1E1E1E"

    // Properties
    property string regularFont: "Segoe UI"
    property string mediumFont: "Segoe UI Semibold"
    property string boldFont: "Segoe UI Bold"

    // Theme colors
    property color accentColor: "#00A6D6"
    property color textColor: "#E0E0E0"
    property color dimTextColor: "#808080"
    property color buttonHoverColor: "#2D2D2D"
    property color buttonPressedColor: "#171717"
    property color selectedColor: "#363636"

    SystemMonitor {
            id: systemMonitor
            Component.onCompleted: startMonitoring()
    }
    // Custom Icon component
    component IconImage: Image {
        property color iconColor: textColor

        source: parent.source
        sourceSize: Qt.size(width, height)
        width: 16
        height: 16
        antialiasing: true
        smooth: true
        fillMode: Image.PreserveAspectFit

        // For SVG images
        verticalAlignment: Image.AlignVCenter
        horizontalAlignment: Image.AlignHCenter

        // Color overlay
        onIconColorChanged: requestPaint()

        onStatusChanged: {
            if (status === Image.Error) {
                console.error("Failed to load image:", source)
            }
        }
    }


    // Menu Item Button Component
    component MenuItemButton: Button {
        Layout.fillWidth: true
        height: 32
        flat: true

        contentItem: RowLayout {
            spacing: 8
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 12

            Text {
                text: parent.parent.text
                font.family: regularFont
                color: parent.parent.hovered ? accentColor : textColor
                Layout.fillWidth: true
            }
        }

        background: Rectangle {
            color: parent.hovered ? selectedColor : "transparent"
        }

        onClicked: {
            menuPopup.close()
            // Add your action handling here based on the button text
            console.log(text + " clicked")
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        spacing: 4

        // Left Section
        RowLayout {
            Layout.preferredWidth: parent.width * 0.3
            spacing: 12

            // Menu Button
            Button {
                id: menuButton
                implicitWidth: 80
                implicitHeight: 28
                flat: true
                text: "Menu"

                contentItem: Text {
                    text: parent.text
                    font.family: regularFont
                    font.pixelSize: 13
                    color: parent.hovered ? accentColor : textColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    color: parent.pressed ? buttonPressedColor :
                           parent.hovered ? buttonHoverColor : "transparent"
                    radius: 4
                }

                onClicked: menuPopup.open()

                Popup {
                    id: menuPopup
                    y: parent.height
                    width: 200
                    padding: 1
                    z: 1000

                    background: Rectangle {
                        color: "#1E1E1E"
                        border.color: "#363636"
                        radius: 4
                    }

                    contentItem: ColumnLayout {
                        spacing: 0

                        // File Menu
                        Button {
                            Layout.fillWidth: true
                            height: 32
                            flat: true

                            contentItem: RowLayout {
                                spacing: 8
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12

                                Text {
                                    text: "File"
                                    font.family: regularFont
                                    color: parent.parent.hovered ? accentColor : textColor
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: ">"
                                    font.family: regularFont
                                    color: parent.parent.hovered ? accentColor : textColor
                                }
                            }

                            background: Rectangle {
                                color: parent.hovered ? selectedColor : "transparent"
                            }

                            onClicked: filePopup.open()

                            Popup {
                                id: filePopup
                                x: parent.width
                                y: 0
                                width: 200
                                padding: 1

                                background: Rectangle {
                                    color: "#1E1E1E"
                                    border.color: "#363636"
                                    radius: 4
                                }

                                contentItem: ColumnLayout {
                                    spacing: 0
                                    MenuItemButton { text: "New Project" }
                                    MenuItemButton { text: "Open Project..." }
                                    MenuItemButton { text: "Save Project" }
                                    MenuItemButton { text: "Save Project As..." }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        height: 1
                                        color: "#363636"
                                        Layout.topMargin: 4
                                        Layout.bottomMargin: 4
                                    }

                                    MenuItemButton { text: "Recent Projects >" }
                                }
                            }
                        }

                        // Scene Menu
                        Button {
                            Layout.fillWidth: true
                            height: 32
                            flat: true

                            contentItem: RowLayout {
                                spacing: 8
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12

                                Text {
                                    text: "Scene"
                                    font.family: regularFont
                                    color: parent.parent.hovered ? accentColor : textColor
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: ">"
                                    font.family: regularFont
                                    color: parent.parent.hovered ? accentColor : textColor
                                }
                            }

                            background: Rectangle {
                                color: parent.hovered ? selectedColor : "transparent"
                            }

                            onClicked: scenePopup.open()

                            Popup {
                                id: scenePopup
                                x: parent.width
                                y: 0
                                width: 200
                                padding: 1

                                background: Rectangle {
                                    color: "#1E1E1E"
                                    border.color: "#363636"
                                    radius: 4
                                }

                                contentItem: ColumnLayout {
                                    spacing: 0
                                    MenuItemButton { text: "New Scene" }
                                    MenuItemButton { text: "Open Scene..." }
                                    MenuItemButton { text: "Save Scene" }
                                    MenuItemButton { text: "Save Scene As..." }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        height: 1
                                        color: "#363636"
                                        Layout.topMargin: 4
                                        Layout.bottomMargin: 4
                                    }

                                    MenuItemButton { text: "Import Scene..." }
                                    MenuItemButton { text: "Export Scene..." }
                                }
                            }
                        }

                        // Tools Menu
                        Button {
                            Layout.fillWidth: true
                            height: 32
                            flat: true

                            contentItem: RowLayout {
                                spacing: 8
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12

                                Text {
                                    text: "Tools"
                                    font.family: regularFont
                                    color: parent.parent.hovered ? accentColor : textColor
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: ">"
                                    font.family: regularFont
                                    color: parent.parent.hovered ? accentColor : textColor
                                }
                            }

                            background: Rectangle {
                                color: parent.hovered ? selectedColor : "transparent"
                            }

                            onClicked: toolsPopup.open()

                            Popup {
                                id: toolsPopup
                                x: parent.width
                                y: 0
                                width: 200
                                padding: 1

                                background: Rectangle {
                                    color: "#1E1E1E"
                                    border.color: "#363636"
                                    radius: 4
                                }

                                contentItem: ColumnLayout {
                                    spacing: 0
                                    MenuItemButton { text: "Audio Settings..." }
                                    MenuItemButton { text: "MIDI Settings..." }
                                    MenuItemButton { text: "Plugin Manager..." }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        height: 1
                                        color: "#363636"
                                        Layout.topMargin: 4
                                        Layout.bottomMargin: 4
                                    }

                                    MenuItemButton { text: "Preferences..." }
                                }
                            }
                        }

                        // Utilities Menu
                        Button {
                            Layout.fillWidth: true
                            height: 32
                            flat: true

                            contentItem: RowLayout {
                                spacing: 8
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12

                                Text {
                                    text: "Utilities"
                                    font.family: regularFont
                                    color: parent.parent.hovered ? accentColor : textColor
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: ">"
                                    font.family: regularFont
                                    color: parent.parent.hovered ? accentColor : textColor
                                }
                            }

                            background: Rectangle {
                                color: parent.hovered ? selectedColor : "transparent"
                            }

                            onClicked: utilitiesPopup.open()

                            Popup {
                                id: utilitiesPopup
                                x: parent.width
                                y: 0
                                width: 200
                                padding: 1

                                background: Rectangle {
                                    color: "#1E1E1E"
                                    border.color: "#363636"
                                    radius: 4
                                }

                                contentItem: ColumnLayout {
                                    spacing: 0
                                    MenuItemButton { text: "Firmware Update" }
                                    MenuItemButton { text: "Software Update" }
                                    MenuItemButton { text: "Driver Diagnostic" }
                                    MenuItemButton { text: "System Info" }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        height: 1
                                        color: "#363636"
                                        Layout.topMargin: 4
                                        Layout.bottomMargin: 4
                                    }

                                    MenuItemButton { text: "Log Viewer" }
                                    MenuItemButton { text: "Debug Console" }
                                }
                            }
                        }

                        // Help Menu
                        Button {
                            Layout.fillWidth: true
                            height: 32
                            flat: true

                            contentItem: RowLayout {
                                spacing: 8
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.rightMargin: 12

                                Text {
                                    text: "Help"
                                    font.family: regularFont
                                    color: parent.parent.hovered ? accentColor : textColor
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: ">"
                                    font.family: regularFont
                                    color: parent.parent.hovered ? accentColor : textColor
                                }
                            }

                            background: Rectangle {
                                color: parent.hovered ? selectedColor : "transparent"
                            }

                            onClicked: helpPopup.open()

                            Popup {
                                id: helpPopup
                                x: parent.width
                                y: 0
                                width: 200
                                padding: 1

                                background: Rectangle {
                                    color: "#1E1E1E"
                                    border.color: "#363636"
                                    radius: 4
                                }

                                contentItem: ColumnLayout {
                                    spacing: 0
                                    MenuItemButton { text: "Documentation" }
                                    MenuItemButton { text: "Quick Start Guide" }
                                    MenuItemButton { text: "Video Tutorials" }

                                    Rectangle {
                                        Layout.fillWidth: true
                                        height: 1
                                        color: "#363636"
                                        Layout.topMargin: 4
                                        Layout.bottomMargin: 4
                                    }

                                    MenuItemButton { text: "Check for Updates" }
                                    MenuItemButton { text: "About" }
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: "#363636"
                            Layout.topMargin: 4
                            Layout.bottomMargin: 4
                        }

                        // Exit Menu Item
                        MenuItemButton {
                            text: "Exit"
                            onClicked: Qt.quit()
                        }
                    }
                }
            }


            // Channel Navigation
            RowLayout {
                spacing: 8

                Button {
                    id: prevChannel
                    implicitWidth: 28
                    implicitHeight: 28
                    flat: true

                    contentItem: IconImage {
                        source: "qrc:/icon/arrow-left.svg"
                        iconColor: parent.hovered ? accentColor : textColor
                    }

                    background: Rectangle {
                        color: parent.pressed ? buttonPressedColor :
                               parent.hovered ? buttonHoverColor : "transparent"
                        radius: 4
                    }
                }

                Label {
                    text: "Channel 1"
                    color: textColor
                    font.family: regularFont
                    font.pixelSize: 13
                }

                Button {
                    id: nextChannel
                    implicitWidth: 28
                    implicitHeight: 28
                    flat: true

                    contentItem: IconImage {
                        source: "qrc:/icon/arrow-right.svg"
                        iconColor: parent.hovered ? accentColor : textColor
                    }

                    background: Rectangle {
                        color: parent.pressed ? buttonPressedColor :
                               parent.hovered ? buttonHoverColor : "transparent"
                        radius: 4
                    }
                }
            }

            // Quick Access Buttons
            RowLayout {
                spacing: 8

                Repeater {
                    model: ListModel {
                        ListElement {
                            iconSource: "qrc:/icon/preset.svg"
                            text: "Presets"
                            tooltip: "Preset Manager"
                        }
                        ListElement {
                            iconSource: "qrc:/icon/solo.svg"
                            text: "Solo"
                            tooltip: "Clear Solo"
                        }
                        ListElement {
                            iconSource: "qrc:/icon/talk.svg"
                            text: "Talk"
                            tooltip: "Talkback"
                        }
                    }

                    Button {
                        implicitWidth: 100
                        implicitHeight: 28
                        flat: true
                        ToolTip.text: model.tooltip
                        ToolTip.visible: hovered

                        contentItem: RowLayout {
                            spacing: 4
                            IconImage {
                                source: model.iconSource
                                iconColor: parent.parent.hovered ? accentColor : textColor
                            }
                            Text {
                                text: model.text
                                font.family: regularFont
                                font.pixelSize: 13
                                color: parent.parent.hovered ? accentColor : textColor
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignLeft
                            }
                        }

                        background: Rectangle {
                            color: parent.pressed ? buttonPressedColor :
                                   parent.hovered ? buttonHoverColor : "transparent"
                            radius: 4
                        }
                    }
                }
            }
        }

        // In Header.qml
        RowLayout {
            Layout.preferredWidth: parent.width * 0.25
            Layout.alignment: Qt.AlignCenter
            spacing: 2

            property string currentPage: "Mix 1"  // Track current page

            ButtonGroup {
                id: navGroup
                exclusive: true
                buttons: navRow.children
            }

            Row {
                id: navRow
                spacing: 2

                Button {
                    id: mix1Button
                    text: "Mix 1"
                    implicitHeight: 32
                    implicitWidth: 75
                    flat: true
                    checkable: true
                    checked: true

                    background: Rectangle {
                        color: parent.checked ? selectedColor :
                               parent.pressed ? buttonPressedColor :
                               parent.hovered ? buttonHoverColor : "transparent"
                        radius: 4
                    }

                    contentItem: Text {
                        text: parent.text
                        font.family: parent.checked ? boldFont : regularFont
                        font.pixelSize: 13
                        color: parent.checked ? accentColor : textColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        if (header.navigateToPage) {
                            header.navigateToPage(text)
                        }
                    }
                }

                Button {
                    id: mix2Button
                    text: "Mix 2"
                    implicitHeight: 32
                    implicitWidth: 75
                    flat: true
                    checkable: true

                    background: Rectangle {
                        color: parent.checked ? selectedColor :
                               parent.pressed ? buttonPressedColor :
                               parent.hovered ? buttonHoverColor : "transparent"
                        radius: 4
                    }

                    contentItem: Text {
                        text: parent.text
                        font.family: parent.checked ? boldFont : regularFont
                        font.pixelSize: 13
                        color: parent.checked ? accentColor : textColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        if (header.navigateToPage) {
                            header.navigateToPage(text)
                        }
                    }
                }

                Button {
                    id: channelButton
                    text: "Channel"
                    implicitHeight: 32
                    implicitWidth: 75
                    flat: true
                    checkable: true
                    enabled: false  // Disabled until implemented

                    background: Rectangle {
                        color: parent.checked ? selectedColor :
                               parent.pressed ? buttonPressedColor :
                               parent.hovered ? buttonHoverColor : "transparent"
                        opacity: parent.enabled ? 1.0 : 0.5
                        radius: 4
                    }

                    contentItem: Text {
                        text: parent.text
                        font.family: parent.checked ? boldFont : regularFont
                        font.pixelSize: 13
                        color: parent.checked ? accentColor : textColor
                        opacity: parent.enabled ? 1.0 : 0.5
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Button {
                    id: showButton
                    text: "Show"
                    implicitHeight: 32
                    implicitWidth: 75
                    flat: true
                    checkable: true
                    enabled: false

                    background: Rectangle {
                        color: parent.checked ? selectedColor :
                               parent.pressed ? buttonPressedColor :
                               parent.hovered ? buttonHoverColor : "transparent"
                        opacity: parent.enabled ? 1.0 : 0.5
                        radius: 4
                    }

                    contentItem: Text {
                        text: parent.text
                        font.family: parent.checked ? boldFont : regularFont
                        font.pixelSize: 13
                        color: parent.checked ? accentColor : textColor
                        opacity: parent.enabled ? 1.0 : 0.5
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Button {
                    id: patchButton
                    text: "Patch"
                    implicitHeight: 32
                    implicitWidth: 75
                    flat: true
                    checkable: true
                    enabled: false

                    background: Rectangle {
                        color: parent.checked ? selectedColor :
                               parent.pressed ? buttonPressedColor :
                               parent.hovered ? buttonHoverColor : "transparent"
                        opacity: parent.enabled ? 1.0 : 0.5
                        radius: 4
                    }

                    contentItem: Text {
                        text: parent.text
                        font.family: parent.checked ? boldFont : regularFont
                        font.pixelSize: 13
                        color: parent.checked ? accentColor : textColor
                        opacity: parent.enabled ? 1.0 : 0.5
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Button {
                    id: setupButton
                    text: "Setup"
                    implicitHeight: 32
                    implicitWidth: 75
                    flat: true
                    checkable: true
                    enabled: false

                    background: Rectangle {
                        color: parent.checked ? selectedColor :
                               parent.pressed ? buttonPressedColor :
                               parent.hovered ? buttonHoverColor : "transparent"
                        opacity: parent.enabled ? 1.0 : 0.5
                        radius: 4
                    }

                    contentItem: Text {
                        text: parent.text
                        font.family: parent.checked ? boldFont : regularFont
                        font.pixelSize: 13
                        color: parent.checked ? accentColor : textColor
                        opacity: parent.enabled ? 1.0 : 0.5
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }

        // Right Section
        RowLayout {
            Layout.preferredWidth: parent.width * 0.3
            Layout.alignment: Qt.AlignRight
            spacing: 16

            // System Metrics
            // Modify the System Metrics section
            GridLayout {
                columns: 5
                columnSpacing: 20
                rowSpacing: 2

                // DSP Usage
                Column {
                    Layout.alignment: Qt.AlignHCenter
                    Label {
                        text: "DSP"
                        font.family: mediumFont
                        color: dimTextColor
                        font.pixelSize: 11
                    }
                    Label {
                        text: systemMonitor.dspUsage.toFixed(1) + "%"
                        font.family: regularFont
                        color: textColor
                        font.pixelSize: 13
                    }
                }

                // CPU Usage
                Column {
                    Layout.alignment: Qt.AlignHCenter
                    Label {
                        text: "CPU"
                        font.family: mediumFont
                        color: dimTextColor
                        font.pixelSize: 11
                    }
                    Label {
                        text: systemMonitor.cpuUsage.toFixed(1) + "%"
                        font.family: regularFont
                        color: textColor
                        font.pixelSize: 13
                    }
                }

                // RAM Usage
                Column {
                    Layout.alignment: Qt.AlignHCenter
                    Label {
                        text: "RAM"
                        font.family: mediumFont
                        color: dimTextColor
                        font.pixelSize: 11
                    }
                    Label {
                        text: systemMonitor.ramUsage.toFixed(1) + "%"
                        font.family: regularFont
                        color: textColor
                        font.pixelSize: 13
                    }
                }

                // Latency
                Column {
                    Layout.alignment: Qt.AlignHCenter
                    Label {
                        text: "LAT"
                        font.family: mediumFont
                        color: dimTextColor
                        font.pixelSize: 11
                    }
                    Label {
                        text: systemMonitor.latency
                        font.family: regularFont
                        color: textColor
                        font.pixelSize: 13
                    }
                }

                // Sample Rate
                Column {
                    Layout.alignment: Qt.AlignHCenter
                    Label {
                        text: "CLK"
                        font.family: mediumFont
                        color: dimTextColor
                        font.pixelSize: 11
                    }
                    Label {
                        text: systemMonitor.sampleRate
                        font.family: regularFont
                        color: textColor
                        font.pixelSize: 13
                    }
                }
            }

            // Power Button
            Button {
                implicitWidth: 32
                implicitHeight: 32
                flat: true
                contentItem: IconImage {
                    source: "qrc:/icon/power.svg"
                    iconColor: parent.hovered ? accentColor : textColor
                }
                background: Rectangle {
                    color: parent.pressed ? buttonPressedColor :
                           parent.hovered ? buttonHoverColor : "transparent"
                    radius: 4
                }
                onClicked: powerMenu.open()

                Popup {
                    id: powerMenu
                    x: -120
                    y: parent.height
                    width: 180
                    padding: 1
                    z: 1000
                    background: Rectangle {
                        color: "#1E1E1E"
                        border.color: "#363636"
                        radius: 4
                    }

                    contentItem: ColumnLayout {
                        spacing: 0
                        Repeater {
                            model: ListModel {
                                ListElement { text: "Shutdown"; action: "shutdown" }
                                ListElement { text: "Restart"; action: "restart" }
                                ListElement { text: "Switch to Desktop"; action: "switchDesktop" }
                            }

                            Button {
                                Layout.fillWidth: true
                                height: 32
                                flat: true

                                contentItem: RowLayout {
                                    spacing: 8
                                    anchors.fill: parent
                                    anchors.leftMargin: 12
                                    anchors.rightMargin: 12

                                    Text {
                                        text: model.text
                                        font.family: regularFont
                                        color: parent.parent.hovered ? accentColor : textColor
                                        Layout.fillWidth: true
                                    }
                                }

                                background: Rectangle {
                                    color: parent.hovered ? selectedColor : "transparent"
                                }

                                onClicked: {
                                    powerMenu.close()
                                    // Open confirmation dialog based on the action
                                    confirmationDialog.title = "Confirm " + model.text
                                    confirmationDialog.message = "Are you sure you want to " + model.text.toLowerCase() + "?"
                                    confirmationDialog.confirmed.connect(function() {
                                        if (model.action === "shutdown") {
                                            systemInterface.shutdown()
                                        } else if (model.action === "restart") {
                                            systemInterface.restart()
                                        } else if (model.action === "switchDesktop") {
                                            systemInterface.switchToDesktop()
                                        }
                                    })
                                    confirmationDialog.open()
                                }
                            }
                        }
                    }
                }
            }

            // Confirmation Dialog
            DialogPopup {
                id: confirmationDialog
                title: "Confirm Action"
                message: "Are you sure?"
            }

        }
    }
}
