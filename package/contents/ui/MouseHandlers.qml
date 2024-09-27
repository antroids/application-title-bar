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
        Component.onCompleted: {
            invokeKWinShortcut.connect(handlers.invokeKWinShortcut);
        }
    }

    WidgetTapHandler {
        Component.onCompleted: {
            invokeKWinShortcut.connect(handlers.invokeKWinShortcut);
        }
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
