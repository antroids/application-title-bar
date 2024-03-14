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

    property string cfg_widgetButtonsAuroraeTheme
    property alias cfg_widgetButtonsUsePlasmaTheme: widgetButtonsUsePlasmaTheme.checked
    property alias cfg_widgetButtonsAspectRatio: widgetButtonsAspectRatio.value
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
    property alias cfg_windowTitleHideEmpty: windowTitleHideEmpty.checked
    property alias cfg_windowTitleUndefined: windowTitleUndefined.text
    property alias cfg_windowTitleMarginsLeft: windowTitleMarginsLeft.value
    property alias cfg_windowTitleMarginsTop: windowTitleMarginsTop.value
    property alias cfg_windowTitleMarginsBottom: windowTitleMarginsBottom.value
    property alias cfg_windowTitleMarginsRight: windowTitleMarginsRight.value
    property var cfg_widgetElements

    Kirigami.FormLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        wideMode: true

        KWinConfig {
            id: kWinConfig

            onAuroraeThemesChanged: widgetButtonsAuroraeTheme.updateCurrentIndex()
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Window Control Buttons")
        }

        CheckBox {
            id: widgetButtonsUsePlasmaTheme

            Kirigami.FormData.label: i18n("Use Plasma theme icons:")
        }

        ComboBox {
            id: widgetButtonsAuroraeTheme

            function updateCurrentIndex() {
                currentIndex = indexOfValue(cfg_widgetButtonsAuroraeTheme);
            }

            enabled: !widgetButtonsUsePlasmaTheme.checked
            Component.onCompleted: updateCurrentIndex()
            onActivated: cfg_widgetButtonsAuroraeTheme = currentValue
            textRole: "name"
            valueRole: "folder"
            Kirigami.FormData.label: i18n("Buttons theme:")
            model: kWinConfig.auroraeThemes
        }

        SpinBox {
            id: widgetButtonsAspectRatio

            Kirigami.FormData.label: i18n("Buttons aspect ratio %:")
            from: 0
            to: 200
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
            model: [{
                "value": Qt.AlignLeft,
                "text": i18n("Left")
            }, {
                "value": Qt.AlignHCenter,
                "text": i18n("Center")
            }, {
                "value": Qt.AlignRight,
                "text": i18n("Right")
            }, {
                "value": Qt.AlignJustify,
                "text": i18n("Justify")
            }]
        }

        ComboBox {
            id: widgetVerticalAlignment

            Component.onCompleted: currentIndex = indexOfValue(cfg_widgetVerticalAlignment)
            onActivated: cfg_widgetVerticalAlignment = currentValue
            textRole: "text"
            valueRole: "value"
            Kirigami.FormData.label: i18n("Vertical alignment:")
            model: [{
                "value": Qt.AlignLeft,
                "text": i18n("Top")
            }, {
                "value": Qt.AlignVCenter,
                "text": i18n("Center")
            }, {
                "value": Qt.AlignBottom,
                "text": i18n("Bottom")
            }, {
                "value": Qt.AlignBaseline,
                "text": i18n("Baseline")
            }]
        }

        ComboBox {
            id: widgetElementsDisabledMode

            textRole: "text"
            valueRole: "value"
            Kirigami.FormData.label: i18n("Show disabled elements:")
            model: [{
                "value": WidgetElement.DisabledMode.Deactivated,
                "text": i18n("Deactivated")
            }, {
                "value": WidgetElement.DisabledMode.HideKeepSpace,
                "text": i18n("Hide, keep space")
            }, {
                "value": WidgetElement.DisabledMode.Hide,
                "text": i18n("Hide")
            }]
        }

        CheckBox {
            id: widgetFillWidth

            Kirigami.FormData.label: i18n("Fill free space on Panel:")
        }

        WidgetElements {
            id: widgetElements

            Component.onCompleted: function() {
                model.ignoreInsertEvent = true;
                for (var i = 0; i < cfg_widgetElements.length; i++) {
                    model.append({
                        "value": cfg_widgetElements[i]
                    });
                }
                model.ignoreInsertEvent = false;
            }

            model: ListModel {
                property bool ignoreInsertEvent: false

                function updateConfigFromModel() {
                    cfg_widgetElements = [];
                    for (var i = 0; i < count; i++) {
                        cfg_widgetElements.push(get(i).value);
                    }
                }

                onRowsMoved: updateConfigFromModel()
                onRowsRemoved: updateConfigFromModel()
                onRowsInserted: ignoreInsertEvent || updateConfigFromModel()
            }

        }

        ComboBox {
            // ListElement {
            //     name: "Show on all desktops button"
            //     value: "windowAllDesktopsButton"
            // }
            // ListElement {
            //     name: "Window application menu button"
            //     value: "windowAppMenuButton"
            // }
            // ListElement {
            //     name: "Window help button"
            //     value: "windowHelpButton"
            // }
            // ListElement {
            //     name: "Window menu button"
            //     value: "windowMenuButton"
            // }

            Kirigami.FormData.label: i18n("Add element:")
            textRole: "name"
            valueRole: "value"
            displayText: currentText ? i18n(currentText) : ""
            onCurrentValueChanged: function() {
                if (currentValue) {
                    widgetElements.model.append({
                        "value": currentValue
                    });
                    currentIndex = 0;
                }
            }

            model: ListModel {
                ListElement {
                    name: "Select..."
                }

                ListElement {
                    name: "Window close button"
                    value: "windowCloseButton"
                }

                ListElement {
                    name: "Window minimize button"
                    value: "windowMinimizeButton"
                }

                ListElement {
                    name: "Window maximize button"
                    value: "windowMaximizeButton"
                }

                ListElement {
                    name: "Keep window above button"
                    value: "windowKeepAboveButton"
                }

                ListElement {
                    name: "Keep window below button"
                    value: "windowKeepBelowButton"
                }

                ListElement {
                    name: "Shade window button"
                    value: "windowShadeButton"
                }

                ListElement {
                    name: "Window title"
                    value: "windowTitle"
                }

                ListElement {
                    name: "Window Icon"
                    value: "windowIcon"
                }

                ListElement {
                    name: "Spacer"
                    value: "spacer"
                }

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
            model: [i18n("Application name"), i18n("Decoration"), i18n("Generic Application name")]
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

    }

}
