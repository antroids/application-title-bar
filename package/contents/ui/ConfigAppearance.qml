/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

KCM.SimpleKCM {
    id: page

    property alias cfg_widgetMargins: widgetMargins.value
    property alias cfg_windowTitleWidth: windowTitleWidth.value
    property alias cfg_windowTitleFontSize: windowTitleFontSize.value
    property alias cfg_windowTitleFontBold: windowTitleFontBold.checked
    property alias cfg_windowTitleFontSizeMode: windowTitleFontSizeMode.currentIndex
    property alias cfg_windowTitleSource: windowTitleSource.currentIndex
    property alias cfg_windowTitleUndefined: windowTitleUndefined.text
    property alias cfg_windowTitleMarginsLeft: windowTitleMargins.leftValue
    property alias cfg_windowTitleMarginsTop: windowTitleMargins.topValue
    property alias cfg_windowTitleMarginsBottom: windowTitleMargins.bottomValue
    property alias cfg_windowTitleMarginsRight: windowTitleMargins.rightValue
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

        FormSlider {
            id: widgetMargins

            text: i18n("Widget margins:")
            from: 0
            to: 32
            stepSize: 1
        }

        FormSlider {
            id: windowTitleWidth

            text: i18n("Widget title width:")
            from: 30
            to: 1024
            stepSize: 1
        }

        RowLayout {
            anchors.left: parent.left

            Label {
                Layout.alignment: Qt.AlignLeft
                text: i18n("Window title font:")
            }

            SpinBox {
                id: windowTitleFontSize

                Layout.alignment: Qt.AlignLeft
                from: 1
                to: 64
            }

            Label {
                Layout.alignment: Qt.AlignLeft
                text: i18n("Size mode:")
            }

            ComboBox {
                id: windowTitleFontSizeMode

                model: [i18n("Fixed size"), i18n("Horizontal fit"), i18n("Vertical fit"), i18n("Fit")]
            }

            CheckBox {
                id: windowTitleFontBold

                text: i18n("Bold")
            }

        }

        RowLayout {
            anchors.left: parent.left

            Label {
                Layout.alignment: Qt.AlignLeft
                text: i18n("Window title undefined:")
            }

            TextField {
                id: windowTitleUndefined

                Layout.alignment: Qt.AlignLeft
            }

        }

        RowLayout {
            anchors.left: parent.left

            Label {
                Layout.alignment: Qt.AlignLeft
                text: i18n("Window title source:")
            }

            ComboBox {
                id: windowTitleSource

                model: [i18n("Application name"), i18n("Decoration")]
            }

        }

        FormMargins {
            id: windowTitleMargins

            text: i18n("Window title margins:")
        }

    }

}
