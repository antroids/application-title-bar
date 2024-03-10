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
        AppMenu
    }

    property bool minimizable: false
    property bool maximizable: false
    property bool closable: false
    property bool movable: false
    property bool minimized: false
    property bool maximized: false
    property bool shadeable: false
    property bool hasAppMenu: false
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
        default:
            true;
        }
    }

}
