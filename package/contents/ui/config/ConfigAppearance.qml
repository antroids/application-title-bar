/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import "../"
import "../config"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

KCM.SimpleKCM {
    id: page

    property alias cfg_widgetButtonsIconsTheme: widgetButtonsIconsTheme.currentIndex
    property string cfg_widgetButtonsAuroraeTheme
    property alias cfg_widgetButtonsMargins: widgetButtonsMargins.value
    property alias cfg_widgetButtonsAspectRatio: widgetButtonsAspectRatio.value
    property alias cfg_widgetButtonsAnimation: widgetButtonsAnimation.value
    property alias cfg_widgetElementsDisabledMode: widgetElementsDisabledMode.currentIndex
    property alias cfg_widgetMargins: widgetMargins.value
    property alias cfg_widgetSpacing: widgetSpacing.value
    property int cfg_widgetHorizontalAlignment
    property int cfg_widgetVerticalAlignment
    property alias cfg_widgetFillWidth: widgetFillWidth.checked
    property alias cfg_windowTitleMinimumWidth: windowTitleMinimumWidth.value
    property alias cfg_windowTitleMaximumWidth: windowTitleMaximumWidth.value
    property alias cfg_windowTitleFontSize: windowTitleFontSize.value
    property alias cfg_windowTitleFontBold: windowTitleFontBold.checked
    property alias cfg_windowTitleFontSizeMode: windowTitleFontSizeMode.currentIndex
    property alias cfg_windowTitleSource: windowTitleSource.currentIndex
    property alias cfg_windowTitleHorizontalAlignment: windowTitleHorizontalAlignment.currentIndex
    property alias cfg_windowTitleVerticalAlignment: windowTitleVerticalAlignment.currentIndex
    property alias cfg_windowTitleHideEmpty: windowTitleHideEmpty.checked
    property alias cfg_windowTitleUndefined: windowTitleUndefined.text
    property alias cfg_windowTitleMarginsLeft: windowTitleMarginsLeft.value
    property alias cfg_windowTitleMarginsTop: windowTitleMarginsTop.value
    property alias cfg_windowTitleMarginsBottom: windowTitleMarginsBottom.value
    property alias cfg_windowTitleMarginsRight: windowTitleMarginsRight.value
    property alias cfg_widgetElements: widgetElements.elements
    property alias cfg_overrideElementsMaximized: overrideElementsMaximized.checked
    property alias cfg_widgetElementsMaximized: widgetElementsMaximized.elements
    property alias cfg_windowTitleSourceMaximized: windowTitleSourceMaximized.currentIndex

    Kirigami.FormLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        wideMode: true

        KWinConfig {
            id: kWinConfig

            onAuroraeThemesChanged: widgetButtonsAuroraeTheme.updateCurrentIndex()
        }

        Kirigami.InlineMessage {
            anchors.left: parent.left
            anchors.right: parent.right
            text: kWinConfig.lastError
            type: Kirigami.MessageType.Error
            visible: kWinConfig.lastError !== ""
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Widget Layout")
        }

        SpinBox {
            id: widgetMargins

            Kirigami.FormData.label: i18n("Widget margins:")
            from: 0
            to: 32
        }

        SpinBox {
            id: widgetSpacing

            Kirigami.FormData.label: i18n("Spacing between elements:")
            from: 0
            to: 32
        }

        ComboBox {
            id: widgetHorizontalAlignment

            Component.onCompleted: currentIndex = indexOfValue(cfg_widgetHorizontalAlignment)
            onActivated: cfg_widgetHorizontalAlignment = currentValue
            textRole: "text"
            valueRole: "value"
            Kirigami.FormData.label: i18n("Horizontal alignment:")
            model: [
                {
                    "value": Qt.AlignLeft,
                    "text": i18n("Left")
                },
                {
                    "value": Qt.AlignHCenter,
                    "text": i18n("Center")
                },
                {
                    "value": Qt.AlignRight,
                    "text": i18n("Right")
                },
                {
                    "value": Qt.AlignJustify,
                    "text": i18n("Justify")
                }
            ]
        }

        ComboBox {
            id: widgetVerticalAlignment

            Component.onCompleted: currentIndex = indexOfValue(cfg_widgetVerticalAlignment)
            onActivated: cfg_widgetVerticalAlignment = currentValue
            textRole: "text"
            valueRole: "value"
            Kirigami.FormData.label: i18n("Vertical alignment:")
            model: [
                {
                    "value": Qt.AlignLeft,
                    "text": i18n("Top")
                },
                {
                    "value": Qt.AlignVCenter,
                    "text": i18n("Center")
                },
                {
                    "value": Qt.AlignBottom,
                    "text": i18n("Bottom")
                },
                {
                    "value": Qt.AlignBaseline,
                    "text": i18n("Baseline")
                }
            ]
        }

        ComboBox {
            id: widgetElementsDisabledMode

            textRole: "text"
            valueRole: "value"
            Kirigami.FormData.label: i18n("Show disabled elements:")
            model: [
                {
                    "value": WidgetElement.DisabledMode.Deactivated,
                    "text": i18n("Deactivated")
                },
                {
                    "value": WidgetElement.DisabledMode.HideKeepSpace,
                    "text": i18n("Hide, keep space")
                },
                {
                    "value": WidgetElement.DisabledMode.Hide,
                    "text": i18n("Hide")
                }
            ]
        }

        CheckBox {
            id: widgetFillWidth

            Kirigami.FormData.label: i18n("Fill free space on Panel:")
        }

        WidgetElements {
            id: widgetElements

            Kirigami.FormData.label: i18n("Elements:")
        }

        AddWidgetElement {
            onCurrentValueChanged: function () {
                if (currentValue) {
                    widgetElements.model.append({
                        "value": currentValue
                    });
                    currentIndex = 0;
                }
            }
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Window Control Buttons")
        }

        ComboBox {
            id: widgetButtonsIconsTheme

            Kirigami.FormData.label: i18n("Button icons source:")
            Layout.minimumWidth: Kirigami.Units.gridUnit * 15
            model: [i18n("Plasma: Global icon theme"), i18n("Breeze: Implicit Breeze icons"), i18n("Aurorae: Window decorations theme"), i18n("Oxygen: Implicit Oxygen icons")]
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Aurorae theme:")

            ComboBox {
                id: widgetButtonsAuroraeTheme

                function updateCurrentIndex() {
                    currentIndex = indexOfValue(cfg_widgetButtonsAuroraeTheme);
                }

                Layout.minimumWidth: Kirigami.Units.gridUnit * 15
                enabled: widgetButtonsIconsTheme.currentIndex == 2 && model.count > 0
                Component.onCompleted: updateCurrentIndex()
                onActivated: cfg_widgetButtonsAuroraeTheme = currentValue
                displayText: !!currentText ? currentText : (model.count > 0) ? i18n("<Select Aurorae theme>") : i18n("<Aurorae themes not found>")
                textRole: "name"
                valueRole: "folder"
                model: kWinConfig.auroraeThemes
            }

            KCM.ContextualHelpButton {
                visible: widgetButtonsAuroraeTheme.model.count == 0
                toolTipText: i18n("Some window decorations themes, e.g. Breeze or Plastik, could be installed in your system as binary libraries and thus be visible and usable in System settings, but they are not detectable and cannot be used by this widget. There are no plans to support such binary themes due to technical complications.
-
Regular Aurorae themes for window decorations are supported by this widget and you can install them in System settings through \"Window decorations\" page or use \"Breeze\" or \"Plasma\" options in \"Button icons source\" field above instead")
            }

            KCM.ContextualHelpButton {
                visible: widgetButtonsAuroraeTheme.model.count > 0
                toolTipText: i18n("Some window decorations themes, e.g. Breeze or Plastik, could be installed in your system as binary libraries and thus be visible and usable in System settings, but they are not detectable and cannot be used by this widget. There are no plans to support such binary themes due to technical complications.
-
You can install more of regular Aurorae themes for window decorations in System settings through \"Window decorations\" page or use \"Breeze\" or \"Plasma\" options in \"Button icons source\" field above instead")
            }
        }
        Label {
            text: i18n("<p>Missing your theme? <a href=\"https://github.com/antroids/application-title-bar/issues/25\">Report here.</a></p>")
            onLinkActivated: function (link) {
                Qt.openUrlExternally(link);
            }
        }

        SpinBox {
            id: widgetButtonsMargins

            Kirigami.FormData.label: i18n("Buttons margins:")
            from: 0
            to: 32
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Buttons width/height ratio:")

            SpinBox {
                id: widgetButtonsAspectRatio

                from: 0
                to: 200
            }

            KCM.ContextualHelpButton {
                toolTipText: i18n("The ratio of button width in percent to 100% of its height. If you need wider buttons, the value should be >100, otherwise less.")
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Animation speed in ms:")

            SpinBox {
                id: widgetButtonsAnimation

                from: 0
                to: 10000
            }

            KCM.ContextualHelpButton {
                toolTipText: i18n("Animation speed of buttons transitions in milliseconds.")
            }
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Window Title")
        }

        SpinBox {
            id: windowTitleMinimumWidth

            to: 4096
            Kirigami.FormData.label: i18n("Minimum width:")
        }

        SpinBox {
            id: windowTitleMaximumWidth

            from: -1
            to: 4096
            Kirigami.FormData.label: i18n("Maximum width:")
        }

        SpinBox {
            id: windowTitleFontSize

            Kirigami.FormData.label: i18n("Font size:")
            from: 1
            to: 64
        }

        ComboBox {
            id: windowTitleFontSizeMode

            Kirigami.FormData.label: i18n("Font fit:")
            model: [i18n("Fixed size"), i18n("Horizontal fit"), i18n("Vertical fit"), i18n("Fit")]
        }

        CheckBox {
            id: windowTitleFontBold

            Kirigami.FormData.label: i18n("Font bold:")
        }

        CheckBox {
            id: windowTitleHideEmpty

            Kirigami.FormData.label: i18n("Hide empty title:")
        }

        TextField {
            id: windowTitleUndefined

            Kirigami.FormData.label: i18n("Window title undefined:")
            Layout.alignment: Qt.AlignLeft
        }

        ComboBox {
            id: windowTitleSource

            Kirigami.FormData.label: i18n("Window title source:")
            model: [i18n("Application name"), i18n("Decoration"), i18n("Generic Application name"), i18n("Always undefined")]
        }

        ComboBox {
            id: windowTitleHorizontalAlignment

            Kirigami.FormData.label: i18n("Horizontal alignment:")
            model: [i18n("Left"), i18n("Right"), i18n("Center"), i18n("Justify")]
        }

        ComboBox {
            id: windowTitleVerticalAlignment

            Kirigami.FormData.label: i18n("Vertical alignment:")
            model: [i18n("Top"), i18n("Bottom"), i18n("Center")]
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Window title margins:")

            Label {
                text: i18n("top:")
            }

            SpinBox {
                id: windowTitleMarginsTop

                from: 0
                to: 64
            }

            Label {
                text: i18n("left:")
            }

            SpinBox {
                id: windowTitleMarginsLeft

                from: 0
                to: 64
            }

            Label {
                text: i18n("bottom:")
            }

            SpinBox {
                id: windowTitleMarginsBottom

                from: 0
                to: 64
            }

            Label {
                text: i18n("right:")
            }

            SpinBox {
                id: windowTitleMarginsRight

                from: 0
                to: 64
            }
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Override for maximized windows")
        }

        CheckBox {
            id: overrideElementsMaximized

            text: i18n("override")
        }

        WidgetElements {
            id: widgetElementsMaximized

            Kirigami.FormData.label: i18n("Elements:")
            enabled: overrideElementsMaximized.checked
        }

        AddWidgetElement {
            enabled: overrideElementsMaximized.checked

            onCurrentValueChanged: function () {
                if (currentValue) {
                    widgetElementsMaximized.model.append({
                        "value": currentValue
                    });
                    currentIndex = 0;
                }
            }
        }

        ComboBox {
            id: windowTitleSourceMaximized

            enabled: overrideElementsMaximized.checked
            Kirigami.FormData.label: i18n("Window title source:")
            model: [i18n("Application name"), i18n("Decoration"), i18n("Generic Application name"), i18n("Always undefined")]
        }
    }
}
