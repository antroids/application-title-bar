/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import "../utils.js" as Utils
import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami

ComboBox {
    property int maxStringLength: 30
    property string label
    property var initialValue

    function updateCurrentIndex() {
        enabled = model.length > 1;
        currentIndex = indexOfValue(initialValue);
    }

    Component.onCompleted: updateCurrentIndex()
    onModelChanged: updateCurrentIndex()
    Kirigami.FormData.label: label
    model: [
        {
            "shortcut": "",
            "truncatedName": " "
        }
    ].concat(kWinConfig.shortcutNames.map(shortcut => {
        return ({
                "shortcut": shortcut,
                "truncatedName": Utils.truncateString(shortcut, 40)
            });
    }))
    valueRole: "shortcut"
    textRole: "truncatedName"
}
