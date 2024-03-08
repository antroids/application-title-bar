/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import "../config"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

KCM.SimpleKCM {
    id: page

    property alias cfg_widgetMargins: widgetMargins.value
    property alias cfg_widgetSpacing: widgetSpacing.value
    property int cfg_windgetHorizontalAlignment: 1
    property int cfg_windgetVerticalAlignment: 128
    property alias cfg_windowTitleMinimumWidth: windowTitleMinimumWidth.value
    property alias cfg_windowTitleMaximumWidth: windowTitleMaximumWidth.value
    property alias cfg_windowTitleFontSize: windowTitleFontSize.value
    property alias cfg_windowTitleFontBold: windowTitleFontBold.checked
    property alias cfg_windowTitleFontSizeMode: windowTitleFontSizeMode.currentIndex
    property alias cfg_windowTitleSource: windowTitleSource.currentIndex
    property alias cfg_windowTitleUndefined: windowTitleUndefined.text
    property alias cfg_windowTitleMarginsLeft: windowTitleMarginsLeft.value
    property alias cfg_windowTitleMarginsTop: windowTitleMarginsTop.value
    property alias cfg_windowTitleMarginsBottom: windowTitleMarginsBottom.value
    property alias cfg_windowTitleMarginsRight: windowTitleMarginsRight.value
    property var cfg_widgetElements: ["windowCloseButton", "windowMinimizeButton", "windowMaximizeButton", "windowTitle", "windowIcon"]
    property int cfg_widgetMarginsDefault: 0
    property int cfg_windowTitleWidthDefault: 200
    property int cfg_windowTitleFontSizeDefault: 10
    property bool cfg_windowTitleFontBoldDefault: false
    property int cfg_windowTitleFontSizeModeDefault: 0
    property int cfg_windowTitleSourceDefault: 0
    property string cfg_windowTitleUndefinedDefault: i18n("<Unknown>")
    property int cfg_windowTitleMarginsLeftDefault: 0
    property int cfg_windowTitleMarginsTopDefault: 0
    property int cfg_windowTitleMarginsBottomDefault: 0
    property int cfg_windowTitleMarginsRightDefault: 0

    Kirigami.FormLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        wideMode: true

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Widget")
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
            id: windgetHorizontalAlignment

            Component.onCompleted: currentIndex = indexOfValue(cfg_windgetHorizontalAlignment)
            onActivated: cfg_windgetHorizontalAlignment = currentValue
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
            id: windgetVerticalAlignment

            Component.onCompleted: currentIndex = indexOfValue(cfg_windgetVerticalAlignment)
            onActivated: cfg_windgetVerticalAlignment = currentValue
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
            Kirigami.FormData.label: i18n("Add element:")
            textRole: "name"
            valueRole: "value"
            displayText: i18n(currentText)
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
                    name: "Window title"
                    value: "windowTitle"
                }

                ListElement {
                    name: "Window Icon"
                    value: "windowIcon"
                }

            }

        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Window title")
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
