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
    property real widgetHeight: (vertical ? width : height)
    property real elementHeight: widgetHeight - plasmoid.configuration.widgetMargins * 2
    property real buttonMargins: plasmoid.configuration.widgetButtonsMargins
    property real buttonWidth: plasmoid.configuration.widgetButtonsAspectRatio / 100 * buttonHeight
    property real buttonHeight: elementHeight - buttonMargins * 2
    property var widgetAlignment: plasmoid.configuration.widgetHorizontalAlignment | plasmoid.configuration.widgetVerticalAlignment
    property KWinConfig kWinConfig
    property bool widgetHovered: widgetHoverHandler.hovered
    property bool vertical: plasmoid.formFactor === PlasmaCore.Types.Vertical
    property bool leftEdgeLocation: plasmoid.location === PlasmaCore.Types.LeftEdge

    signal invokeKWinShortcut(string shortcut)

    Plasmoid.constraintHints: Plasmoid.CanFillArea
    Layout.fillWidth: !vertical && plasmoid.configuration.widgetFillWidth
    Layout.fillHeight: vertical && plasmoid.configuration.widgetFillWidth
    preferredRepresentation: fullRepresentation
    onInvokeKWinShortcut: function (shortcut) {
        if (tasksModel.hasActiveWindow)
            tasksModel.activeWindow.actionCall(ActiveWindow.Action.Activate);
        kWinConfig.invokeKWinShortcut(shortcut);
    }

    ContextualActions {}

    Component {
        id: widgetElementLoaderDelegate

        Loader {
            id: widgetElementLoader

            required property int index
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

    fullRepresentation: Item {
        id: representationProxy

        Layout.fillWidth: root.vertical ? null : plasmoid.configuration.widgetFillWidth
        Layout.fillHeight: root.vertical ? plasmoid.configuration.widgetFillWidth : null

        Layout.minimumWidth: root.vertical ? widgetRow.Layout.minimumHeight : widgetRow.Layout.minimumWidth
        Layout.minimumHeight: root.vertical ? widgetRow.Layout.minimumWidth : widgetRow.Layout.minimumHeight

        Layout.maximumWidth: root.vertical ? widgetRow.Layout.maximumHeight : widgetRow.Layout.maximumWidth
        Layout.maximumHeight: root.vertical ? widgetRow.Layout.maximumWidth : widgetRow.Layout.maximumHeight

        RowLayout {
            id: widgetRow

            spacing: plasmoid.configuration.widgetSpacing
            anchors.left: parent.left
            anchors.verticalCenter: root.vertical ? undefined : parent.verticalCenter
            anchors.horizontalCenter: root.vertical ? parent.horizontalCenter : undefined
            width: root.vertical ? representationProxy.height : representationProxy.width
            height: root.vertical ? representationProxy.width : representationProxy.height

            transform: [
                Rotation {
                    angle: root.vertical ? 90 : 0
                    origin.x: widgetHeight / 2 - plasmoid.configuration.widgetMargins / 2 // IDK why
                    origin.y: widgetHeight / 2 - plasmoid.configuration.widgetMargins / 2
                },
                Rotation {
                    angle: root.leftEdgeLocation ? 180 : 0
                    origin.x: width / 2
                    origin.y: height / 2
                }
            ]

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
}
