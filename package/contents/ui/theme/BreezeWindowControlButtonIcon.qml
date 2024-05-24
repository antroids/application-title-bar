/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import "../"

Canvas {
    property color titleBarColor: "gray"
    property color fontColor: "white"
    property color foregroundWarningColor: "red"
    property bool outlineCloseButton: false
    property color backgroundColor: calculateBackgroundColor()
    property color foregroundColor: calculateForegroundColor()
    property int buttonType: WindowControlButton.Type.CloseButton
    property bool hovered: false
    property bool active: false
    property bool pressed: false
    property bool checked: false

    function drawIcon(ctx) {
        ctx.reset();
        ctx.scale(width / 20, height / 20);
        ctx.translate(1, 1);
        drawBackground(ctx);
        drawForeground(ctx);
    }

    function drawBackground(ctx) {
        ctx.fillStyle = backgroundColor;
        ctx.ellipse(0, 0, 18, 18);
        ctx.fill();
    }

    function drawForeground(ctx) {
        ctx.beginPath();
        ctx.strokeStyle = foregroundColor;
        ctx.fillStyle = foregroundColor;
        ctx.lineJoin = "miter";
        ctx.lineCap = "round";
        ctx.lineWidth = Math.max(1, 20 / width);
        switch (buttonType) {
        case WindowControlButton.Type.MinimizeButton:
            ctx.moveTo(4, 7);
            ctx.lineTo(9, 12);
            ctx.lineTo(14, 7);
            ctx.stroke();
            break;
        case WindowControlButton.Type.RestoreButton:
        case WindowControlButton.Type.MaximizeButton:
            if (checked) {
                ctx.lineJoin = "round";
                ctx.moveTo(4, 9);
                ctx.lineTo(9, 4);
                ctx.lineTo(14, 9);
                ctx.lineTo(9, 14);
                ctx.closePath();
                ctx.stroke();
            } else {
                ctx.moveTo(4, 11);
                ctx.lineTo(9, 6);
                ctx.lineTo(14, 11);
                ctx.stroke();
            }
            break;
        case WindowControlButton.Type.CloseButton:
            ctx.moveTo(5, 5);
            ctx.lineTo(13, 13);
            ctx.moveTo(13, 5);
            ctx.lineTo(5, 13);
            ctx.stroke();
            break;
        case WindowControlButton.Type.AllDesktopsButton:
            if (checked) {
                ctx.ellipse(3, 3, 12, 12);
                ctx.fill();
                ctx.beginPath();
                ctx.fillStyle = backgroundColor;
                ctx.ellipse(8, 8, 2, 2);
                ctx.fill();
            } else {
                ctx.moveTo(6.5, 8.5);
                ctx.lineTo(12, 3);
                ctx.lineTo(15, 6);
                ctx.lineTo(9.5, 11.5);
                ctx.closePath();
                ctx.fill();
                ctx.beginPath();
                ctx.moveTo(5.5, 7.5);
                ctx.lineTo(10.5, 12.5);
                ctx.moveTo(12, 6);
                ctx.lineTo(4.5, 13.5);
                ctx.stroke();
            }
            break;
        case WindowControlButton.Type.KeepAboveButton:
            ctx.moveTo(4, 9);
            ctx.lineTo(9, 4);
            ctx.lineTo(14, 9);
            ctx.moveTo(4, 13);
            ctx.lineTo(9, 8);
            ctx.lineTo(14, 13);
            ctx.stroke();
            break;
        case WindowControlButton.Type.KeepBelowButton:
            ctx.moveTo(4, 5);
            ctx.lineTo(9, 10);
            ctx.lineTo(14, 5);
            ctx.moveTo(4, 9);
            ctx.lineTo(9, 14);
            ctx.lineTo(14, 9);
            ctx.stroke();
            break;
        case WindowControlButton.Type.ShadeButton:
            ctx.moveTo(4, 5.5);
            ctx.lineTo(14, 5.5);
            if (checked) {
                ctx.moveTo(4, 8);
                ctx.lineTo(9, 13);
                ctx.lineTo(14, 8);
                ctx.stroke();
            } else {
                ctx.moveTo(4, 13);
                ctx.lineTo(9, 8);
                ctx.lineTo(14, 13);
                ctx.stroke();
            }
            break;
        case WindowControlButton.Type.HelpButton:
            ctx.moveTo(6, 6);
            ctx.bezierCurveTo(7, 1.5, 16, 4, 12, 8.5);
            ctx.bezierCurveTo(12, 8.5, 9, 8.5, 9, 11.5);
            ctx.rect(9, 15, 0.5, 0.5);
            ctx.stroke();
            break;
        case WindowControlButton.Type.MenuButton:
        case WindowControlButton.Type.AppMenuButton:
            ctx.rect(3.5, 4.5, 11, 1);
            ctx.rect(3.5, 8.5, 11, 1);
            ctx.rect(3.5, 12.5, 11, 1);
            ctx.stroke();
            break;
        }
    }

    function mix(a, b, bias) {
        return a + (b - a) * bias;
    }

    function bound(min, val, max) {
        return Math.max(min, Math.min(val, max));
    }

    function mixColors(c1, c2, bias) {
        if (bias <= 0)
            return c1;
        if (bias >= 1)
            return c2;
        let a = mix(c1.a, c2.a, bias);
        if (a <= 0)
            return Qt.rgba(0, 0, 0, 0);
        let r = bound(0, mix(c1.r * c1.a, c2.r * c2.a, bias), 1) / a;
        let g = bound(0, mix(c1.g * c1.a, c2.g * c2.a, bias), 1) / a;
        let b = bound(0, mix(c1.b * c1.a, c2.b * c2.a, bias), 1) / a;
        return Qt.rgba(r, g, b, a);
    }

    function calculateBackgroundColor() {
        if (pressed) {
            if (buttonType == WindowControlButton.Type.CloseButton)
                return foregroundWarningColor.darker();
            else
                return mixColors(titleBarColor, fontColor, 0.3);
        } else if ((buttonType == WindowControlButton.Type.KeepAboveButton || buttonType == WindowControlButton.Type.KeepBelowButton || buttonType == WindowControlButton.Type.ShadeButton) && checked) {
            return fontColor;
        } else if (hovered) {
            if (buttonType == WindowControlButton.Type.CloseButton)
                return active ? foregroundWarningColor.lighter() : foregroundWarningColor;
            else
                return fontColor;
        } else if (buttonType == WindowControlButton.Type.CloseButton && outlineCloseButton) {
            return active ? foregroundWarningColor : fontColor;
        }
        return Qt.rgba(0, 0, 0, 0);
    }

    function calculateForegroundColor() {
        if (pressed)
            return titleBarColor;
        else if (buttonType == WindowControlButton.Type.CloseButton && outlineCloseButton)
            return titleBarColor;
        else if ((buttonType == WindowControlButton.Type.KeepAboveButton || buttonType == WindowControlButton.Type.KeepBelowButton || buttonType == WindowControlButton.Type.ShadeButton) && checked)
            return titleBarColor;
        else if (hovered)
            return titleBarColor;
        return fontColor;
    }

    onHoveredChanged: Qt.callLater(requestPaint)
    onActiveChanged: Qt.callLater(requestPaint)
    onPressedChanged: Qt.callLater(requestPaint)
    onCheckedChanged: Qt.callLater(requestPaint)
    onWidthChanged: Qt.callLater(requestPaint)
    onHeightChanged: Qt.callLater(requestPaint)
    onTitleBarColorChanged: Qt.callLater(requestPaint)
    onFontColorChanged: Qt.callLater(requestPaint)
    onForegroundWarningColorChanged: Qt.callLater(requestPaint)
    onButtonTypeChanged: Qt.callLater(requestPaint)
    anchors.fill: parent
    antialiasing: true
    onPaint: function () {
        var ctx = getContext("2d");
        drawIcon(ctx);
    }
}
