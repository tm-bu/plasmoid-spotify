import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property bool cfg_showLyricsDefault
    property bool cfg_highlightCurrentLineDefault
    property int cfg_lyricsFontSizeDefault
    property bool cfg_alternativeLineHeightCalculationDefault
    property string cfg_lyricsFontFamilyDefault

    property bool cfg_showAlbumCoverDefault
    property bool cfg_fetchAlbumCoverHttpsDefault
    property int cfg_maxTitleArtistLengthDefault
    property bool cfg_showTitleDefault
    property int cfg_titleFontSizeDefault
    property string cfg_titleFontFamilyDefault
    property bool cfg_showArtistDefault
    property int cfg_artistFontSizeDefault
    property string cfg_artistFontFamilyDefault

    property bool cfg_showPlaybackControlsDefault
    property string cfg_leftClickActionDefault
    property string cfg_middleClickActionDefault
    property string cfg_rightClickActionDefault
    property string cfg_wheelActionDefault
    property int cfg_volumeStepPercentDefault

    property alias cfg_showLyrics: showLyrics.checked
    property alias cfg_highlightCurrentLine: highlightCurrentLine.checked
    property alias cfg_lyricsFontSize: lyricsFontSize.value
    property alias cfg_alternativeLineHeightCalculation: alternativeLineHeightCalculation.checked
    property alias cfg_lyricsFontFamily: lyricsFontFamily.currentText

    property alias cfg_showAlbumCover: showAlbumCover.checked
    property alias cfg_fetchAlbumCoverHttps: fetchAlbumCoverHttps.checked
    property alias cfg_maxTitleArtistLength: maxTitleArtistLength.value
    property alias cfg_showTitle: showTitle.checked
    property alias cfg_titleFontSize: titleFontSize.value
    property alias cfg_titleFontFamily: titleFontFamily.currentText
    property alias cfg_showArtist: showArtist.checked
    property alias cfg_artistFontSize: artistFontSize.value
    property alias cfg_artistFontFamily: artistFontFamily.currentText

    property alias cfg_showPlaybackControls: showPlaybackControls.checked
    property alias cfg_leftClickAction: leftClickAction.currentValue
    property alias cfg_middleClickAction: middleClickAction.currentValue
    property alias cfg_rightClickAction: rightClickAction.currentValue
    property alias cfg_wheelAction: wheelAction.currentValue
    property alias cfg_volumeStepPercent: volumeStepPercent.value

    readonly property var clickActions: [
        {
            value: "raise",
            text: "Raise Spotify"
        },
        {
            value: "playPause",
            text: "Play/Pause"
        },
        {
            value: "next",
            text: "Next track"
        },
        {
            value: "previous",
            text: "Previous track"
        },
        {
            value: "none",
            text: "None"
        }
    ]

    readonly property var wheelActions: [
        {
            value: "volume",
            text: "Volume"
        },
        {
            value: "seek",
            text: "Track navigation"
        },
        {
            value: "none",
            text: "None"
        }
    ]

    function setComboIndexByValue(combo, expectedValue) {
        for (let i = 0; i < combo.model.length; i++) {
            if (combo.model[i].value === expectedValue) {
                combo.currentIndex = i
                return
            }
        }
    }

    ScrollView {
        anchors.fill: parent

        ColumnLayout {
            spacing: Kirigami.Units.smallSpacing
            width: parent.width

            Kirigami.Heading {
                text: "Lyrics"
                level: 3
                Layout.alignment: Qt.AlignLeft
            }

            CheckBox {
                id: showLyrics
                text: "Show lyrics"
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: Kirigami.Units.largeSpacing
            }

            CheckBox {
                id: highlightCurrentLine
                text: "Highlight current line"
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: 20
                enabled: showLyrics.checked
            }

            CheckBox {
                id: alternativeLineHeightCalculation
                text: "Use alternative scroll offset calculation (Works better with some fonts)"
                ToolTip.text: "Use an alternative method to calculate line height which may work better with some fonts."
                Layout.alignment: Qt.AlignLeft
                enabled: showLyrics.checked
                Layout.leftMargin: 20
            }

            RowLayout {
                Layout.alignment: Qt.AlignLeft
                spacing: Kirigami.Units.smallSpacing
                Layout.leftMargin: 20
                enabled: showLyrics.checked

                Label {
                    text: "Lyrics Font:"
                    Layout.alignment: Qt.AlignLeft
                }

                ComboBox {
                    id: lyricsFontFamily
                    model: Qt.fontFamilies()
                    editable: true
                    Layout.alignment: Qt.AlignLeft

                    Component.onCompleted: {
                        const index = model.indexOf(plasmoid.configuration.lyricsFontFamily)
                        currentIndex = index >= 0 ? index : 0
                    }
                }

                SpinBox {
                    id: lyricsFontSize
                    from: 8
                    to: 72
                    stepSize: 1
                    Layout.alignment: Qt.AlignLeft
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 20
                color: "transparent"
            }

            Kirigami.Heading {
                text: "Track Information"
                level: 3
                Layout.alignment: Qt.AlignLeft
                Layout.topMargin: Kirigami.Units.largeSpacing
            }

            CheckBox {
                id: showAlbumCover
                text: "Show album cover"
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: Kirigami.Units.largeSpacing
            }

            RowLayout {
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: Kirigami.Units.largeSpacing
                spacing: Kirigami.Units.smallSpacing

                CheckBox {
                    id: fetchAlbumCoverHttps
                    text: "Fetch album cover over HTTPS (Causes issues)"
                    ToolTip.text: "Use HTTPS to fetch album covers. This could cause issues with the current KDE Plasma version."
                    Layout.alignment: Qt.AlignLeft
                    enabled: showAlbumCover.checked
                    Layout.leftMargin: 20
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: Kirigami.Units.largeSpacing
                spacing: Kirigami.Units.smallSpacing

                Label {
                    text: "Max title/artist length:"
                    Layout.alignment: Qt.AlignLeft
                }

                SpinBox {
                    id: maxTitleArtistLength
                    from: 10
                    to: 200
                    stepSize: 1
                    Layout.alignment: Qt.AlignLeft
                    enabled: showAlbumCover.checked
                }
            }

            CheckBox {
                id: showTitle
                text: "Show title"
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: Kirigami.Units.largeSpacing
                checked: plasmoid.configuration.showTitle
                onCheckedChanged: plasmoid.configuration.showTitle = checked
            }

            RowLayout {
                Layout.alignment: Qt.AlignLeft
                spacing: Kirigami.Units.smallSpacing
                Layout.leftMargin: Kirigami.Units.largeSpacing

                Label {
                    text: "Title Font:"
                    Layout.alignment: Qt.AlignLeft
                }

                ComboBox {
                    id: titleFontFamily
                    model: Qt.fontFamilies()
                    editable: true
                    Layout.alignment: Qt.AlignLeft

                    Component.onCompleted: {
                        const index = model.indexOf(plasmoid.configuration.titleFontFamily)
                        currentIndex = index >= 0 ? index : 0
                    }
                }

                SpinBox {
                    id: titleFontSize
                    from: 8
                    to: 72
                    stepSize: 1
                    Layout.alignment: Qt.AlignLeft
                }
            }

            CheckBox {
                id: showArtist
                text: "Show artist"
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: Kirigami.Units.largeSpacing
                checked: plasmoid.configuration.showArtist
                onCheckedChanged: plasmoid.configuration.showArtist = checked
            }

            RowLayout {
                Layout.alignment: Qt.AlignLeft
                spacing: Kirigami.Units.smallSpacing
                Layout.leftMargin: Kirigami.Units.largeSpacing

                Label {
                    text: "Artist Font:"
                    Layout.alignment: Qt.AlignLeft
                }

                ComboBox {
                    id: artistFontFamily
                    model: Qt.fontFamilies()
                    editable: true
                    Layout.alignment: Qt.AlignLeft

                    Component.onCompleted: {
                        const index = model.indexOf(plasmoid.configuration.artistFontFamily)
                        currentIndex = index >= 0 ? index : 0
                    }
                }

                SpinBox {
                    id: artistFontSize
                    from: 8
                    to: 72
                    stepSize: 1
                    Layout.alignment: Qt.AlignLeft
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 20
                color: "transparent"
            }

            Kirigami.Heading {
                text: "Controls"
                level: 3
                Layout.alignment: Qt.AlignLeft
                Layout.topMargin: Kirigami.Units.largeSpacing
            }

            CheckBox {
                id: showPlaybackControls
                text: "Show playback controls on album cover hover"
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: Kirigami.Units.largeSpacing
            }

            RowLayout {
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: Kirigami.Units.largeSpacing
                spacing: Kirigami.Units.smallSpacing

                Label { text: "Left click:" }
                ComboBox {
                    id: leftClickAction
                    textRole: "text"
                    valueRole: "value"
                    model: clickActions
                    Component.onCompleted: setComboIndexByValue(leftClickAction, plasmoid.configuration.leftClickAction)
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: Kirigami.Units.largeSpacing
                spacing: Kirigami.Units.smallSpacing

                Label { text: "Middle click:" }
                ComboBox {
                    id: middleClickAction
                    textRole: "text"
                    valueRole: "value"
                    model: clickActions
                    Component.onCompleted: setComboIndexByValue(middleClickAction, plasmoid.configuration.middleClickAction)
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: Kirigami.Units.largeSpacing
                spacing: Kirigami.Units.smallSpacing

                Label { text: "Right click:" }
                ComboBox {
                    id: rightClickAction
                    textRole: "text"
                    valueRole: "value"
                    model: clickActions
                    Component.onCompleted: setComboIndexByValue(rightClickAction, plasmoid.configuration.rightClickAction)
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: Kirigami.Units.largeSpacing
                spacing: Kirigami.Units.smallSpacing

                Label { text: "Mouse wheel:" }
                ComboBox {
                    id: wheelAction
                    textRole: "text"
                    valueRole: "value"
                    model: wheelActions
                    Component.onCompleted: setComboIndexByValue(wheelAction, plasmoid.configuration.wheelAction)
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: Kirigami.Units.largeSpacing
                spacing: Kirigami.Units.smallSpacing
                enabled: wheelAction.currentValue === "volume"

                Label { text: "Volume step (%):" }
                SpinBox {
                    id: volumeStepPercent
                    from: 1
                    to: 10
                    stepSize: 1
                }
            }
        }
    }
}
