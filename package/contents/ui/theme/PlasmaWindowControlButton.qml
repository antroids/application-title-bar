/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

PlasmaWindowControlButtonIcon {
    anchors.fill: parent

    property bool disabled: false
    property int animationDuration: 0

    opacity: 0

    Behavior on opacity {
        NumberAnimation {
            duration: animationDuration
        }
    }
}
