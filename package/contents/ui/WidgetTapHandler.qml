/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick

TapHandler {
    property var cfg: plasmoid.configuration
    required property KWinConfig kWinConfig

    enabled: cfg.widgetMouseAreaClickEnabled
    acceptedButtons: Qt.LeftButton | Qt.MiddleButton
    onSingleTapped: function(eventPoint, button) {
        if (button === Qt.LeftButton && cfg.widgetMouseAreaLeftClickAction != "")
            kWinConfig.invokeKWinShortcut(cfg.widgetMouseAreaLeftClickAction);
        else if (button === Qt.MiddleButton && cfg.widgetMouseAreaMiddleClickAction != "")
            kWinConfig.invokeKWinShortcut(cfg.widgetMouseAreaMiddleClickAction);
    }
    onDoubleTapped: function(eventPoint, button) {
        if (button === Qt.LeftButton && cfg.widgetMouseAreaLeftDoubleClickAction != "")
            kWinConfig.invokeKWinShortcut(cfg.widgetMouseAreaLeftDoubleClickAction);
        else if (button === Qt.MiddleButton && cfg.widgetMouseAreaMiddleDoubleClickAction != "")
            kWinConfig.invokeKWinShortcut(cfg.widgetMouseAreaMiddleDoubleClickAction);
    }
    onLongPressed: function() {
        if (point.pressedButtons & Qt.LeftButton && cfg.widgetMouseAreaLeftLongPressAction != "")
            kWinConfig.invokeKWinShortcut(cfg.widgetMouseAreaLeftLongPressAction);
        else if (point.pressedButtons & Qt.MiddleButton && cfg.widgetMouseAreaMiddleLongPressAction != "")
            kWinConfig.invokeKWinShortcut(cfg.widgetMouseAreaMiddleLongPressAction);
    }
}
