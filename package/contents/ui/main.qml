/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.taskmanager as TaskManager

PlasmoidItem {
    id: root

    property TaskManager.TasksModel tasksModel
    property real controlHeight: height - plasmoid.configuration.widgetMargins * 2

    preferredRepresentation: fullRepresentation

    Component {
        id: titleBarListDelegete

        Loader {
            required property var modelData

            Layout.alignment: Qt.AlignLeft
            Layout.maximumHeight: root.controlHeight
            Layout.maximumWidth: plasmoid.configuration.windowTitleWidth
            Layout.margins: 0
            sourceComponent: modelData
        }

    }

    Component {
        id: buttonWindowClose

        PlasmaComponents.ToolButton {
            height: root.controlHeight
            width: height
            icon.name: "window-close"
            onClicked: tasksModel.requestCloseActiveTask()
            visible: tasksModel.activeTaskModel.closable
        }

    }

    Component {
        id: buttonWindowMinimize

        PlasmaComponents.ToolButton {
            height: root.controlHeight
            width: height
            icon.name: "window-minimize"
            onClicked: tasksModel.requestMinimizeActiveTask()
            visible: tasksModel.activeTaskModel.minimizable
        }

    }

    Component {
        id: buttonWindowMaximize

        PlasmaComponents.ToolButton {
            height: root.controlHeight
            width: height
            icon.name: "window-maximize"
            onClicked: tasksModel.requestMaximizeActiveTask()
            visible: tasksModel.activeTaskModel.maximizable
        }

    }

    Component {
        id: textWindowTitle

        PlasmaComponents.Label {
            anchors.left: parent.left
            anchors.leftMargin: plasmoid.configuration.windowTitleMarginsLeft
            anchors.topMargin: plasmoid.configuration.windowTitleMarginsTop
            anchors.bottomMargin: plasmoid.configuration.windowTitleMarginsBottom
            anchors.rightMargin: plasmoid.configuration.windowTitleMarginsRight
            text: (plasmoid.configuration.windowTitleSource == 1 ? tasksModel.activeTaskModel.decoration : tasksModel.activeTaskModel.appName) || plasmoid.configuration.windowTitleUndefined
            font.pointSize: plasmoid.configuration.windowTitleFontSize
            font.bold: plasmoid.configuration.windowTitleFontBold
            fontSizeMode: plasmoid.configuration.windowTitleFontSizeMode
            maximumLineCount: 1
            elide: Text.ElideRight
            wrapMode: Text.WrapAnywhere

            PointHandler {
                property bool dragInProgress: false

                function distance(p1, p2) {
                    let dx = p2.x - p1.x;
                    let dy = p2.y - p1.y;
                    return Math.sqrt(dx * dx + dy * dy);
                }

                enabled: plasmoid.configuration.windowTitleDragEnabled
                dragThreshold: plasmoid.configuration.windowTitleDragThreshold
                acceptedButtons: Qt.LeftButton
                onActiveChanged: function() {
                    if (active && tasksModel.activeTaskModel.maximized && tasksModel.activeTaskModel.movable)
                        dragInProgress = true;

                }
                onPointChanged: function() {
                    if (active && dragInProgress && point && point.pressPosition && point.position) {
                        if (distance(point.pressPosition, point.position) > dragThreshold) {
                            dragInProgress = false;
                            tasksModel.requestMoveActiveTask();
                        }
                    }
                }
            }

        }

    }

    tasksModel: TaskManager.TasksModel {
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
                decoration = tasksModel.data(activeTask, TaskManager.AbstractTasksModel.Decoration);
            }

            activeTask: tasksModel.activeTask
            Component.onCompleted: update()
        }

    }

    fullRepresentation: RowLayout {
        id: widgetRow

        anchors.margins: plasmoid.configuration.widgetMargins

        Repeater {
            id: titleBarList

            model: [buttonWindowClose, buttonWindowMinimize, buttonWindowMaximize, textWindowTitle]
            delegate: titleBarListDelegete
        }

    }

}
