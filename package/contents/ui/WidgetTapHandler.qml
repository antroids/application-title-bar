/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick

/*
* Tap handler implemented in that strange way as workaround for cases, when window layout changed during the long press interaction.
*/
TapHandler {
    id: tapHandler

    property var cfg: plasmoid.configuration
    property Timer longPressTimer: Timer {
        property int pressedButtons: 0
        interval: Qt.styleHints.mousePressAndHoldInterval
        onTriggered: function () {
            if (pressedButtons & Qt.LeftButton && cfg.widgetMouseAreaLeftLongPressAction != "")
                invokeKWinShortcut(cfg.widgetMouseAreaLeftLongPressAction);
            else if (pressedButtons & Qt.MiddleButton && cfg.widgetMouseAreaMiddleLongPressAction != "")
                invokeKWinShortcut(cfg.widgetMouseAreaMiddleLongPressAction);
        }
    }

    signal invokeKWinShortcut(string shortcut)

    enabled: cfg.widgetMouseAreaClickEnabled
    acceptedButtons: Qt.LeftButton | Qt.MiddleButton
    longPressThreshold: 0
    exclusiveSignals: TapHandler.SingleTap | TapHandler.DoubleTap
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

    onPointChanged: function () {
        if (point.pressedButtons & acceptedButtons) {
            restartLongPressTimer(point.pressedButtons);
        } else {
            stopLongPressTimer();
        }
    }

    function restartLongPressTimer(pressedButtons) {
        longPressTimer.restart();
        longPressTimer.pressedButtons = pressedButtons;
    }

    function stopLongPressTimer() {
        longPressTimer.stop();
    }
}
