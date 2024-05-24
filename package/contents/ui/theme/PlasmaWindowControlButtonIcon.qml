/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Shapes
import org.kde.kirigami as Kirigami
import "../"

Item {
    id: iconRoot

    property bool active: true
    property bool hovered: false
    property bool pressed: false
    property bool checked: false
    property int buttonType: WindowControlButton.Type.MinimizeButton

    anchors.fill: parent

    Shape {
        id: iconBackground

        layer.enabled: true
        anchors.fill: parent
        opacity: hovered ? 0.25 : pressed || checked ? 0.15 : 0

        ShapePath {
            startX: 0
            startY: height / 2
            fillGradient: radialGradient
            strokeColor: "transparent"

            PathArc {
                x: width
                y: height / 2
                radiusX: iconBackground.width / 2
                radiusY: height / 2
                useLargeArc: true
            }

            PathArc {
                x: 0
                y: height / 2
                radiusX: iconBackground.width / 2
                radiusY: height / 2
                useLargeArc: true
            }
        }

        RadialGradient {
            id: radialGradient

            centerX: iconBackground.width / 2
            centerY: iconBackground.height / 2
            centerRadius: iconBackground.width / 2
            focalX: centerX
            focalY: centerY

            GradientStop {
                position: 0
                color: Kirigami.Theme.textColor
            }

            GradientStop {
                position: 1
                color: "transparent"
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: button.animationDuration
            }
        }
    }

    Kirigami.Icon {
        id: icon

        anchors.fill: parent
        source: plasmaIconName(iconRoot.buttonType)
    }

    MultiEffect {
        anchors.fill: source
        source: icon
        blurEnabled: true
        blurMax: 8
        brightness: hovered ? 0.6 : pressed || checked ? 0.3 : 0
        blur: hovered ? 4 : pressed || checked ? 2 : 0
        saturation: active ? 0 : -0.5

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

    function plasmaIconName(type) {
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
}
