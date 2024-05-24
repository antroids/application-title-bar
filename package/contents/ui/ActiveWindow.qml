/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick

QtObject {
    id: activeWindow

    enum Action {
        Close,
        Minimize,
        Maximize,
        Move,
        AllDesktops,
        KeepAbove,
        KeepBelow,
        Shade,
        Help,
        Menu,
        AppMenu,
        Activate,
        FullScreen,
        Resize
    }

    property bool minimizable: false
    property bool maximizable: false
    property bool closable: false
    property bool movable: false
    property bool minimized: false
    property bool maximized: false
    property bool shadeable: false
    property bool shaded: false
    property bool hasAppMenu: false
    property bool onAllVirtualDesktops: false
    property bool keepAbove: false
    property bool keepBelow: false
    property bool fullScreenable: false
    property bool fullScreen: false
    property bool resizable: false
    property bool active: false
    property var appName
    property var genericAppName
    property var decoration
    property var icon

    signal actionCall(int action)

    function actionSupported(action) {
        switch (action) {
        case ActiveWindow.Action.Close:
            return closable;
        case ActiveWindow.Action.Minimize:
            return minimizable;
        case ActiveWindow.Action.Maximize:
            return maximizable;
        case ActiveWindow.Action.Move:
            return movable;
        case ActiveWindow.Action.Shade:
            return shadeable;
        case ActiveWindow.Action.AppMenu:
            return hasAppMenu;
        case ActiveWindow.Action.Fullscreen:
            return fullScreenable;
        case ActiveWindow.Action.Resize:
            return resizable;
        default:
            return true;
        }
    }

    function buttonChecked(windowControlButtonType) {
        switch (windowControlButtonType) {
        case WindowControlButton.Type.MinimizeButton:
            return minimized;
        case WindowControlButton.Type.MaximizeButton:
            return maximized;
        case WindowControlButton.Type.KeepAboveButton:
            return keepAbove;
        case WindowControlButton.Type.KeepBelowButton:
            return keepBelow;
        case WindowControlButton.Type.ShadeButton:
            return shaded;
        default:
            return false;
        }
    }
}
