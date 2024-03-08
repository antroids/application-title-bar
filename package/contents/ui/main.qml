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
import "utils.js" as Utils

PlasmoidItem {
    id: root

    property TaskManager.TasksModel tasksModel
    property real controlHeight: height - plasmoid.configuration.widgetMargins * 2
    property var widgetAlignment: plasmoid.configuration.windgetHorizontalAlignment | plasmoid.configuration.windgetVerticalAlignment

    preferredRepresentation: fullRepresentation

    Component {
        id: titleBarListDelegete

        Loader {
            id: titleBarListDelegeteLoader

            required property var modelData

            onLoaded: function() {
                Utils.copyLayoutConstraint(item, titleBarListDelegeteLoader);
            }
            sourceComponent: modelData
        }

    }

    Component {
        id: windowCloseButton

        WindowButton {
            icon.name: "window-close"
            onClicked: tasksModel.requestCloseActiveTask()
            visible: tasksModel.activeTaskModel.closable
        }

    }

    Component {
        id: windowMinimizeButton

        WindowButton {
            icon.name: "window-minimize"
            onClicked: tasksModel.requestMinimizeActiveTask()
            visible: tasksModel.activeTaskModel.minimizable
        }

    }

    Component {
        id: windowMaximizeButton

        WindowButton {
            icon.name: "window-maximize"
            onClicked: tasksModel.requestMaximizeActiveTask()
            visible: tasksModel.activeTaskModel.maximizable
        }

    }

    Component {
        id: windowIcon

        Kirigami.Icon {
            height: root.controlHeight
            Layout.alignment: root.widgetAlignment
            width: height
            source: tasksModel.activeTaskModel.icon
            visible: !!tasksModel.activeTaskModel && !!tasksModel.activeTaskModel.icon
        }

    }

    Component {
        id: windowTitle

        PlasmaComponents.Label {
            function titleText(activeTaskModel, windowTitleSource) {
                switch (windowTitleSource) {
                case 0:
                    return tasksModel.activeTaskModel.appName;
                case 1:
                    return tasksModel.activeTaskModel.decoration;
                case 2:
                    return tasksModel.activeTaskModel.genericAppName;
                }
            }

            Layout.leftMargin: plasmoid.configuration.windowTitleMarginsLeft
            Layout.topMargin: plasmoid.configuration.windowTitleMarginsTop
            Layout.bottomMargin: plasmoid.configuration.windowTitleMarginsBottom
            Layout.rightMargin: plasmoid.configuration.windowTitleMarginsRight
            Layout.minimumWidth: plasmoid.configuration.windowTitleMinimumWidth
            Layout.maximumWidth: plasmoid.configuration.windowTitleMaximumWidth
            Layout.alignment: root.widgetAlignment
            text: titleText(tasksModel.activeTaskModel, plasmoid.configuration.windowTitleSource) || plasmoid.configuration.windowTitleUndefined
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
                    if (active && (!plasmoid.configuration.windowTitleDragOnlyMaximized || tasksModel.activeTaskModel.maximized) && tasksModel.activeTaskModel.movable)
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

    tasksModel: ActiveTasksModel {
        id: tasksModel
    }

    fullRepresentation: RowLayout {
        id: widgetRow

        anchors.margins: plasmoid.configuration.widgetMargins
        spacing: plasmoid.configuration.widgetSpacing

        Repeater {
            id: titleBarList

            property var elements: plasmoid.configuration.widgetElements

            function getElementComponent(value) {
                switch (value) {
                case "windowCloseButton":
                    return windowCloseButton;
                case "windowMinimizeButton":
                    return windowMinimizeButton;
                case "windowMaximizeButton":
                    return windowMaximizeButton;
                case "windowTitle":
                    return windowTitle;
                case "windowIcon":
                    return windowIcon;
                }
            }

            onElementsChanged: function() {
                let array = [];
                for (var i = 0; i < elements.length; i++) {
                    array.push(getElementComponent(elements[i]));
                }
                model = array;
            }
            model: []
            delegate: titleBarListDelegete
        }

    }

}
