/*
 * SPDX-FileCopyrightText: 2025 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls

ComboBox {
    textRole: "name"
    valueRole: "value"
    wheelEnabled: false
    displayText: i18n("Add Preset Effect")

    model: [
        {
            name: i18n("White Glow"),
            value: {
                shadowOpacity: 0.5,
                shadowColor: Qt.color("white"),
                maskEnabled: false,
                maskInverted: false
            }
        },
        {
            name: i18n("Blur"),
            value: {
                blur: 0.5,
                maskEnabled: false,
                maskInverted: false
            }
        },
        {
            name: i18n("Desaturate"),
            value: {
                contrast: -0.5,
                saturation: -1.0,
                maskEnabled: false,
                maskInverted: false
            }
        }
    ]
}
