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

    signal actionCall(int action)

    function updateIconState() {
        iconState = WCB.calculateIconState(button);
    }

    onEnabledChanged: Qt.callLater(updateIconState)
    onActiveChanged: Qt.callLater(updateIconState)
    onHoveredChanged: Qt.callLater(updateIconState)
    onPressedChanged: Qt.callLater(updateIconState)
    onCheckedChanged: Qt.callLater(updateIconState)

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
        onClicked: function () {
            button.actionCall(WCB.getAction(button.buttonType));
        }
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
