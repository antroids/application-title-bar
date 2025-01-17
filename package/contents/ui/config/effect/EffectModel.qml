/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import "../../common"
import QtQuick

JsonModel {
    readonly property list<string> propertyNames: ["name", "brightness", "contrast", "saturation", "colorization", "colorizationColor", "blur", "blurMax", "blurMultiplier", "shadowOpacity", "shadowBlur", "shadowHorizontalOffset", "shadowVerticalOffset", "shadowScale", "shadowColor", "maskEnabled", "maskInverted", "maskThresholdMin", "maskThresholdMax", "maskSpreadAtMin", "maskSpreadAtMax"]
    _propertyNames: propertyNames

    property string name: "Effect"

    property var brightness: undefined
    property var contrast: undefined
    property var saturation: undefined
    property var colorization: undefined
    property var colorizationColor: undefined

    property var blur: undefined
    property var blurMax: undefined
    property var blurMultiplier: undefined

    property var shadowOpacity: undefined
    property var shadowBlur: undefined
    property var shadowHorizontalOffset: undefined
    property var shadowVerticalOffset: undefined
    property var shadowScale: undefined
    property var shadowColor: undefined

    property bool maskEnabled: false
    property bool maskInverted: false
    property var maskThresholdMin: undefined
    property var maskThresholdMax: undefined
    property var maskSpreadAtMin: undefined
    property var maskSpreadAtMax: undefined
}
