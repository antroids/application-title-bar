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

function calculateItemPreferredWidth(item) {
    var preferredWidth = 0;

    if (item && item.Layout) {
        preferredWidth += item.Layout.preferredWidth || 0;
        preferredWidth += item.Layout.leftMargin || 0;
        preferredWidth += item.Layout.rightMargin || 0;
    }

    return preferredWidth;
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

class Replacement {
    replace(_title) {
        throw new Error("Not implemented");
    }

    static createReplacement(type, pattern, template) {
        switch (type) {
            case 0: return new StringReplacement(pattern, template);
            case 1: return new RegExpReplacement(pattern, template);
            default:
                throw new Error("Unknown replacement type: " + type);
        }
    }

    static createReplacementList(types, patterns, templates) {
        const length = types.length;
        let result = new Array();
        for (let i = 0; i < length; i++) {
            const type = types[i];
            const pattern = patterns[i];
            const template = templates[i];
            if (type === undefined || pattern === undefined || template === undefined) {
                break; // Inconsistent state
            } else {
                result.push(Replacement.createReplacement(type, pattern, template));
            }
        }
        return result;
    }

    static applyReplacementList(title, replacements) {
        return replacements.reduce((acc, cur) => cur.replace(acc), title);
    }
}

class StringReplacement extends Replacement {
    constructor(stringToReplace, stringReplacement) {
        super();
        this.stringToReplace = stringToReplace;
        this.stringReplacement = stringReplacement;
    }

    replace(title) {
        let replaced = title.replace(this.stringToReplace, this.stringReplacement);
        while (replaced !== title) {
            title = replaced;
            replaced = title.replace(this.stringToReplace, this.stringReplacement);
        }
        return replaced;
    }
}

class RegExpReplacement extends Replacement {
    constructor(regExp, replacement) {
        super();
        this.regExp = new RegExp(regExp, "g");
        this.replacement = replacement;
    }

    replace(title) {
        return title.replace(this.regExp, this.replacement);
    }
}