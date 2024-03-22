/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

function isX11() {
    const isX11Plugin = Qt.platform.pluginName == "xcb";
    return isX11Plugin;
}

function copyLayoutConstraint(from, to) {
    Object.assign(to.Layout, {
        "alignment": Qt.binding(function () { return from.Layout.alignment }),
        "bottomMargin": Qt.binding(function () { return from.Layout.bottomMargin }),
        "column": Qt.binding(function () { return from.Layout.column }),
        "columnSpan": Qt.binding(function () { return from.Layout.columnSpan }),
        "fillHeight": Qt.binding(function () { return from.Layout.fillHeight }),
        "fillWidth": Qt.binding(function () { return from.Layout.fillWidth }),
        "horizontalStretchFactor": Qt.binding(function () { return from.Layout.horizontalStretchFactor }),
        "leftMargin": Qt.binding(function () { return from.Layout.leftMargin }),
        "maximumHeight": Qt.binding(function () { return from.Layout.maximumHeight }),
        "maximumWidth": Qt.binding(function () { return from.Layout.maximumWidth }),
        "minimumHeight": Qt.binding(function () { return from.Layout.minimumHeight }),
        "minimumWidth": Qt.binding(function () { return from.Layout.minimumWidth }),
        "preferredHeight": Qt.binding(function () { return from.Layout.preferredHeight }),
        "preferredWidth": Qt.binding(function () { return from.Layout.preferredWidth }),
        "rightMargin": Qt.binding(function () { return from.Layout.rightMargin }),
        "row": Qt.binding(function () { return from.Layout.row }),
        "rowSpan": Qt.binding(function () { return from.Layout.rowSpan }),
        "topMargin": Qt.binding(function () { return from.Layout.topMargin }),
        "verticalStretchFactor": Qt.binding(function () { return from.Layout.verticalStretchFactor })
    })
}

function widgetElementModelFromName(name) {
    switch (name) {
        case "windowCloseButton":
            return {
                "type": WidgetElement.Type.WindowControlButton,
                "windowControlButtonType": WindowControlButton.Type.CloseButton
            };
        case "windowMinimizeButton":
            return {
                "type": WidgetElement.Type.WindowControlButton,
                "windowControlButtonType": WindowControlButton.Type.MinimizeButton
            };
        case "windowMaximizeButton":
            return {
                "type": WidgetElement.Type.WindowControlButton,
                "windowControlButtonType": WindowControlButton.Type.MaximizeButton
            };
        case "windowAllDesktopsButton":
            return {
                "type": WidgetElement.Type.WindowControlButton,
                "windowControlButtonType": WindowControlButton.Type.AllDesktopsButton
            };
        case "windowKeepAboveButton":
            return {
                "type": WidgetElement.Type.WindowControlButton,
                "windowControlButtonType": WindowControlButton.Type.KeepAboveButton
            };
        case "windowKeepBelowButton":
            return {
                "type": WidgetElement.Type.WindowControlButton,
                "windowControlButtonType": WindowControlButton.Type.KeepBelowButton
            };
        case "windowShadeButton":
            return {
                "type": WidgetElement.Type.WindowControlButton,
                "windowControlButtonType": WindowControlButton.Type.ShadeButton
            };
        case "windowHelpButton":
            return {
                "type": WidgetElement.Type.WindowControlButton,
                "windowControlButtonType": WindowControlButton.Type.HelpButton
            };
        case "windowMenuButton":
            return {
                "type": WidgetElement.Type.WindowControlButton,
                "windowControlButtonType": WindowControlButton.Type.MenuButton
            };
        case "windowAppMenuButton":
            return {
                "type": WidgetElement.Type.WindowControlButton,
                "windowControlButtonType": WindowControlButton.Type.AppMenuButton
            };
        case "windowTitle":
            return {
                "type": WidgetElement.Type.WindowTitle
            };
        case "windowIcon":
            return {
                "type": WidgetElement.Type.WindowIcon
            };
        case "spacer":
            return {
                "type": WidgetElement.Type.Spacer
            };
    }
}

function truncateString(str, n) {
    return (str.length > n) ? str.slice(0, n - 1) + '\u2026' : str;
};