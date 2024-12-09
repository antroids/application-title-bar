/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick

Item {
    id: handlers
    anchors.fill: parent

    signal invokeKWinShortcut(string shortcut)

    WidgetDragHandler {
        id: dragHandler
        Component.onCompleted: {
            invokeKWinShortcut.connect(handlers.invokeKWinShortcut);
        }
        onInvokeKWinShortcut: tapHandler.stopLongPressTimer()
    }

    WidgetTapHandler {
        id: tapHandler
        Component.onCompleted: {
            invokeKWinShortcut.connect(handlers.invokeKWinShortcut);
        }
        onInvokeKWinShortcut: dragHandler.stopDrag()
    }

    WidgetWheelHandler {
        orientation: Qt.Vertical
        Component.onCompleted: {
            invokeKWinShortcut.connect(handlers.invokeKWinShortcut);
        }
    }

    WidgetWheelHandler {
        orientation: Qt.Horizontal
        Component.onCompleted: {
            invokeKWinShortcut.connect(handlers.invokeKWinShortcut);
        }
    }
}
