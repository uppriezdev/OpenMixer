// OpenMixer/Resources/qml/Pages/MixerView.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../Components"

Item {
    id: mixerView

    // Properties
    property color accentColor
    property color backgroundColor
    property color controlColor
    property color textColor
    property color dimTextColor

    TrackView {
        id: trackView
        anchors.fill: parent
        trackCount: 128
        tracksPerLayer: 16

        accentColor: mixerView.accentColor
        backgroundColor: mixerView.backgroundColor
        controlColor: mixerView.controlColor
        textColor: mixerView.textColor
        dimTextColor: mixerView.dimTextColor
    }
}
