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
    property var widgetAlignment: plasmoid.configuration.widgetHorizontalAlignment | plasmoid.configuration.widgetVerticalAlignment

    Plasmoid.constraintHints: Plasmoid.CanFillArea
    Layout.fillWidth: plasmoid.configuration.widgetFillWidth
    preferredRepresentation: fullRepresentation

    Component {
        id: widgetElementLoaderDelegate

        Loader {
            id: widgetElementLoader

            required property var modelData

            onLoaded: function() {
                Utils.copyLayoutConstraint(item, widgetElementLoader);
                item.modelData = modelData;
            }
            sourceComponent: {
                switch (modelData.type) {
                case WidgetElement.Type.WindowControlButton:
                    return windowControlButton;
                case WidgetElement.Type.WindowTitle:
                    return windowTitle;
                case WidgetElement.Type.WindowIcon:
                    return windowIcon;
                }
            }

            Binding {
                when: status === Loader.Ready
                widgetElementLoader.visible: plasmoid.configuration.widgetElementsDisabledMode === WidgetElement.DisabledMode.Hide ? item.enabled : true
            }

            Binding {
                function itemVisible(itemEnabled) {
                    switch (plasmoid.configuration.widgetElementsDisabledMode) {
                    case WidgetElement.DisabledMode.Hide:
                        return itemEnabled;
                    case WidgetElement.DisabledMode.HideKeepSpace:
                        return itemEnabled;
                    default:
                        return true;
                    }
                }

                when: status === Loader.Ready
                target: item
                property: "visible"
                value: itemVisible(item.enabled)
            }

        }

    }

    Component {
        id: windowControlButton

        WindowControlButton {
            id: windowControlButton

            property var modelData

            Layout.alignment: root.widgetAlignment
            Layout.preferredWidth: plasmoid.configuration.widgetButtonsAspectRatio / 100 * height
            Layout.preferredHeight: root.controlHeight
            buttonType: modelData.windowControlButtonType
            themeName: plasmoid.configuration.widgetButtonsUsePlasmaTheme ? null : plasmoid.configuration.widgetButtonsAuroraeTheme
            onActionCall: (action) => {
                return tasksModel.activeWindow.actionCall(action);
            }
            enabled: tasksModel.hasActiveWindow && tasksModel.activeWindow.actionSupported(getAction())
            toggled: tasksModel.hasActiveWindow && tasksModel.activeWindow.buttonToggled(modelData.windowControlButtonType)
        }

    }

    Component {
        id: windowIcon

        Kirigami.Icon {
            property var modelData

            height: root.controlHeight
            Layout.alignment: root.widgetAlignment
            width: height
            source: tasksModel.activeWindow.icon || "window"
            enabled: tasksModel.hasActiveWindow && !!tasksModel.activeWindow.icon
        }

    }

    Component {
        id: windowTitle

        PlasmaComponents.Label {
            id: windowTitleLabel

            property var modelData
            property bool empty: text === undefined || text === ""
            property bool hideEmpty: empty && plasmoid.configuration.windowTitleHideEmpty

            function titleText(activeWindow, windowTitleSource) {
                switch (windowTitleSource) {
                case 0:
                    return tasksModel.activeWindow.appName;
                case 1:
                    return tasksModel.activeWindow.decoration;
                case 2:
                    return tasksModel.activeWindow.genericAppName;
                }
            }

            Layout.leftMargin: !hideEmpty ? plasmoid.configuration.windowTitleMarginsLeft : 0
            Layout.topMargin: !hideEmpty ? plasmoid.configuration.windowTitleMarginsTop : 0
            Layout.bottomMargin: !hideEmpty ? plasmoid.configuration.windowTitleMarginsBottom : 0
            Layout.rightMargin: !hideEmpty ? plasmoid.configuration.windowTitleMarginsRight : 0
            Layout.minimumWidth: plasmoid.configuration.windowTitleMinimumWidth
            Layout.maximumWidth: !hideEmpty ? plasmoid.configuration.windowTitleMaximumWidth : 0
            Layout.alignment: root.widgetAlignment
            Layout.fillWidth: plasmoid.configuration.widgetFillWidth
            text: titleText(tasksModel.activeWindow, plasmoid.configuration.windowTitleSource) || plasmoid.configuration.windowTitleUndefined
            font.pointSize: plasmoid.configuration.windowTitleFontSize
            font.bold: plasmoid.configuration.windowTitleFontBold
            fontSizeMode: plasmoid.configuration.windowTitleFontSizeMode
            maximumLineCount: 1
            elide: Text.ElideRight
            wrapMode: Text.WrapAnywhere
            enabled: tasksModel.hasActiveWindow

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
                    if (active && (!plasmoid.configuration.windowTitleDragOnlyMaximized || tasksModel.activeWindow.maximized) && tasksModel.activeWindow.movable)
                        dragInProgress = true;

                }
                onPointChanged: function() {
                    if (active && dragInProgress && point && point.pressPosition && point.position) {
                        if (distance(point.pressPosition, point.position) > dragThreshold) {
                            dragInProgress = false;
                            tasksModel.activeWindow.actionCall(ActiveWindow.Action.Move);
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

        spacing: plasmoid.configuration.widgetSpacing
        Layout.margins: plasmoid.configuration.widgetMargins
        Layout.fillWidth: plasmoid.configuration.widgetFillWidth

        Repeater {
            id: titleBarList

            property var elements: plasmoid.configuration.widgetElements

            onElementsChanged: function() {
                let array = [];
                for (var i = 0; i < elements.length; i++) {
                    array.push(Utils.widgetElementModelFromName(elements[i]));
                }
                model = array;
            }
            model: []
            delegate: widgetElementLoaderDelegate
        }

    }

}
