/*
 * SPDX-FileCopyrightText: 2025 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

RowLayout {
    property var arg0
    property var arg1

    signal arg0Updated(var value)
    signal arg1Updated(var value)

    onArg0Changed: function () {
        if (propertyName.indexOfValue(arg0) === -1 && propertyName.count > 0) {
            arg0Updated(propertyName.valueAt(0));
        }
    }

    ComboBox {
        id: propertyName

        Layout.fillWidth: true

        textRole: "name"
        valueRole: "value"

        currentIndex: indexOfValue(arg0)
        onActivated: arg0Updated(currentValue)

        model: [
            {
                name: i18n("Minimizable"),
                value: "minimizable"
            },
            {
                name: i18n("Maximizable"),
                value: "maximizable"
            },
            {
                name: i18n("Closable"),
                value: "closable"
            },
            {
                name: i18n("Movable"),
                value: "movable"
            },
            {
                name: i18n("Minimized"),
                value: "minimized"
            },
            {
                name: i18n("Maximized"),
                value: "maximized"
            },
            {
                name: i18n("Shadeable"),
                value: "shadeable"
            },
            {
                name: i18n("Shaded"),
                value: "shaded"
            },
            {
                name: i18n("Has App Menu"),
                value: "hasAppMenu"
            },
            {
                name: i18n("On all Virtual Desktops"),
                value: "onAllVirtualDesktops"
            },
            {
                name: i18n("Keep Above"),
                value: "keepAbove"
            },
            {
                name: i18n("Keep Below"),
                value: "keepBelow"
            },
            {
                name: i18n("Full Screenable"),
                value: "fullScreenable"
            },
            {
                name: i18n("Full Screen"),
                value: "fullScreen"
            },
            {
                name: i18n("Resizable"),
                value: "resizable"
            },
            {
                name: i18n("Active"),
                value: "active"
            }
        ]
    }

    CheckBox {
        id: propertyValue

        checked: !!arg1
        onToggled: arg1Updated(checked)

        text: i18n("value")
    }
}
