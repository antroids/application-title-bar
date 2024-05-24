/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

const statePropertiesMap = [
    { active: true, pressed: false, checked: false, hovered: false, disabled: false }, // Active
    { active: true, pressed: false, checked: false, hovered: true, disabled: false }, // ActiveHover
    { active: true, pressed: true, checked: false, hovered: false, disabled: false }, // ActivePressed
    { active: true, pressed: false, checked: true, hovered: false, disabled: false }, // ActiveChecked
    { active: true, pressed: false, checked: true, hovered: true, disabled: false }, // ActiveHoverChecked
    { active: true, pressed: false, checked: true, hovered: false, disabled: true }, // ActiveCheckedDisabled
    { active: true, pressed: false, checked: false, hovered: false, disabled: true }, // ActiveDisabled
    { active: false, pressed: false, checked: false, hovered: false, disabled: false }, // Inactive
    { active: false, pressed: false, checked: false, hovered: true, disabled: false }, // InactiveHover
    { active: false, pressed: true, checked: false, hovered: false, disabled: false }, // InactivePressed
    { active: false, pressed: false, checked: true, hovered: false, disabled: false }, // InactiveChecked
    { active: false, pressed: false, checked: true, hovered: true, disabled: false }, // InactiveHoverChecked
    { active: false, pressed: false, checked: true, hovered: false, disabled: true }, // InactiveCheckedDisabled
    { active: false, pressed: false, checked: false, hovered: false, disabled: true }, // InactiveDisabled
];

function calculateIconState(button) {
    if (button.active) {
        if (button.pressed)
            return WindowControlButton.IconState.ActivePressed;
        else if (button.checked && !button.enabled)
            return WindowControlButton.IconState.ActiveCheckedDisabled;
        else if (button.checked && button.hovered)
            return WindowControlButton.IconState.ActiveHoverChecked;
        else if (button.checked)
            return WindowControlButton.IconState.ActiveChecked;
        else if (button.hovered)
            return WindowControlButton.IconState.ActiveHover;
        else if (!button.enabled)
            return WindowControlButton.IconState.ActiveDisabled;
        else
            return WindowControlButton.IconState.Active;
    } else {
        if (button.pressed)
            return WindowControlButton.IconState.InactivePressed;
        else if (button.checked && !button.enabled)
            return WindowControlButton.IconState.InactiveCheckedDisabled;
        else if (button.checked && button.hovered)
            return WindowControlButton.IconState.InactiveHoverChecked;
        else if (button.checked)
            return WindowControlButton.IconState.InactiveChecked;
        else if (button.hovered)
            return WindowControlButton.IconState.InactiveHover;
        else if (!button.enabled)
            return WindowControlButton.IconState.InactiveDisabled;
        else
            return WindowControlButton.IconState.Inactive;
    }
}

function getAction(buttonType) {
    switch (buttonType) {
        case WindowControlButton.Type.MinimizeButton:
            return ActiveWindow.Action.Minimize;
        case WindowControlButton.Type.MaximizeButton:
            return ActiveWindow.Action.Maximize;
        case WindowControlButton.Type.RestoreButton:
            return ActiveWindow.Action.Maximize;
        case WindowControlButton.Type.CloseButton:
            return ActiveWindow.Action.Close;
        case WindowControlButton.Type.AllDesktopsButton:
            return ActiveWindow.Action.AllDesktops;
        case WindowControlButton.Type.KeepAboveButton:
            return ActiveWindow.Action.KeepAbove;
        case WindowControlButton.Type.KeepBelowButton:
            return ActiveWindow.Action.KeepBelow;
        case WindowControlButton.Type.ShadeButton:
            return ActiveWindow.Action.Shade;
        case WindowControlButton.Type.HelpButton:
            return ActiveWindow.Action.Help;
        case WindowControlButton.Type.MenuButton:
            return ActiveWindow.Action.Menu;
        case WindowControlButton.Type.AppMenuButton:
            return ActiveWindow.Action.AppMenu;
        default:
            return "";
    }
}

function getButtonComponentSourcePath(iconTheme) {
    switch (iconTheme) {
        case WindowControlButton.IconTheme.Breeze:
            return "theme/BreezeWindowControlButton.qml";
        case WindowControlButton.IconTheme.Oxygen:
            return "theme/OxygenWindowControlButton.qml";
        case WindowControlButton.IconTheme.Aurorae:
            return "theme/AuroraeWindowControlButton.qml";
        default:
            return "theme/PlasmaWindowControlButton.qml";
    }
}