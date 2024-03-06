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
            visible: tasksModel.isActiveTaskClosable()
        }

    }

    Component {
        id: buttonWindowMinimize

        PlasmaComponents.ToolButton {
            height: root.controlHeight
            width: height
            icon.name: "window-minimize"
            onClicked: tasksModel.requestMinimizeActiveTask()
            visible: tasksModel.isActiveTaskMinimizable()
        }

    }

    Component {
        id: buttonWindowMaximize

        PlasmaComponents.ToolButton {
            height: root.controlHeight
            width: height
            icon.name: "window-maximize"
            onClicked: tasksModel.requestMaximizeActiveTask()
            visible: tasksModel.isActiveTaskMaximizable()
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
            text: tasksModel.activeTaskName() || plasmoid.configuration.windowTitleUndefined
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
                    if (active && tasksModel.isActiveTaskMaximized() && tasksModel.isActiveTaskMovable())
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

        function getActiveTask() {
            return tasksModel.activeTask;
        }

        function requestCloseActiveTask() {
            let activeTask = tasksModel.getActiveTask();
            if (activeTask)
                requestClose(activeTask);

        }

        function requestMinimizeActiveTask() {
            let activeTask = tasksModel.getActiveTask();
            if (activeTask)
                requestToggleMinimized(activeTask);

        }

        function requestMaximizeActiveTask() {
            let activeTask = tasksModel.getActiveTask();
            if (activeTask)
                requestToggleMaximized(activeTask);

        }

        function requestMoveActiveTask() {
            let activeTask = tasksModel.getActiveTask();
            if (activeTask)
                requestMove(activeTask);

        }

        function isActiveTaskClosable() {
            let activeTask = tasksModel.getActiveTask();
            return activeTask && tasksModel.data(activeTask, TaskManager.AbstractTasksModel.IsClosable) || false;
        }

        function isActiveTaskMinimizable() {
            let activeTask = tasksModel.getActiveTask();
            return activeTask && tasksModel.data(activeTask, TaskManager.AbstractTasksModel.IsMinimizable) || false;
        }

        function isActiveTaskMaximizable() {
            let activeTask = tasksModel.getActiveTask();
            return activeTask && tasksModel.data(activeTask, TaskManager.AbstractTasksModel.IsMaximizable) || false;
        }

        function isActiveTaskMovable() {
            let activeTask = tasksModel.getActiveTask();
            return activeTask && tasksModel.data(activeTask, TaskManager.AbstractTasksModel.IsMovable) || false;
        }

        function isActiveTaskMaximized() {
            let activeTask = tasksModel.getActiveTask();
            return activeTask && tasksModel.data(activeTask, TaskManager.AbstractTasksModel.IsMaximized) || false;
        }

        function activeTaskName() {
            let activeTask = tasksModel.getActiveTask();
            let source = plasmoid.configuration.windowTitleSource == 1 ? TaskManager.AbstractTasksModel.Decoration : TaskManager.AbstractTasksModel.AppName;
            return activeTask && tasksModel.data(activeTask, source);
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
