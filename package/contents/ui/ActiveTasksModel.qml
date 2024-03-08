/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import org.kde.taskmanager as TaskManager

TaskManager.TasksModel {
    id: tasksModel

    property ActiveTaskModel activeTaskModel

    function requestCloseActiveTask() {
        if (activeTask)
            requestClose(activeTask);

    }

    function requestMinimizeActiveTask() {
        if (activeTask)
            requestToggleMinimized(activeTask);

    }

    function requestMaximizeActiveTask() {
        if (activeTask)
            requestToggleMaximized(activeTask);

    }

    function requestMoveActiveTask() {
        if (activeTask)
            requestMove(activeTask);

    }

    onDataChanged: function(from, to, roles) {
        if (activeTask && activeTask >= from && activeTask <= to)
            activeTaskModel.update();

    }
    onActiveTaskChanged: function() {
        activeTaskModel.update();
    }
    onModelReset: activeTaskModel.update()

    activeTaskModel: ActiveTaskModel {
        function update() {
            activeTask = tasksModel.activeTask;
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

        activeTask: tasksModel.activeTask
        Component.onCompleted: update()
    }

}
