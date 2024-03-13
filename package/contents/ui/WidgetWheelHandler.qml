/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick

WheelHandler {
    property var cfg: plasmoid.configuration
    required property KWinConfig kWinConfig

    enabled: cfg.widgetMouseAreaWheelEnabled
    target: null
    acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
    onWheel: function(wheelEvent) {
        let angleDelta = wheelEvent.angleDelta;
        if (Math.abs(angleDelta.x) > Math.abs(angleDelta.y)) {
            if (angleDelta.x > 0 && cfg.widgetMouseAreaWheelRightAction != "")
                kWinConfig.invokeKWinShortcut(cfg.widgetMouseAreaWheelRightAction);
            else if (cfg.widgetMouseAreaWheelLeftAction != "")
                kWinConfig.invokeKWinShortcut(cfg.widgetMouseAreaWheelLeftAction);
        } else {
            if (angleDelta.y > 0 && cfg.widgetMouseAreaWheelUpAction != "")
                kWinConfig.invokeKWinShortcut(cfg.widgetMouseAreaWheelUpAction);
            else if (cfg.widgetMouseAreaWheelDownAction != "")
                kWinConfig.invokeKWinShortcut(cfg.widgetMouseAreaWheelDownAction);
        }
    }
}
