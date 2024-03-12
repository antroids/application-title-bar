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

    enum IconState {
        Active,
        ActiveHover,
        ActivePressed,
        ActiveDeactivated,
        Inactive,
        InactiveHover,
        InactivePressed,
        InactiveDeactivated
    }

    readonly property var iconStatesPrefixes: ["active", "hover", "pressed", "deactivated", "inactive", "hover-inactive", "pressed-inactive", "deactivated-inactive"]
    property string themesPath: "aurorae/themes/"
    property string themeName
    property string svgExt: "svg"
    property string svgzExt: "svgz"
    property int buttonType
    property bool active: true
    property bool hovered: false
    property bool pressed: false
    property bool toggled: false
    property var iconPath: buttonIconPath(buttonType)
    property var fallbackIcon: "window-" + mapButtonToName(buttonType)
    property int animationDuration: 100
    property MouseArea mouseArea: buttonMouseArea
    property bool hasActiveHover: iconPath === undefined || iconInfo.hasElementPrefix("hover")
    property bool hasActivePressed: iconPath === undefined || iconInfo.hasElementPrefix("pressed")
    property bool hasActiveDeactivated: iconPath === undefined || iconInfo.hasElementPrefix("deactivated")
    property bool hasInactive: iconPath === undefined || iconInfo.hasElementPrefix("inactive")
    property bool hasInactiveHover: iconPath === undefined || iconInfo.hasElementPrefix("hover-inactive")
    property bool hasInactivePressed: iconPath === undefined || iconInfo.hasElementPrefix("pressed-inactive")
    property bool hasInactiveDeactivated: iconPath === undefined || iconInfo.hasElementPrefix("deactivated-inactive")
    property int iconState: {
        if (active) {
            if ((pressed || toggled) && hasActivePressed)
                return WindowControlButton.IconState.ActivePressed;
            else if (hovered && hasActiveHover)
                return WindowControlButton.IconState.ActiveHover;
            else if (!enabled && hasActiveDeactivated)
                return WindowControlButton.IconState.ActiveDeactivated;
            else
                return WindowControlButton.IconState.Active;
        } else {
            if ((pressed || toggled) && hasInactivePressed)
                return WindowControlButton.IconState.InactivePressed;
            else if (hovered && hasInactiveHover)
                return WindowControlButton.IconState.InactiveHover;
            else if (!enabled && hasInactiveDeactivated)
                return WindowControlButton.IconState.InactiveDeactivated;
            else
                return WindowControlButton.IconState.Inactive;
        }
        if ((pressed || toggled) && !hasInactivePressed)
            return WindowControlButton.IconState.ActivePressed;
        else if (hovered && !hasInactiveHover)
            return WindowControlButton.IconState.ActiveHover;
        else if (!enabled && !hasInactiveDeactivated)
            return WindowControlButton.IconState.ActiveDeactivated;
        else
            return WindowControlButton.IconState.Active;
    }
    property alias mouseAreaEnabled: buttonMouseArea.enabled

    signal actionCall(int action)

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

    function getAction() {
        let type = button.buttonType;
        switch (type) {
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

    MouseArea {
        id: buttonMouseArea

        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        hoverEnabled: true
        onEntered: button.hovered = true
        onExited: button.hovered = false
        onPressed: button.pressed = true
        onReleased: button.pressed = false
        onClicked: function() {
            if (button.active)
                button.actionCall(button.getAction());

        }
    }

    KSvg.FrameSvg {
        id: iconInfo

        imagePath: button.iconPath || ""
    }

    Component {
        id: auroraeThemeButtonIcon

        KSvg.FrameSvgItem {
            required property int index
            required property string modelData

            anchors.fill: parent
            imagePath: button.iconPath
            opacity: index == button.iconState ? 1 : 0
            prefix: modelData
            enabledBorders: KSvg.FrameSvgItem.NoBorder

            Behavior on opacity {
                NumberAnimation {
                    duration: button.animationDuration
                }

            }

        }

    }

    Component {
        id: fallbackButtonIcon

        Item {
            anchors.fill: parent

            Kirigami.Icon {
                id: icon

                visible: !iconPath
                anchors.fill: parent
                source: fallbackIcon
            }

            MultiEffect {
                id: iconEffects

                anchors.fill: source
                source: icon
                blurEnabled: true
                blurMax: 4
                states: [
                    State {
                        name: "active"
                        when: iconState === WindowControlButton.IconState.Active || iconState === WindowControlButton.IconState.Inactive

                        PropertyChanges {
                            target: iconEffects
                            brightness: 0
                            blur: 0
                        }

                    },
                    State {
                        name: "hover"
                        when: iconState === WindowControlButton.IconState.ActiveHover || iconState === WindowControlButton.IconState.InactiveHover

                        PropertyChanges {
                            target: iconEffects
                            brightness: 0.2
                            blur: 4
                        }

                    },
                    State {
                        name: "pressed"
                        when: iconState === WindowControlButton.IconState.ActivePressed || iconState === WindowControlButton.IconState.InactivePressed

                        PropertyChanges {
                            target: iconEffects
                            brightness: 0.4
                            blur: 4
                        }

                    },
                    State {
                        name: "deactivated"
                        when: iconState === WindowControlButton.IconState.ActiveDeactivated || iconState === WindowControlButton.IconState.InactiveDeactivated

                        PropertyChanges {
                            target: iconEffects
                            brightness: -0.5
                            saturation: -1
                        }

                    }
                ]

                Behavior on blur {
                    NumberAnimation {
                        duration: button.animationDuration
                    }

                }

                Behavior on brightness {
                    NumberAnimation {
                        duration: button.animationDuration
                    }

                }

            }

        }

    }

    Loader {
        anchors.fill: parent
        active: iconPath != undefined

        sourceComponent: Repeater {
            anchors.fill: parent
            model: iconPath ? iconStatesPrefixes : undefined
            delegate: auroraeThemeButtonIcon
        }

    }

    Loader {
        anchors.fill: parent
        active: iconPath == undefined
        sourceComponent: fallbackButtonIcon
    }

}
