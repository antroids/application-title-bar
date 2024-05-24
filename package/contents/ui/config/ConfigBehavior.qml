/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import "../"
import "../utils.js" as Utils
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

KCM.SimpleKCM {
    id: page

    property alias cfg_widgetActiveTaskSource: widgetActiveTaskSource.currentIndex
    property alias cfg_widgetActiveTaskFilterByActivity: widgetActiveTaskFilterByActivity.checked
    property alias cfg_widgetActiveTaskFilterByScreen: widgetActiveTaskFilterByScreen.checked
    property alias cfg_widgetActiveTaskFilterByVirtualDesktop: widgetActiveTaskFilterByVirtualDesktop.checked
    property alias cfg_widgetActiveTaskFilterNotMaximized: widgetActiveTaskFilterNotMaximized.checked
    property alias cfg_disableButtonsForNotHoveredWidget: disableButtonsForNotHoveredWidget.checked
    property alias cfg_windowTitleDragEnabled: windowTitleDragEnabled.checked
    property alias cfg_widgetMouseAreaClickEnabled: widgetMouseAreaClickEnabled.checked
    property alias cfg_widgetMouseAreaWheelEnabled: widgetMouseAreaWheelEnabled.checked
    property alias cfg_windowTitleDragOnlyMaximized: windowTitleDragOnlyMaximized.checked
    property alias cfg_windowTitleDragThreshold: windowTitleDragThreshold.value
    property string cfg_widgetMouseAreaLeftDragAction
    property string cfg_widgetMouseAreaLeftClickAction
    property string cfg_widgetMouseAreaLeftDoubleClickAction
    property string cfg_widgetMouseAreaLeftLongPressAction
    property string cfg_widgetMouseAreaMiddleDragAction
    property string cfg_widgetMouseAreaMiddleClickAction
    property string cfg_widgetMouseAreaMiddleDoubleClickAction
    property string cfg_widgetMouseAreaMiddleLongPressAction
    property alias cfg_widgetMouseAreaWheelFirstEventDistance: widgetMouseAreaWheelFirstEventDistance.value
    property alias cfg_widgetMouseAreaWheelNextEventDistance: widgetMouseAreaWheelNextEventDistance.value
    property string cfg_widgetMouseAreaWheelUpAction
    property string cfg_widgetMouseAreaWheelDownAction
    property string cfg_widgetMouseAreaWheelLeftAction
    property string cfg_widgetMouseAreaWheelRightAction

    Kirigami.FormLayout {
        anchors.left: parent.left
        anchors.right: parent.right

        KWinConfig {
            id: kWinConfig

            onBorderlessMaximizedWindowsChanged: {
                borderlessMaximizedWindowsCheckBox.checked = borderlessMaximizedWindows;
                borderlessMaximizedWindowsCheckBox.enabled = kWinConfig.kwriteconfigCommandName !== "" && kWinConfig.kreadconfigCommandName !== "";
            }
        }

        Kirigami.InlineMessage {
            anchors.left: parent.left
            anchors.right: parent.right
            text: i18n("Some functionality is unsupported or can work unstable in X11 sessions.")
            type: Kirigami.MessageType.Warning
            visible: Utils.isX11()
        }

        Kirigami.InlineMessage {
            anchors.left: parent.left
            anchors.right: parent.right
            text: "QDbus command is missing in the system!"
            type: Kirigami.MessageType.Error
            visible: kWinConfig.qdbusCommandName === ""
        }

        Kirigami.InlineMessage {
            anchors.left: parent.left
            anchors.right: parent.right
            text: "Kwriteconfig command is missing in the system!"
            type: Kirigami.MessageType.Error
            visible: kWinConfig.kwriteconfigCommandName === ""
        }

        Kirigami.InlineMessage {
            anchors.left: parent.left
            anchors.right: parent.right
            text: "Kreadconfig command is missing in the system!"
            type: Kirigami.MessageType.Error
            visible: kWinConfig.kreadconfigCommandName === ""
        }

        Kirigami.InlineMessage {
            anchors.left: parent.left
            anchors.right: parent.right
            text: kWinConfig.lastError
            type: Kirigami.MessageType.Error
            visible: kWinConfig.lastError !== ""
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Active task source:")

            ComboBox {
                id: widgetActiveTaskSource

                model: [i18n("Active task"), i18n("Last active task"), i18n("Last active maximized task")]
            }

            KCM.ContextualHelpButton {
                toolTipText: i18n("<p>How to obtain the active task from tasks manager: <br><b>Active task</b>: current active task after filtering. The widget will be disabled if the current active task is on another screen, regardless whether there are another tasks on this screen or not.<br/><b>Last active task</b>: show widget for the last active task after filters applied.<br/><b>Last active maximized task</b>: show widget for the last active maximized task after filters applied.</p>")
            }
        }

        CheckBox {
            id: borderlessMaximizedWindowsCheckBox

            Kirigami.FormData.label: i18n("Borderless maximized windows:")
            text: i18n("enabled (Will be applied immediately)")
            enabled: false
            onToggled: function () {
                enabled = false;
                kWinConfig.setBorderlessMaximizedWindows(checked);
            }
        }

        CheckBox {
            id: widgetActiveTaskFilterByActivity

            Kirigami.FormData.label: i18n("Filter active task by activity:")
            text: i18n("enabled")
        }

        CheckBox {
            id: widgetActiveTaskFilterByScreen

            Kirigami.FormData.label: i18n("Filter active task by screen:")
            text: i18n("enabled")
        }

        CheckBox {
            id: widgetActiveTaskFilterByVirtualDesktop

            Kirigami.FormData.label: i18n("Filter active task by virtual desktop:")
            text: i18n("enabled")
        }

        CheckBox {
            id: widgetActiveTaskFilterNotMaximized

            enabled: widgetActiveTaskSource.currentIndex !== ActiveTasksModel.ActiveTaskSource.LastActiveMaximized
            Kirigami.FormData.label: i18n("Disable for not maximized:")
            text: i18n("enabled")
        }

        CheckBox {
            id: disableButtonsForNotHoveredWidget

            Kirigami.FormData.label: i18n("Disable buttons for not hovered widget:")
            text: i18n("enabled")
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Mouse area drag")
        }

        CheckBox {
            id: windowTitleDragEnabled

            text: i18n("enabled")
        }

        CheckBox {
            id: windowTitleDragOnlyMaximized

            enabled: windowTitleDragEnabled.checked
            Kirigami.FormData.label: i18n("Only maximized:")
            text: i18n("enabled")
        }

        SpinBox {
            id: windowTitleDragThreshold

            enabled: windowTitleDragEnabled.checked
            Kirigami.FormData.label: i18n("Threshold:")
            from: 0
            to: 512
        }

        Kirigami.InlineMessage {
            anchors.left: parent.left
            anchors.right: parent.right
            text: i18n("Window Move action is incompatible with Mouse Drag in X11 sessions.")
            type: Kirigami.MessageType.Error
            visible: Utils.isX11() && leftButtonDragAction.currentValue == "Window Move"
        }

        KWinShortcutComboBox {
            id: leftButtonDragAction

            label: i18n("Left button drag:")
            enabled: windowTitleDragEnabled.checked
            initialValue: cfg_widgetMouseAreaLeftDragAction
            onActivated: cfg_widgetMouseAreaLeftDragAction = currentValue
        }

        Kirigami.InlineMessage {
            anchors.left: parent.left
            anchors.right: parent.right
            text: i18n("Window Move action is incompatible with Mouse Drag in X11 sessions.")
            type: Kirigami.MessageType.Error
            visible: Utils.isX11() && middleButtonDragAction.currentValue == "Window Move"
        }

        KWinShortcutComboBox {
            id: middleButtonDragAction

            label: i18n("Middle button drag:")
            enabled: windowTitleDragEnabled.checked
            initialValue: cfg_widgetMouseAreaMiddleDragAction
            onActivated: cfg_widgetMouseAreaMiddleDragAction = currentValue
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Mouse area click")
        }

        CheckBox {
            id: widgetMouseAreaClickEnabled

            text: i18n("enabled")
        }

        KWinShortcutComboBox {
            enabled: widgetMouseAreaClickEnabled.checked
            label: i18n("Left button click:")
            initialValue: cfg_widgetMouseAreaLeftClickAction
            onActivated: cfg_widgetMouseAreaLeftClickAction = currentValue
        }

        KWinShortcutComboBox {
            enabled: widgetMouseAreaClickEnabled.checked
            label: i18n("Left button double-click:")
            initialValue: cfg_widgetMouseAreaLeftDoubleClickAction
            onActivated: cfg_widgetMouseAreaLeftDoubleClickAction = currentValue
        }

        KWinShortcutComboBox {
            enabled: widgetMouseAreaClickEnabled.checked
            label: i18n("Left button long press:")
            initialValue: cfg_widgetMouseAreaLeftLongPressAction
            onActivated: cfg_widgetMouseAreaLeftLongPressAction = currentValue
        }

        KWinShortcutComboBox {
            enabled: widgetMouseAreaClickEnabled.checked
            label: i18n("Middle button click:")
            initialValue: cfg_widgetMouseAreaMiddleClickAction
            onActivated: cfg_widgetMouseAreaMiddleClickAction = currentValue
        }

        KWinShortcutComboBox {
            enabled: widgetMouseAreaClickEnabled.checked
            label: i18n("Middle button double-click:")
            initialValue: cfg_widgetMouseAreaMiddleDoubleClickAction
            onActivated: cfg_widgetMouseAreaMiddleDoubleClickAction = currentValue
        }

        KWinShortcutComboBox {
            enabled: widgetMouseAreaClickEnabled.checked
            label: i18n("Middle button long press:")
            initialValue: cfg_widgetMouseAreaMiddleLongPressAction
            onActivated: cfg_widgetMouseAreaMiddleLongPressAction = currentValue
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Mouse area wheel")
        }

        CheckBox {
            id: widgetMouseAreaWheelEnabled

            text: i18n("enabled")
        }

        SpinBox {
            id: widgetMouseAreaWheelFirstEventDistance

            enabled: widgetMouseAreaWheelEnabled.checked
            Kirigami.FormData.label: i18n("First event distance:")
            from: 0
            to: 4096
        }

        SpinBox {
            id: widgetMouseAreaWheelNextEventDistance

            enabled: widgetMouseAreaWheelEnabled.checked
            Kirigami.FormData.label: i18n("Next event distance:")
            from: 0
            to: 4096
        }

        KWinShortcutComboBox {
            enabled: widgetMouseAreaWheelEnabled.checked
            label: i18n("Wheel up:")
            initialValue: cfg_widgetMouseAreaWheelUpAction
            onActivated: cfg_widgetMouseAreaWheelUpAction = currentValue
        }

        KWinShortcutComboBox {
            enabled: widgetMouseAreaWheelEnabled.checked
            label: i18n("Wheel down:")
            initialValue: cfg_widgetMouseAreaWheelDownAction
            onActivated: cfg_widgetMouseAreaWheelDownAction = currentValue
        }

        KWinShortcutComboBox {
            enabled: widgetMouseAreaWheelEnabled.checked
            label: i18n("Wheel left:")
            initialValue: cfg_widgetMouseAreaWheelLeftAction
            onActivated: cfg_widgetMouseAreaWheelLeftAction = currentValue
        }

        KWinShortcutComboBox {
            enabled: widgetMouseAreaWheelEnabled.checked
            label: i18n("Wheel right:")
            initialValue: cfg_widgetMouseAreaWheelRightAction
            onActivated: cfg_widgetMouseAreaWheelRightAction = currentValue
        }
    }
}
