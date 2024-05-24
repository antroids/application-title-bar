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
import org.kde.plasma.extras as PlasmaExtras
import org.kde.plasma.plasmoid
import org.kde.taskmanager as TaskManager
import "utils.js" as Utils

PlasmoidItem {
    id: root

    property TaskManager.TasksModel tasksModel
    property real elementHeight: height - plasmoid.configuration.widgetMargins * 2
    property real buttonMargins: plasmoid.configuration.widgetButtonsMargins
    property real buttonWidth: plasmoid.configuration.widgetButtonsAspectRatio / 100 * buttonHeight
    property real buttonHeight: elementHeight - buttonMargins * 2
    property var widgetAlignment: plasmoid.configuration.widgetHorizontalAlignment | plasmoid.configuration.widgetVerticalAlignment
    property KWinConfig kWinConfig
    property bool widgetHovered: widgetHoverHandler.hovered

    signal invokeKWinShortcut(string shortcut)

    Plasmoid.constraintHints: Plasmoid.CanFillArea
    Layout.fillWidth: plasmoid.configuration.widgetFillWidth
    preferredRepresentation: fullRepresentation
    onInvokeKWinShortcut: function (shortcut) {
        if (tasksModel.hasActiveWindow)
            tasksModel.activeWindow.actionCall(ActiveWindow.Action.Activate);
        kWinConfig.invokeKWinShortcut(shortcut);
    }
    Plasmoid.contextualActions: [
        PlasmaCore.Action {
            text: i18n("Ma&ximize")
            enabled: tasksModel.activeWindow.maximizable
            checked: tasksModel.activeWindow.maximized
            icon.name: "window-maximize"
            checkable: true
            onTriggered: tasksModel.activeWindow.actionCall(ActiveWindow.Action.Maximize)
        },
        PlasmaCore.Action {
            text: i18n("Mi&nimize")
            enabled: tasksModel.activeWindow.minimizable
            icon.name: "window-minimize"
            checkable: false
            onTriggered: tasksModel.activeWindow.actionCall(ActiveWindow.Action.Minimize)
        },
        PlasmaCore.Action {
            text: i18n("Keep &Above Others")
            checked: tasksModel.activeWindow.keepAbove
            icon.name: "window-keep-above"
            checkable: true
            onTriggered: tasksModel.activeWindow.actionCall(ActiveWindow.Action.KeepAbove)
        },
        PlasmaCore.Action {
            text: i18n("Keep &Below Others")
            checked: tasksModel.activeWindow.keepBelow
            icon.name: "window-keep-below"
            checkable: true
            onTriggered: tasksModel.activeWindow.actionCall(ActiveWindow.Action.KeepBelow)
        },
        PlasmaCore.Action {
            text: i18n("&Fullscreen")
            enabled: tasksModel.activeWindow.fullScreenable
            checked: tasksModel.activeWindow.fullScreen
            icon.name: "view-fullscreen"
            checkable: true
            onTriggered: tasksModel.activeWindow.actionCall(ActiveWindow.Action.FullScreen)
        },
        PlasmaCore.Action {
            text: i18n("&Move")
            icon.name: "transform-move"
            enabled: tasksModel.activeTask.movable
            checkable: false
            onTriggered: tasksModel.activeWindow.actionCall(ActiveWindow.Action.Move)
        },
        PlasmaCore.Action {
            text: i18n("&Resize")
            icon.name: "image-resize-symbolic"
            enabled: tasksModel.activeTask.resizable
            checkable: false
            onTriggered: tasksModel.activeWindow.actionCall(ActiveWindow.Action.Resize)
        },
        PlasmaCore.Action {
            text: i18n("&Close")
            icon.name: "window-close"
            enabled: tasksModel.activeTask.closable
            checkable: false
            onTriggered: tasksModel.activeWindow.actionCall(ActiveWindow.Action.Close)
        }
    ]

    Component {
        id: widgetElementLoaderDelegate

        Loader {
            id: widgetElementLoader

            required property var modelData
            property bool repeaterVisible: false

            onLoaded: function () {
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
                case WidgetElement.Type.Spacer:
                    return spacerIcon;
                }
            }

            Binding {
                when: status === Loader.Ready
                widgetElementLoader.visible: repeaterVisible && (plasmoid.configuration.widgetElementsDisabledMode === WidgetElement.DisabledMode.Hide ? item.enabled : true)
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
            Layout.preferredWidth: root.buttonWidth
            Layout.preferredHeight: root.buttonHeight
            buttonType: modelData.windowControlButtonType
            themeName: plasmoid.configuration.widgetButtonsAuroraeTheme
            iconTheme: plasmoid.configuration.widgetButtonsIconsTheme
            animationDuration: plasmoid.configuration.widgetButtonsAnimation
            onActionCall: action => {
                return tasksModel.activeWindow.actionCall(action);
            }
            enabled: tasksModel.hasActiveWindow && tasksModel.activeWindow.actionSupported(action) && (!plasmoid.configuration.disableButtonsForNotHoveredWidget || root.widgetHovered)
            checked: tasksModel.hasActiveWindow && tasksModel.activeWindow.buttonChecked(modelData.windowControlButtonType)
            active: tasksModel.hasActiveWindow && tasksModel.activeWindow.active
        }
    }

    Component {
        id: windowIcon

        Kirigami.Icon {
            property var modelData

            height: root.elementHeight
            Layout.alignment: root.widgetAlignment
            width: height
            source: tasksModel.activeWindow.icon || "window"
            enabled: tasksModel.hasActiveWindow && !!tasksModel.activeWindow.icon

            WidgetDragHandler {
                Component.onCompleted: {
                    invokeKWinShortcut.connect(root.invokeKWinShortcut);
                }
            }

            WidgetTapHandler {
                Component.onCompleted: {
                    invokeKWinShortcut.connect(root.invokeKWinShortcut);
                }
            }

            WidgetWheelHandler {
                orientation: Qt.Vertical
                Component.onCompleted: {
                    invokeKWinShortcut.connect(root.invokeKWinShortcut);
                }
            }

            WidgetWheelHandler {
                orientation: Qt.Horizontal
                Component.onCompleted: {
                    invokeKWinShortcut.connect(root.invokeKWinShortcut);
                }
            }
        }
    }

    Component {
        id: spacerIcon

        Rectangle {
            property var modelData

            height: root.elementHeight
            Layout.alignment: root.widgetAlignment
            width: height / 3
            color: "transparent"
            enabled: tasksModel.hasActiveWindow
        }
    }

    Component {
        id: windowTitle

        PlasmaComponents.Label {
            id: windowTitleLabel

            property var modelData
            property bool empty: text === undefined || text === ""
            property bool hideEmpty: empty && plasmoid.configuration.windowTitleHideEmpty
            property int windowTitleSource: plasmoid.configuration.overrideElementsMaximized && tasksModel.activeWindow.maximized ? plasmoid.configuration.windowTitleSourceMaximized : plasmoid.configuration.windowTitleSource

            function titleText(windowTitleSource) {
                switch (windowTitleSource) {
                case 0:
                    return tasksModel.activeWindow.appName;
                case 1:
                    return tasksModel.activeWindow.decoration;
                case 2:
                    return tasksModel.activeWindow.genericAppName;
                case 3:
                    return plasmoid.configuration.windowTitleUndefined;
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
            text: titleText(windowTitleSource) || plasmoid.configuration.windowTitleUndefined
            font.pointSize: plasmoid.configuration.windowTitleFontSize
            font.bold: plasmoid.configuration.windowTitleFontBold
            fontSizeMode: plasmoid.configuration.windowTitleFontSizeMode
            maximumLineCount: 1
            elide: Text.ElideRight
            wrapMode: Text.WrapAnywhere
            enabled: tasksModel.hasActiveWindow

            WidgetDragHandler {
                Component.onCompleted: {
                    invokeKWinShortcut.connect(root.invokeKWinShortcut);
                }
            }

            WidgetTapHandler {
                Component.onCompleted: {
                    invokeKWinShortcut.connect(root.invokeKWinShortcut);
                }
            }

            WidgetWheelHandler {
                orientation: Qt.Vertical
                Component.onCompleted: {
                    invokeKWinShortcut.connect(root.invokeKWinShortcut);
                }
            }

            WidgetWheelHandler {
                orientation: Qt.Horizontal
                Component.onCompleted: {
                    invokeKWinShortcut.connect(root.invokeKWinShortcut);
                }
            }
        }
    }

    PlasmaCore.ToolTipArea {
        anchors.fill: parent
        active: tasksModel.hasActiveWindow
        mainText: tasksModel.activeWindow.genericAppName || ""
    }

    kWinConfig: KWinConfig {
        Component.onCompleted: updateKWinShortcutNames()
    }

    tasksModel: ActiveTasksModel {
        id: tasksModel
    }

    HoverHandler {
        id: widgetHoverHandler
        enabled: plasmoid.configuration.disableButtonsForNotHoveredWidget
    }

    fullRepresentation: RowLayout {
        id: widgetRow

        spacing: plasmoid.configuration.widgetSpacing
        Layout.margins: plasmoid.configuration.widgetMargins
        Layout.fillWidth: plasmoid.configuration.widgetFillWidth

        Rectangle {
            id: emptyWidgetPlaceholder

            color: "transparent"
            Layout.maximumWidth: Kirigami.Units.smallSpacing
            Layout.minimumWidth: Kirigami.Units.smallSpacing
            visible: widgetRow.Layout.minimumWidth <= Kirigami.Units.smallSpacing
        }

        Repeater {
            id: widgetElementsRepeater
            property var elements: plasmoid.configuration.widgetElements

            onElementsChanged: function () {
                let array = [];
                for (var i = 0; i < elements.length; i++) {
                    array.push(Utils.widgetElementModelFromName(elements[i]));
                }
                model = array;
            }
            model: []
            delegate: widgetElementLoaderDelegate
            visible: !plasmoid.configuration.overrideElementsMaximized || !tasksModel.activeWindow.maximized
            onItemAdded: function (index, item) {
                item.repeaterVisible = Qt.binding(function () {
                    return visible;
                });
            }
        }

        Repeater {
            property var elements: plasmoid.configuration.overrideElementsMaximized ? plasmoid.configuration.widgetElementsMaximized : []

            onElementsChanged: function () {
                let array = [];
                for (var i = 0; i < elements.length; i++) {
                    array.push(Utils.widgetElementModelFromName(elements[i]));
                }
                model = array;
            }
            model: []
            delegate: widgetElementLoaderDelegate
            visible: !widgetElementsRepeater.visible
            onItemAdded: function (index, item) {
                item.repeaterVisible = Qt.binding(function () {
                    return visible;
                });
            }
        }
    }
}
