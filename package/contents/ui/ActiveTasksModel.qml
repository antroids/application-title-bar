/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import org.kde.taskmanager as TaskManager

TaskManager.TasksModel {
    id: tasksModel

    property ActiveWindow activeWindow

    onDataChanged: function(from, to, roles) {
        if (activeTask && activeTask >= from && activeTask <= to)
            activeWindow.update();

    }
    onActiveTaskChanged: activeWindow.update()
    onModelReset: activeWindow.update()

    activeWindow: ActiveWindow {
        function update() {
            minimizable = tasksModel.data(activeTask, TaskManager.AbstractTasksModel.IsMinimizable) || false;
            maximizable = tasksModel.data(activeTask, TaskManager.AbstractTasksModel.IsMaximizable) || false;
            closable = tasksModel.data(activeTask, TaskManager.AbstractTasksModel.IsClosable) || false;
            movable = tasksModel.data(activeTask, TaskManager.AbstractTasksModel.IsMovable) || false;
            minimized = tasksModel.data(activeTask, TaskManager.AbstractTasksModel.IsMinimized) || false;
            maximized = tasksModel.data(activeTask, TaskManager.AbstractTasksModel.IsMaximized) || false;
            appName = tasksModel.data(activeTask, TaskManager.AbstractTasksModel.AppName);
            genericAppName = tasksModel.data(activeTask, TaskManager.AbstractTasksModel.GenericAppName);
            decoration = tasksModel.data(activeTask, TaskManager.AbstractTasksModel.Decoration);
            icon = tasksModel.data(activeTask, Qt.DecorationRole);
        }

        onActionCall: function(action) {
            switch (action) {
            case ActiveWindow.Action.Close:
                return tasksModel.requestClose(activeTask);
            case ActiveWindow.Action.Minimize:
                return tasksModel.requestToggleMinimized(activeTask);
            case ActiveWindow.Action.Maximize:
                return tasksModel.requestToggleMaximized(activeTask);
            case ActiveWindow.Action.Move:
                return tasksModel.requestMove(activeTask);
            }
        }
        Component.onCompleted: update()
    }

}
