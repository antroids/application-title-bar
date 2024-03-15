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
        ActivePressed, //       Aurorae themes have no toggled state, the pressed is used for the following:
        ActiveToggled, //       ActivePressed
        ActiveHoverToggled, //  ActivePressed
        ActiveDeactivated,
        Inactive,
        InactiveHover,
        InactivePressed,
        InactiveToggled, //     InactivePressed
        InactiveHoverToggled, //InactivePressed
        InactiveDeactivated
    }

    enum IconTheme {
        Plasma,
        Breeze,
        Aurorae
    }

    readonly property var iconStatesPrefixes: ["active", "hover", "pressed", "pressed", "pressed", "deactivated", "inactive", "hover-inactive", "pressed-inactive", "pressed-inactive", "pressed-inactive", "deactivated-inactive"]
    property string themesPath: "aurorae/themes/"
    property string themeName
    property string svgExt: "svg"
    property string svgzExt: "svgz"
    property int buttonType
    property bool active: true
    property bool hovered: false
    property bool pressed: false
    property bool toggled: false
    property var iconPath: iconTheme == WindowControlButton.IconTheme.Aurorae ? buttonIconPath(buttonType) : undefined
    property int iconTheme: WindowControlButton.IconTheme.Plasma
    property var fallbackIcon: fallbackIconName(buttonType)
    property int animationDuration: 100
    property MouseArea mouseArea: buttonMouseArea
    property bool hasActiveHover: iconPath === undefined || iconInfo.hasElementPrefix("hover")
    property bool hasActivePressed: iconPath === undefined || iconInfo.hasElementPrefix("pressed")
    property bool hasActiveToggled: iconPath === undefined || iconInfo.hasElementPrefix("toggled")
    property bool hasActiveDeactivated: iconPath === undefined || iconInfo.hasElementPrefix("deactivated")
    property bool hasInactive: iconPath === undefined || iconInfo.hasElementPrefix("inactive")
    property bool hasInactiveHover: iconPath === undefined || iconInfo.hasElementPrefix("hover-inactive")
    property bool hasInactivePressed: iconPath === undefined || iconInfo.hasElementPrefix("pressed-inactive")
    property bool hasInactiveToggled: iconPath === undefined || iconInfo.hasElementPrefix("toggled-inactive")
    property bool hasInactiveDeactivated: iconPath === undefined || iconInfo.hasElementPrefix("deactivated-inactive")
    property int iconState: calculateIconState()
    property alias mouseAreaEnabled: buttonMouseArea.enabled

    signal actionCall(int action)

    function calculateIconState() {
        if (active) {
            if (pressed && hasActivePressed)
                return WindowControlButton.IconState.ActivePressed;
            else if (toggled && hovered && hasActiveToggled && hasActiveHover)
                return WindowControlButton.IconState.ActiveHoverToggled;
            else if (toggled && hasActiveToggled)
                return WindowControlButton.IconState.ActiveToggled;
            else if (hovered && hasActiveHover)
                return WindowControlButton.IconState.ActiveHover;
            else if (!enabled && hasActiveDeactivated)
                return WindowControlButton.IconState.ActiveDeactivated;
            else
                return WindowControlButton.IconState.Active;
        } else {
            if (pressed && hasInactivePressed)
                return WindowControlButton.IconState.InactivePressed;
            else if (toggled && hovered && hasInactiveToggled && hasInactiveHover)
                return WindowControlButton.IconState.InactiveHoverToggled;
            else if (toggled && hasInactiveToggled)
                return WindowControlButton.IconState.InactiveToggled;
            else if (hovered && hasInactiveHover)
                return WindowControlButton.IconState.InactiveHover;
            else if (!enabled && hasInactiveDeactivated)
                return WindowControlButton.IconState.InactiveDeactivated;
            else
                return WindowControlButton.IconState.Inactive;
        }
        if (pressed)
            return WindowControlButton.IconState.ActivePressed;
        else if (toggled && hovered)
            return WindowControlButton.IconState.ActiveHoverToggled;
        else if (toggled)
            return WindowControlButton.IconState.ActiveToggled;
        else if (hovered)
            return WindowControlButton.IconState.ActiveHover;
        else if (!enabled)
            return WindowControlButton.IconState.ActiveDeactivated;
        else
            return WindowControlButton.IconState.Active;
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

    function fallbackIconName(type) {
        switch (type) {
        case WindowControlButton.Type.MinimizeButton:
            return "window-minimize";
        case WindowControlButton.Type.MaximizeButton:
            return "window-maximize";
        case WindowControlButton.Type.RestoreButton:
            return "window-restore";
        case WindowControlButton.Type.CloseButton:
            return "window-close";
        case WindowControlButton.Type.AllDesktopsButton:
            return "window-pin";
        case WindowControlButton.Type.KeepAboveButton:
            return "window-keep-above";
        case WindowControlButton.Type.KeepBelowButton:
            return "window-keep-below";
        case WindowControlButton.Type.ShadeButton:
            return "window-shade";
        case WindowControlButton.Type.HelpButton:
            return "question";
        case WindowControlButton.Type.MenuButton:
            return "plasma-symbolic";
        case WindowControlButton.Type.AppMenuButton:
            return "application-menu";
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

    function isActiveButtonState(buttonState) {
        switch (buttonState) {
        case WindowControlButton.IconState.Active:
        case WindowControlButton.IconState.ActiveHover:
        case WindowControlButton.IconState.ActivePressed:
        case WindowControlButton.IconState.ActiveToggled:
        case WindowControlButton.IconState.ActiveHoverToggled:
        case WindowControlButton.IconState.ActiveDeactivated:
            return true;
        default:
            return false;
        }
    }

    function isHoveredButtonState(buttonState) {
        switch (buttonState) {
        case WindowControlButton.IconState.ActiveHover:
        case WindowControlButton.IconState.ActiveHoverToggled:
        case WindowControlButton.IconState.InactiveHover:
        case WindowControlButton.IconState.InactiveHoverToggled:
            return true;
        default:
            return false;
        }
    }

    function isToggledButtonState(buttonState) {
        switch (buttonState) {
        case WindowControlButton.IconState.ActiveToggled:
        case WindowControlButton.IconState.ActiveHoverToggled:
        case WindowControlButton.IconState.InactiveToggled:
        case WindowControlButton.IconState.InactiveHoverToggled:
            return true;
        default:
            return false;
        }
    }

    function isPressedButtonState(buttonState) {
        switch (buttonState) {
        case WindowControlButton.IconState.ActivePressed:
        case WindowControlButton.IconState.InactivePressed:
            return true;
        default:
            return false;
        }
    }

    function isDeactivatedButtonState(buttonState) {
        switch (buttonState) {
        case WindowControlButton.IconState.ActiveDeactivated:
        case WindowControlButton.IconState.InactiveDeactivated:
            return true;
        default:
            return false;
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

                anchors.fill: parent
                source: fallbackIcon
            }

            MultiEffect {
                id: iconEffects

                anchors.fill: source
                source: icon
                blurEnabled: true
                blurMax: 8
                states: [
                    State {
                        name: "hover"
                        when: isHoveredButtonState(button.iconState)

                        PropertyChanges {
                            target: iconEffects
                            brightness: 0.8
                            blur: 4
                        }

                    },
                    State {
                        name: "pressed"
                        when: isPressedButtonState(button.iconState)

                        PropertyChanges {
                            target: iconEffects
                            brightness: 0.6
                            blur: 4
                        }

                    },
                    State {
                        name: "toggled"
                        when: isToggledButtonState(button.iconState)

                        PropertyChanges {
                            target: iconEffects
                            brightness: 0.6
                            blur: 4
                        }

                    },
                    State {
                        name: "deactivated"
                        when: isDeactivatedButtonState(button.iconState)

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
        active: iconTheme == WindowControlButton.IconTheme.Breeze

        sourceComponent: Repeater {
            anchors.fill: parent
            model: WindowControlButton.IconState.InactiveDeactivated

            delegate: BreezeWindowControlButtonIcon {
                required property int index

                titleBarColor: isDeactivatedButtonState(index) ? Kirigami.Theme.alternateBackgroundColor : Kirigami.Theme.backgroundColor
                fontColor: isDeactivatedButtonState(index) ? Kirigami.Theme.disabledTextColor : Kirigami.Theme.textColor
                foregroundWarningColor: isDeactivatedButtonState(index) ? Kirigami.Theme.alternateBackgroundColor : Kirigami.Theme.negativeTextColor
                anchors.fill: parent
                buttonType: button.buttonType
                anchors.margins: 3
                opacity: index == button.iconState ? 1 : 0
                hovered: isHoveredButtonState(index)
                checked: isToggledButtonState(index)
                pressed: isPressedButtonState(index)
                active: isActiveButtonState(index)

                Behavior on opacity {
                    NumberAnimation {
                        duration: button.animationDuration
                    }

                }

            }

        }

    }

    Loader {
        anchors.fill: parent
        active: iconTheme != WindowControlButton.IconTheme.Breeze && !iconPath
        sourceComponent: fallbackButtonIcon
    }

}
