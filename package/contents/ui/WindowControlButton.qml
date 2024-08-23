/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtCore
import QtQuick
import "windowControlButton.js" as WCB

Item {
    id: button

    enum Type {
        MinimizeButton,
        MaximizeButton,
        RestoreButton,
        CloseButton,
        AllDesktopsButton,
        KeepAboveButton,
        KeepBelowButton,
        ShadeButton,
        HelpButton,
        MenuButton,
        AppMenuButton
    }

    function getAccessibleName(type) {
        switch (type) {
        case WindowControlButton.Type.MinimizeButton:
            return "Minimize";
        case WindowControlButton.Type.MaximizeButton:
            return "Maximize";
        case WindowControlButton.Type.RestoreButton:
            return "Restore";
        case WindowControlButton.Type.CloseButton:
            return "Close";
        case WindowControlButton.Type.AllDesktopsButton:
            return "All Desktops";
        case WindowControlButton.Type.KeepAboveButton:
            return "Keep Above";
        case WindowControlButton.Type.KeepBelowButton:
            return "Keep Below";
        case WindowControlButton.Type.ShadeButton:
            return "Shade";
        case WindowControlButton.Type.HelpButton:
            return "Help";
        case WindowControlButton.Type.MenuButton:
            return "Menu";
        case WindowControlButton.Type.AppMenuButton:
            return "Application Menu";
        default:
            return "";
        }
    }

    /*
    *  Active* - icons for active windows.
    *  *Disabled - disabled non-interactive buttons
    */
    enum IconState {
        Active,
        ActiveHover,
        ActivePressed,
        ActiveChecked,
        ActiveHoverChecked,
        ActiveCheckedDisabled,
        ActiveDisabled,
        Inactive,
        InactiveHover,
        InactivePressed,
        InactiveChecked,
        InactiveHoverChecked,
        InactiveCheckedDisabled,
        InactiveDisabled
    }

    enum IconTheme {
        Plasma,
        Breeze,
        Aurorae,
        Oxygen
    }

    property string themeName
    property int buttonType
    property string action: WCB.getAction(buttonType)
    property bool active: true
    property bool hovered: false
    property bool pressed: false
    property bool checked: false
    property int iconTheme: WindowControlButton.IconTheme.Plasma
    property int animationDuration: 100
    property MouseArea mouseArea: buttonMouseArea
    property int iconState: WindowControlButton.IconState.Active
    property alias mouseAreaEnabled: buttonMouseArea.enabled

    Accessible.role: Accessible.Button
    Accessible.focusable: true
    Accessible.name: i18n(getAccessibleName(buttonType))
    Accessible.onPressAction: buttonActionCall()
    Accessible.checked: checked
    Accessible.pressed: pressed

    signal actionCall(int action)

    function updateIconState() {
        iconState = WCB.calculateIconState(button);
    }

    onEnabledChanged: Qt.callLater(updateIconState)
    onActiveChanged: Qt.callLater(updateIconState)
    onHoveredChanged: Qt.callLater(updateIconState)
    onPressedChanged: Qt.callLater(updateIconState)
    onCheckedChanged: Qt.callLater(updateIconState)

    function buttonActionCall() {
        button.actionCall(WCB.getAction(button.buttonType));
    }

    MouseArea {
        id: buttonMouseArea

        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        enabled: button.enabled
        hoverEnabled: true
        onEntered: button.hovered = true
        onExited: button.hovered = false
        onPressed: button.pressed = true
        onReleased: button.pressed = false
        onClicked: buttonActionCall()
    }

    Repeater {
        id: iconStateRepeater
        anchors.fill: parent
        model: WCB.statePropertiesMap

        Loader {
            id: controlButtonDelegeate
            required property int index
            required property var modelData
            anchors.fill: parent
            source: WCB.getButtonComponentSourcePath(button.iconTheme)

            onLoaded: function () {
                let buttonComponent = item;
                let buttonState = index;
                buttonComponent.hovered = modelData.hovered;
                buttonComponent.checked = modelData.checked;
                buttonComponent.pressed = modelData.pressed;
                buttonComponent.active = modelData.active;
                buttonComponent.disabled = modelData.disabled;
                buttonComponent.buttonType = Qt.binding(function () {
                    return button.buttonType;
                });
                buttonComponent.animationDuration = Qt.binding(function () {
                    return button.animationDuration;
                });
                buttonComponent.opacity = Qt.binding(function () {
                    return buttonState == button.iconState ? 1 : 0;
                });
                if (iconTheme === WindowControlButton.IconTheme.Aurorae) {
                    buttonComponent.themeName = Qt.binding(function () {
                        return button.themeName;
                    });
                }
            }
        }
    }
}
