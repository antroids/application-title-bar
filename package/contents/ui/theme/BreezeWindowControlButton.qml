/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import org.kde.kirigami as Kirigami

BreezeWindowControlButtonIcon {
    property bool disabled: false
    property int animationDuration: 0

    titleBarColor: disabled ? Kirigami.Theme.alternateBackgroundColor : Kirigami.Theme.backgroundColor
    fontColor: disabled ? Kirigami.Theme.disabledTextColor : Kirigami.Theme.textColor
    foregroundWarningColor: disabled ? Kirigami.Theme.alternateBackgroundColor : Kirigami.Theme.negativeTextColor
    anchors.fill: parent
    anchors.margins: 3
    opacity: 0

    Behavior on opacity {
        NumberAnimation {
            duration: animationDuration
        }
    }
}
