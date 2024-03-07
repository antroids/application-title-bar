/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick

QtObject {
    property var activeTask
    property bool minimizable: false
    property bool maximizable: false
    property bool closable: false
    property bool movable: false
    property bool minimized: false
    property bool maximized: false
    property var appName
    property var genericAppName
    property var decoration
    property var icon
}
