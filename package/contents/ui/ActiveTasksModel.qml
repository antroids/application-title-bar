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
    property bool hasActiveWindow: false
    property TaskManager.VirtualDesktopInfo virtualDesktopInfo
    property TaskManager.ActivityInfo activityInfo
    property Repeater filteredTasksRepeater

    screenGeometry: plasmoid.containment.screenGeometry
    activity: activityInfo.currentActivity
    virtualDesktop: virtualDesktopInfo.currentDesktop
    filterByActivity: plasmoid.configuration.widgetActiveTaskFilterByActivity
    filterByScreen: plasmoid.configuration.widgetActiveTaskFilterByScreen
    filterByVirtualDesktop: plasmoid.configuration.widgetActiveTaskFilterByVirtualDesktop
    onDataChanged: function(from, to, roles) {
        if (activeTask.valid || activeTask >= from && activeTask <= to)
            activeWindow.update();

    }
    onActiveTaskChanged: activeWindow.update()
    onCountChanged: activeWindow.update()
    sortMode: TaskManager.TasksModel.SortLastActivated

    virtualDesktopInfo: TaskManager.VirtualDesktopInfo {
    }

    activityInfo: TaskManager.ActivityInfo {
        readonly property string nullUuid: "00000000-0000-0000-0000-000000000000"
    }

    activeWindow: ActiveWindow {
        function update() {
            tasksModel.hasActiveWindow = activeTask.valid;
            minimizable = tasksModel.data(activeTask, TaskManager.AbstractTasksModel.IsMinimizable) || false;
            maximizable = tasksModel.data(activeTask, TaskManager.AbstractTasksModel.IsMaximizable) || false;
            closable = tasksModel.data(activeTask, TaskManager.AbstractTasksModel.IsClosable) || false;
            movable = tasksModel.data(activeTask, TaskManager.AbstractTasksModel.IsMovable) || false;
            minimized = tasksModel.data(activeTask, TaskManager.AbstractTasksModel.IsMinimized) || false;
            maximized = tasksModel.data(activeTask, TaskManager.AbstractTasksModel.IsMaximized) || false;
            shadeable = tasksModel.data(activeTask, TaskManager.AbstractTasksModel.IsShadeable) || false;
            shaded = tasksModel.data(activeTask, TaskManager.AbstractTasksModel.IsShaded) || false;
            keepAbove = tasksModel.data(activeTask, TaskManager.AbstractTasksModel.IsKeepAbove) || false;
            keepBelow = tasksModel.data(activeTask, TaskManager.AbstractTasksModel.IsKeepBelow) || false;
            hasAppMenu = tasksModel.data(activeTask, TaskManager.AbstractTasksModel.ApplicationMenuServiceName) || false;
            onAllVirtualDesktops = tasksModel.data(activeTask, TaskManager.AbstractTasksModel.IsOnAllVirtualDesktops) || false;
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
            case ActiveWindow.Action.KeepAbove:
                return tasksModel.requestToggleKeepAbove(activeTask);
            case ActiveWindow.Action.KeepBelow:
                return tasksModel.requestToggleKeepBelow(activeTask);
            case ActiveWindow.Action.Shade:
                return tasksModel.requestToggleShaded(activeTask);
            }
        }
        Component.onCompleted: update()
    }

}
