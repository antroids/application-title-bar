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

        currentIndex: indexOfValue(arg0)
        onActivated: arg0Updated(currentValue)

        textRole: "name"
        valueRole: "value"
        wheelEnabled: false

        model: [
            {
                name: i18n("App Name"),
                value: "appName"
            },
            {
                name: i18n("Generic App Name"),
                value: "genericAppName"
            },
            {
                name: i18n("Full App Name"),
                value: "decoration"
            },
            {
                name: i18n("Icon"),
                value: "icon"
            }
        ]
    }

    TextField {
        id: propertyValue

        Layout.fillWidth: true
        text: arg1 || ""
        onTextEdited: arg1Updated(text)
    }
}
