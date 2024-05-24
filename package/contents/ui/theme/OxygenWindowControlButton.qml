/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick

OxygenWindowControlButtonIcon {
    property int animationDuration: 0

    anchors.fill: parent
    opacity: 0

    Behavior on opacity {
        NumberAnimation {
            duration: animationDuration
            easing.type: Easing.OutQuint
        }
    }
}
