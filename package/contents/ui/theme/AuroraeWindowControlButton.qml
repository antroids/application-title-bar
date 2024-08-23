/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import org.kde.kirigami as Kirigami
import org.kde.ksvg 1.0 as KSvg
import ".."
import "../windowControlButton.js" as WCB

Item {
    id: auroraeControlButton

    anchors.fill: parent

    readonly property var iconStatesPrefixes: ["active", "hover", "pressed", "pressed", "pressed", "deactivated", "deactivated", "inactive", "hover-inactive", "pressed-inactive", "pressed-inactive", "pressed-inactive", "deactivated-inactive", "deactivated-inactive"]
    readonly property string themesPath: "aurorae/themes/"
    readonly property string svgExt: "svg"
    readonly property string svgzExt: "svgz"

    property string themeName
    property int buttonType: WindowControlButton.Type.CloseButton
    property int iconState: calculateAuroraeIconState(this)
    property bool hovered: false
    property bool active: false
    property bool pressed: false
    property bool checked: false
    property bool disabled: false
    property int animationDuration: 0
    property var iconPath: buttonIconPath(buttonType)

    property bool hasActiveHover: iconPath === undefined || iconInfo.hasElementPrefix("hover")
    property bool hasActivePressed: iconPath === undefined || iconInfo.hasElementPrefix("pressed")
    property bool hasActiveChecked: iconPath === undefined || iconInfo.hasElementPrefix("toggled")
    property bool hasActiveDisabled: iconPath === undefined || iconInfo.hasElementPrefix("deactivated")
    property bool hasInactive: iconPath === undefined || iconInfo.hasElementPrefix("inactive")
    property bool hasInactiveHover: iconPath === undefined || iconInfo.hasElementPrefix("hover-inactive")
    property bool hasInactivePressed: iconPath === undefined || iconInfo.hasElementPrefix("pressed-inactive")
    property bool hasInactiveChecked: iconPath === undefined || iconInfo.hasElementPrefix("toggled-inactive")
    property bool hasInactiveDisabled: iconPath === undefined || iconInfo.hasElementPrefix("deactivated-inactive")

    Behavior on opacity {
        NumberAnimation {
            duration: animationDuration
        }
    }

    KSvg.FrameSvg {
        id: iconInfo

        imagePath: iconPath || ""
    }

    Loader {
        id: auroraeIconSvg
        active: !!iconPath
        anchors.fill: parent

        sourceComponent: KSvg.FrameSvgItem {
            anchors.fill: parent
            prefix: iconStatesPrefixes[iconState]
            imagePath: iconPath
            enabledBorders: KSvg.FrameSvgItem.NoBorder
        }
    }
    Loader {
        anchors.fill: parent
        active: !auroraeIconSvg.active
        sourceComponent: PlasmaWindowControlButtonIcon {
            anchors.fill: parent
            buttonType: auroraeControlButton.buttonType
            hovered: auroraeControlButton.hovered
            checked: auroraeControlButton.checked
            pressed: auroraeControlButton.pressed
            active: auroraeControlButton.active
            enabled: !auroraeControlButton.disabled
        }
    }

    function buttonIconPath(type) {
        let buttonName = mapButtonToName(type);
        let relativeIconPath = themesPath + themeName + "/" + buttonName;
        let path = locateAtDataLocations(relativeIconPath + "." + svgExt);
        if (!path)
            path = locateAtDataLocations(relativeIconPath + "." + svgzExt);
        return path;
    }

    function locateAtDataLocations(file) {
        let path = StandardPaths.locate(StandardPaths.GenericDataLocation, file, StandardPaths.LocateFile);
        return path && path.toString() !== "" ? path : undefined;
    }

    // https://invent.kde.org/plasma/kwin/-/blob/master/src/plugins/kdecorations/aurorae/src/qml/AuroraeButton.qml
    function calculateAuroraeIconState(button) {
        if (!button.active) {
            if (button.pressed && button.hasInactivePressed)
                return WindowControlButton.IconState.InactivePressed;
            else if (button.checked && button.hovered && button.hasInactiveChecked && button.hasInactiveHover)
                return WindowControlButton.IconState.InactiveHoverChecked;
            else if (button.checked && button.hasInactiveChecked)
                return WindowControlButton.IconState.InactiveChecked;
            else if (button.hovered && button.hasInactiveHover)
                return WindowControlButton.IconState.InactiveHover;
            else if (!button.enabled && button.hasInactiveDisabled)
                return WindowControlButton.IconState.InactiveDisabled;
            else if (button.hasInactive && !button.pressed && !button.checked && !button.hovered && button.enabled)
                return WindowControlButton.IconState.Inactive;
        }
        if (button.pressed && button.hasActivePressed && (button.active || !button.hasInactivePressed))
            return WindowControlButton.IconState.ActivePressed;
        else if (button.checked && button.hover && button.hasActiveChecked && button.hasActiveHover && (button.active || !button.hasInactiveChecked || !button.hasInactiveHover))
            return WindowControlButton.IconState.ActiveHoverChecked;
        else if (button.checked && button.hasActiveChecked && (button.active || !button.hasInactiveChecked))
            return WindowControlButton.IconState.ActiveChecked;
        else if (button.hovered && button.hasActiveHover && (button.active || !button.hasInactiveHover))
            return WindowControlButton.IconState.ActiveHover;
        else if (!button.enabled && button.hasActiveDisabled && (button.active || !button.hasInactiveDisabled))
            return WindowControlButton.IconState.ActiveDisabled;
        else
            return WindowControlButton.IconState.Active;
    }

    function mapButtonToName(type) {
        switch (type) {
        case WindowControlButton.Type.MinimizeButton:
            return "minimize";
        case WindowControlButton.Type.MaximizeButton:
            return "maximize";
        case WindowControlButton.Type.RestoreButton:
            return "restore";
        case WindowControlButton.Type.CloseButton:
            return "close";
        case WindowControlButton.Type.AllDesktopsButton:
            return "alldesktops";
        case WindowControlButton.Type.KeepAboveButton:
            return "keepabove";
        case WindowControlButton.Type.KeepBelowButton:
            return "keepbelow";
        case WindowControlButton.Type.ShadeButton:
            return "shade";
        case WindowControlButton.Type.HelpButton:
            return "help";
        case WindowControlButton.Type.MenuButton:
            return "menu";
        case WindowControlButton.Type.AppMenuButton:
            return "appmenu";
        default:
            return "";
        }
    }
}
