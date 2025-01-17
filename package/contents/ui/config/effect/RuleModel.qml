/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import "../../common"
import QtQuick

JsonModel {
    readonly property list<string> propertyNames: ["effectIndex", "conditionType", "arg0", "arg1"]
    _propertyNames: propertyNames

    property int effectIndex: 0
    property int conditionType: 0
    property var arg0: undefined
    property var arg1: undefined
}
