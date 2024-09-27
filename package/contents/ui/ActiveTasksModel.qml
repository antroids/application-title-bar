/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import org.kde.taskmanager as TaskManager

TaskManager.TasksModel {
    id: tasksModel

    enum ActiveTaskSource {
        ActiveTask,
        LastActiveTask,
        LastActiveMaximized
    }

    property ActiveWindow activeWindow
    property bool hasActiveWindow: activeTaskIndex.valid
    property TaskManager.VirtualDesktopInfo virtualDesktopInfo
    property TaskManager.ActivityInfo activityInfo
    property Repeater filteredTasksRepeater
    property var activeTaskIndex: getInvalidIndex()
    property Loader showingDesktopStateListener: Loader {
        property bool showingDesktop: false

        source: "KWindowSystemAdapter.qml"
        onStatusChanged: function () {
            if (status == Loader.Ready) {
                showingDesktop = Qt.binding(function () {
                    return item.showingDesktop;
                });
            } else {
                showingDesktop = false;
            }
        }
        onShowingDesktopChanged: updateActiveTaskIndex()
    }

    function getInvalidIndex() {
        return index(-1, -1);
    }

    function getFirstRowIndex() {
        return index(0, 0);
    }

    function updateActiveTaskIndex() {
        if (showingDesktopStateListener.showingDesktop) {
            activeTaskIndex = getInvalidIndex();
        } else {
            switch (plasmoid.configuration.widgetActiveTaskSource) {
            case ActiveTasksModel.ActiveTaskSource.ActiveTask:
                activeTaskIndex = filterTask(activeTask) ? activeTask : getInvalidIndex();
                break;
            case ActiveTasksModel.ActiveTaskSource.LastActiveTask:
            case ActiveTasksModel.ActiveTaskSource.LastActiveMaximized:
                activeTaskIndex = hasIndex(0, 0) && filterTask(getFirstRowIndex()) ? getFirstRowIndex() : getInvalidIndex();
                break;
            }
        }
        activeWindow.update();
    }

    function filterTask(index) {
        if (!index || !index.valid)
            return false;
        if (plasmoid.configuration.widgetActiveTaskFilterNotMaximized)
            return tasksModel.data(index, TaskManager.AbstractTasksModel.IsMaximized) || false;
        return true;
    }

    screenGeometry: plasmoid.containment.screenGeometry
    activity: activityInfo.currentActivity
    virtualDesktop: virtualDesktopInfo.currentDesktop
    filterByActivity: plasmoid.configuration.widgetActiveTaskFilterByActivity
    filterByScreen: plasmoid.configuration.widgetActiveTaskFilterByScreen
    filterByVirtualDesktop: plasmoid.configuration.widgetActiveTaskFilterByVirtualDesktop
    filterHidden: true
    filterMinimized: true
    filterNotMaximized: plasmoid.configuration.widgetActiveTaskSource == ActiveTasksModel.ActiveTaskSource.LastActiveMaximized
    onDataChanged: function (from, to, roles) {
        if (hasActiveWindow && activeTaskIndex >= from && activeTaskIndex <= to)
            updateActiveTaskIndex();
        else if (!hasActiveWindow && getFirstRowIndex() >= from && getFirstRowIndex() <= to)
            updateActiveTaskIndex();
    }
    onActiveTaskChanged: updateActiveTaskIndex()
    onCountChanged: updateActiveTaskIndex()
    sortMode: TaskManager.TasksModel.SortLastActivated
    groupMode: TaskManager.TasksModel.GroupDisabled
    Component.onCompleted: updateActiveTaskIndex()

    virtualDesktopInfo: TaskManager.VirtualDesktopInfo {}

    activityInfo: TaskManager.ActivityInfo {
        readonly property string nullUuid: "00000000-0000-0000-0000-000000000000"
    }

    activeWindow: ActiveWindow {
        function update() {
            minimizable = tasksModel.data(activeTaskIndex, TaskManager.AbstractTasksModel.IsMinimizable) || false;
            maximizable = tasksModel.data(activeTaskIndex, TaskManager.AbstractTasksModel.IsMaximizable) || false;
            closable = tasksModel.data(activeTaskIndex, TaskManager.AbstractTasksModel.IsClosable) || false;
            movable = tasksModel.data(activeTaskIndex, TaskManager.AbstractTasksModel.IsMovable) || false;
            minimized = tasksModel.data(activeTaskIndex, TaskManager.AbstractTasksModel.IsMinimized) || false;
            maximized = tasksModel.data(activeTaskIndex, TaskManager.AbstractTasksModel.IsMaximized) || false;
            shadeable = tasksModel.data(activeTaskIndex, TaskManager.AbstractTasksModel.IsShadeable) || false;
            shaded = tasksModel.data(activeTaskIndex, TaskManager.AbstractTasksModel.IsShaded) || false;
            keepAbove = tasksModel.data(activeTaskIndex, TaskManager.AbstractTasksModel.IsKeepAbove) || false;
            keepBelow = tasksModel.data(activeTaskIndex, TaskManager.AbstractTasksModel.IsKeepBelow) || false;
            hasAppMenu = tasksModel.data(activeTaskIndex, TaskManager.AbstractTasksModel.ApplicationMenuServiceName) || false;
            onAllVirtualDesktops = tasksModel.data(activeTaskIndex, TaskManager.AbstractTasksModel.IsOnAllVirtualDesktops) || false;
            fullScreenable = tasksModel.data(activeTaskIndex, TaskManager.AbstractTasksModel.IsFullScreenable) || false;
            fullScreen = tasksModel.data(activeTaskIndex, TaskManager.AbstractTasksModel.IsFullScreen) || false;
            resizable = tasksModel.data(activeTaskIndex, TaskManager.AbstractTasksModel.IsResizable) || false;
            active = tasksModel.data(activeTaskIndex, TaskManager.AbstractTasksModel.IsActive) || false;
            appName = tasksModel.data(activeTaskIndex, TaskManager.AbstractTasksModel.AppName);
            genericAppName = tasksModel.data(activeTaskIndex, TaskManager.AbstractTasksModel.GenericAppName);
            decoration = tasksModel.data(activeTaskIndex, TaskManager.AbstractTasksModel.Decoration);
            icon = tasksModel.data(activeTaskIndex, Qt.DecorationRole);
        }

        onActionCall: function (action) {
            switch (action) {
            case ActiveWindow.Action.Close:
                return tasksModel.requestClose(activeTaskIndex);
            case ActiveWindow.Action.Minimize:
                return tasksModel.requestToggleMinimized(activeTaskIndex);
            case ActiveWindow.Action.Maximize:
                return tasksModel.requestToggleMaximized(activeTaskIndex);
            case ActiveWindow.Action.Move:
                return tasksModel.requestMove(activeTaskIndex);
            case ActiveWindow.Action.KeepAbove:
                return tasksModel.requestToggleKeepAbove(activeTaskIndex);
            case ActiveWindow.Action.KeepBelow:
                return tasksModel.requestToggleKeepBelow(activeTaskIndex);
            case ActiveWindow.Action.Shade:
                return tasksModel.requestToggleShaded(activeTaskIndex);
            case ActiveWindow.Action.Activate:
                return tasksModel.requestActivate(activeTaskIndex);
            case ActiveWindow.Action.FullScreen:
                return tasksModel.requestToggleFullScreen(activeTaskIndex);
            case ActiveWindow.Action.Resize:
                return tasksModel.requestResize(activeTaskIndex);
            }
        }
    }
}
