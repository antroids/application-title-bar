/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import org.kde.plasma.plasmoid

/*
* Drag handler implemented in that strange way as workaround for cases, when window layout changed during the drag interaction.
*/
PointHandler {
    property bool dragInProgress: false
    property var cfg: plasmoid.configuration

    signal invokeKWinShortcut(string shortcut)

    function distance(p1, p2) {
        let dx = p2.x - p1.x;
        let dy = p2.y - p1.y;
        return Math.sqrt(dx * dx + dy * dy);
    }

    function stopDrag() {
        dragInProgress = false;
    }

    enabled: cfg.windowTitleDragEnabled
    dragThreshold: cfg.windowTitleDragThreshold
    acceptedButtons: Qt.LeftButton | Qt.MiddleButton
    onActiveChanged: function () {
        if (active && (!cfg.windowTitleDragOnlyMaximized || tasksModel.activeWindow.maximized))
            dragInProgress = true;
        else
            stopDrag();
    }
    onPointChanged: function () {
        if (active && dragInProgress && point && point.pressPosition && point.position) {
            if (distance(point.pressPosition, point.position) > dragThreshold) {
                stopDrag();
                if (point.pressedButtons & Qt.LeftButton && cfg.widgetMouseAreaLeftDragAction != "")
                    invokeKWinShortcut(cfg.widgetMouseAreaLeftDragAction);
                else if (point.pressedButtons & Qt.MiddleButton && cfg.widgetMouseAreaMiddleDragAction != "")
                    invokeKWinShortcut(cfg.widgetMouseAreaMiddleDragAction);
            }
        }
    }
}
