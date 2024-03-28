/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick

TapHandler {
    property var cfg: plasmoid.configuration

    signal invokeKWinShortcut(string shortcut)

    enabled: cfg.widgetMouseAreaClickEnabled
    acceptedButtons: Qt.LeftButton | Qt.MiddleButton
    onSingleTapped: function (eventPoint, button) {
        if (button === Qt.LeftButton && cfg.widgetMouseAreaLeftClickAction != "")
            invokeKWinShortcut(cfg.widgetMouseAreaLeftClickAction);
        else if (button === Qt.MiddleButton && cfg.widgetMouseAreaMiddleClickAction != "")
            invokeKWinShortcut(cfg.widgetMouseAreaMiddleClickAction);
    }
    onDoubleTapped: function (eventPoint, button) {
        if (button === Qt.LeftButton && cfg.widgetMouseAreaLeftDoubleClickAction != "")
            invokeKWinShortcut(cfg.widgetMouseAreaLeftDoubleClickAction);
        else if (button === Qt.MiddleButton && cfg.widgetMouseAreaMiddleDoubleClickAction != "")
            invokeKWinShortcut(cfg.widgetMouseAreaMiddleDoubleClickAction);
    }
    onLongPressed: function () {
        if (point.pressedButtons & Qt.LeftButton && cfg.widgetMouseAreaLeftLongPressAction != "")
            invokeKWinShortcut(cfg.widgetMouseAreaLeftLongPressAction);
        else if (point.pressedButtons & Qt.MiddleButton && cfg.widgetMouseAreaMiddleLongPressAction != "")
            invokeKWinShortcut(cfg.widgetMouseAreaMiddleLongPressAction);
    }
}
