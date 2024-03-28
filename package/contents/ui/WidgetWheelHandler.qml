/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick

WheelHandler {
    property var cfg: plasmoid.configuration
    property int verticalRotation: 0
    property int horizontalRotation: 0
    property bool firstHorizontalEvent: true
    property bool firstVerticalEvent: true
    property int firstEventDistance: cfg.widgetMouseAreaWheelFirstEventDistance
    property int nextEventDistance: cfg.widgetMouseAreaWheelNextEventDistance

    signal invokeKWinShortcut(string shortcut)
    signal wheelUp
    signal wheelDown
    signal wheelLeft
    signal wheelRight

    enabled: cfg.widgetMouseAreaWheelEnabled
    target: null
    acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
    onActiveChanged: function () {
        if (!active) {
            verticalRotation = 0;
            horizontalRotation = 0;
            firstHorizontalEvent = true;
            firstVerticalEvent = true;
        }
    }
    onWheel: function (wheelEvent) {
        let dx = wheelEvent.angleDelta.x;
        let dy = wheelEvent.angleDelta.y;
        if (orientation == Qt.Horizontal) {
            horizontalRotation = (horizontalRotation < 0) == (dx < 0) ? (horizontalRotation + dx) : dx;
            let distance = Math.abs(horizontalRotation);
            if ((firstHorizontalEvent && distance >= firstEventDistance) || (nextEventDistance > 0 && distance >= nextEventDistance)) {
                if (horizontalRotation < 0)
                    wheelRight();
                else
                    wheelLeft();
                if (firstHorizontalEvent) {
                    firstHorizontalEvent = false;
                    horizontalRotation -= Math.sign(horizontalRotation) * firstEventDistance;
                } else {
                    horizontalRotation -= Math.sign(horizontalRotation) * nextEventDistance;
                }
            }
        } else {
            verticalRotation = (verticalRotation < 0) == (dy < 0) ? (verticalRotation + dy) : dy;
            let distance = Math.abs(verticalRotation);
            if ((firstVerticalEvent && distance >= firstEventDistance) || (nextEventDistance > 0 && distance >= nextEventDistance)) {
                if (verticalRotation < 0)
                    wheelDown();
                else
                    wheelUp();
                if (firstVerticalEvent) {
                    firstVerticalEvent = false;
                    verticalRotation -= Math.sign(verticalRotation) * firstEventDistance;
                } else {
                    verticalRotation -= Math.sign(verticalRotation) * nextEventDistance;
                }
            }
        }
    }
    onWheelUp: function () {
        if (cfg.widgetMouseAreaWheelUpAction != "")
            invokeKWinShortcut(cfg.widgetMouseAreaWheelUpAction);
    }
    onWheelDown: function () {
        if (cfg.widgetMouseAreaWheelDownAction != "")
            invokeKWinShortcut(cfg.widgetMouseAreaWheelDownAction);
    }
    onWheelLeft: function () {
        if (cfg.widgetMouseAreaWheelLeftAction != "")
            invokeKWinShortcut(cfg.widgetMouseAreaWheelLeftAction);
    }
    onWheelRight: function () {
        if (cfg.widgetMouseAreaWheelRightAction != "")
            invokeKWinShortcut(cfg.widgetMouseAreaWheelRightAction);
    }
}
