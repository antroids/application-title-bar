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
    property real buttonHeight: elementHeight - buttonMargins * 2
    property real buttonWidth: plasmoid.configuration.widgetButtonsAspectRatio / 100 * buttonHeight
    property var widgetAlignment: plasmoid.configuration.widgetHorizontalAlignment | plasmoid.configuration.widgetVerticalAlignment
    property KWinConfig kWinConfig
    property bool widgetHovered: widgetHoverHandler.hovered
    property bool vertical: plasmoid.formFactor === PlasmaCore.Types.Vertical
    property bool leftEdgeLocation: plasmoid.location === PlasmaCore.Types.LeftEdge
    property bool hideWidget: !tasksModel.hasActiveWindow && plasmoid.configuration.widgetElementsDisabledMode === WidgetElement.DisabledMode.Hide
    property bool editMode: Plasmoid.containment.corona?.editMode ?? false

    signal invokeKWinShortcut(string shortcut)
    signal widgetElementsLayoutUpdated

    Plasmoid.constraintHints: Plasmoid.CanFillArea
    Plasmoid.status: hideWidget
        ? PlasmaCore.Types.HiddenStatus
        : PlasmaCore.Types.ActiveStatus
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
                widgetElementLoader.Layout.preferredWidthChanged.connect(root.widgetElementsLayoutUpdated);
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
            width: height
            Layout.alignment: root.widgetAlignment
            Layout.preferredWidth: width
            source: tasksModel.activeWindow.icon || "window"
            enabled: tasksModel.hasActiveWindow && !!tasksModel.activeWindow.icon

            MouseHandlers {
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
            width: height / 3
            Layout.alignment: root.widgetAlignment
            Layout.preferredWidth: width
            color: "transparent"
            enabled: tasksModel.hasActiveWindow

            MouseHandlers {
                Component.onCompleted: {
                    invokeKWinShortcut.connect(root.invokeKWinShortcut);
                }
            }
        }
    }

    Component {
        id: windowTitle

        PlasmaComponents.Label {
            id: windowTitleLabel

            readonly property var horizontalAlignmentValues: [Text.AlignLeft, Text.AlignRight, Text.AlignHCenter, Text.AlignJustify]
            readonly property var verticalAlignmentValues: [Text.AlignTop, Text.AlignBottom, Text.AlignVCenter]

            property var modelData
            property bool empty: text === undefined || text === ""
            property bool hideEmpty: empty && plasmoid.configuration.windowTitleHideEmpty
            property int windowTitleSource: plasmoid.configuration.overrideElementsMaximized && tasksModel.activeWindow.maximized ? plasmoid.configuration.windowTitleSourceMaximized : plasmoid.configuration.windowTitleSource
            property var titleTextReplacements: []

            Layout.minimumWidth: plasmoid.configuration.windowTitleMinimumWidth
            Layout.maximumWidth: !hideEmpty ? plasmoid.configuration.windowTitleMaximumWidth : 0
            Layout.alignment: root.widgetAlignment
            Layout.fillWidth: plasmoid.configuration.widgetFillWidth
            Layout.fillHeight: true
            Layout.preferredWidth: textMetrics.advanceWidth + leftPadding + rightPadding + 1 // Magic number
            text: titleText(windowTitleSource) || plasmoid.configuration.windowTitleUndefined
            font.pointSize: plasmoid.configuration.windowTitleFontSize
            font.bold: plasmoid.configuration.windowTitleFontBold
            fontSizeMode: plasmoid.configuration.windowTitleFontSizeMode
            maximumLineCount: 1
            elide: Text.ElideRight
            wrapMode: Text.WrapAnywhere
            enabled: tasksModel.hasActiveWindow
            horizontalAlignment: horizontalAlignmentValues[plasmoid.configuration.windowTitleHorizontalAlignment]
            verticalAlignment: verticalAlignmentValues[plasmoid.configuration.windowTitleVerticalAlignment]

            bottomPadding: !hideEmpty ? plasmoid.configuration.windowTitleMarginsBottom : 0
            leftPadding: !hideEmpty ? plasmoid.configuration.windowTitleMarginsLeft : 0
            rightPadding: !hideEmpty ? plasmoid.configuration.windowTitleMarginsRight : 0
            topPadding: !hideEmpty ? plasmoid.configuration.windowTitleMarginsTop : 0

            Accessible.role: Accessible.TitleBar
            Accessible.name: text

            TextMetrics {
                id: textMetrics
                font: windowTitleLabel.font
                text: windowTitleLabel.text
            }

            Connections {
                target: plasmoid.configuration

                function onTitleReplacementsTypesChanged() {
                    updateTitleTextReplacements();
                }

                function onTitleReplacementsPatternsChanged() {
                    updateTitleTextReplacements();
                }

                function onTitleReplacementsTemplatesChanged() {
                    updateTitleTextReplacements();
                }
            }

            Component.onCompleted: updateTitleTextReplacements()

            MouseHandlers {
                Component.onCompleted: {
                    invokeKWinShortcut.connect(root.invokeKWinShortcut);
                }
            }

            function titleText(windowTitleSource) {
                let titleTextResult = "";
                switch (windowTitleSource) {
                case 0:
                    titleTextResult = tasksModel.activeWindow.appName;
                    break;
                case 1:
                    titleTextResult = tasksModel.activeWindow.decoration;
                    break;
                case 2:
                    titleTextResult = tasksModel.activeWindow.genericAppName;
                    break;
                case 3:
                    titleTextResult = plasmoid.configuration.windowTitleUndefined;
                    break;
                }
                if (titleTextResult) {
                    titleTextResult = Utils.Replacement.applyReplacementList(titleTextResult, titleTextReplacements);
                }
                return titleTextResult;
            }

            function updateTitleTextReplacements() {
                Qt.callLater(_updateTitleTextReplacements);
            }

            function _updateTitleTextReplacements() {
                titleTextReplacements = Utils.Replacement.createReplacementList(plasmoid.configuration.titleReplacementsTypes, plasmoid.configuration.titleReplacementsPatterns, plasmoid.configuration.titleReplacementsTemplates);
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

        Layout.preferredWidth: root.vertical ? widgetRow.Layout.preferredHeight : widgetRow.Layout.preferredWidth
        Layout.preferredHeight: root.vertical ? widgetRow.Layout.preferredWidth : widgetRow.Layout.preferredHeight

        RowLayout {
            id: widgetRow

            spacing: plasmoid.configuration.widgetSpacing
            anchors.left: parent.left
            anchors.verticalCenter: root.vertical ? undefined : parent.verticalCenter
            anchors.horizontalCenter: root.vertical ? parent.horizontalCenter : undefined
            width: root.vertical ? representationProxy.height : representationProxy.width
            height: root.vertical ? representationProxy.width : representationProxy.height

            Accessible.role: Accessible.Grouping
            Accessible.name: i18n("Application title bar")

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

            PlasmaComponents.Label {
                id: editModePlaceholder
                text: Plasmoid.metaData.name
                visible: editMode
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
                id: widgetElementsMaximizedRepeater
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

            Connections {
                target: root

                function onWidgetElementsLayoutUpdated() {
                    var preferredWidth = plasmoid.configuration.widgetFillWidth ? widgetRow.calculatePreferredWidth() : -1;
                    widgetRow.Layout.preferredWidth = preferredWidth;
                }
            }

            function calculatePreferredWidth() {
                var repeater = widgetElementsRepeater.visible ? widgetElementsRepeater : widgetElementsMaximizedRepeater;
                var preferredWidth = (repeater.count - 1) * widgetRow.spacing;
                for (var i = 0; i < repeater.count; i++) {
                    var item = repeater.itemAt(i);
                    preferredWidth += Utils.calculateItemPreferredWidth(item);
                }
                if (preferredWidth < widgetRow.Layout.minimumWidth) {
                    return widgetRow.Layout.minimumWidth;
                } else if (preferredWidth > widgetRow.Layout.maximumWidth) {
                    return widgetRow.Layout.maximumWidth;
                } else {
                    return preferredWidth;
                }
            }
        }
    }
}
