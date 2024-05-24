/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import org.kde.kirigami as Kirigami
import "../"

Canvas {
    antialiasing: true

    property bool hovered: false
    property bool active: false
    property bool pressed: false
    property bool checked: false
    property bool disabled: false
    property int buttonType: 0

    property color inactiveForegroundColor: palette.inactive.buttonText
    property var colors: disabled ? palette.disabled : active ? palette.active : palette.inactive
    property color backgroundColor: colors.button
    property color foregroundColor: colors.buttonText
    property color lightBackgroundColor: colors.light
    property color midDarkBackgroundColor: colors.mid
    property color midLightBackgroundColor: colors.midlight
    property color shadowColor: Qt.alpha(colors.shadow, 0.5)
    property color negativeForegroundColor: Kirigami.Theme.negativeTextColor
    property color hoverForegroundColor: Kirigami.Theme.hoverColor
    property color checkedForegroundColor: Kirigami.Theme.focusColor
    property bool toggleButton: isToggleButton()

    onPaint: function () {
        let ctx = getContext("2d");
        let color = foregroundColor;
        ctx.save();
        ctx.reset();
        ctx.translate(0, 0);
        ctx.lineWidth = 1.2;
        ctx.lineCap = "round";
        ctx.lineJoin = "round";
        if (hovered || (toggleButton && checked)) {
            let glowColor = calcGlowColor();
            if (hovered !== (toggleButton && checked)) {
                color = glowColor;
            } else if (toggleButton && checked) {
                color = Kirigami.ColorUtils.linearInterpolation(inactiveForegroundColor, color, 0.7);
            }
            drawButtonGlow(ctx, glowColor);
        }
        drawButton(ctx, color, pressed || checked);
        ctx.strokeStyle = midLightBackgroundColor;
        ctx.translate(0, 1.5);
        drawIcon(ctx);
        ctx.translate(0, -1.5);
        ctx.strokeStyle = color;
        drawIcon(ctx);
        ctx.restore();
    }

    function drawIcon(ctx) {
        ctx.save();
        ctx.beginPath();
        scaleCtx(ctx, 21);
        ctx.lineWidth = Math.max(ctx.lineWidth, 1.1 / width / 21);
        ctx.fillStyle = ctx.strokeStyle;
        switch (buttonType) {
        case WindowControlButton.Type.MinimizeButton:
            ctx.lineTo(7.5, 9.5);
            ctx.lineTo(10.5, 12.5);
            ctx.lineTo(13.5, 9.5);
            ctx.stroke();
            break;
        case WindowControlButton.Type.MaximizeButton:
        case WindowControlButton.Type.RestoreButton:
            if (checked) {
                ctx.lineTo(7.5, 10.5);
                ctx.lineTo(10.5, 7.5);
                ctx.lineTo(13.5, 10.5);
                ctx.lineTo(10.5, 13.5);
                ctx.closePath();
                ctx.stroke();
            } else {
                ctx.lineTo(7.5, 11.5);
                ctx.lineTo(10.5, 8.5);
                ctx.lineTo(13.5, 11.5);
                ctx.stroke();
            }
            break;
        case WindowControlButton.Type.CloseButton:
            ctx.moveTo(7.5, 7.5);
            ctx.lineTo(13.5, 13.5);
            ctx.moveTo(13.5, 7.5);
            ctx.lineTo(7.5, 13.5);
            ctx.stroke();
            break;
        case WindowControlButton.Type.AllDesktopsButton:
            drawPoint(ctx, 10.5, 10.5);
            break;
        case WindowControlButton.Type.KeepAboveButton:
            ctx.moveTo(7.5, 14);
            ctx.lineTo(10.5, 11);
            ctx.lineTo(13.5, 14);
            ctx.moveTo(7.5, 10);
            ctx.lineTo(10.5, 7);
            ctx.lineTo(13.5, 10);
            ctx.stroke();
            break;
        case WindowControlButton.Type.KeepBelowButton:
            ctx.moveTo(7.5, 11);
            ctx.lineTo(10.5, 14);
            ctx.lineTo(13.5, 11);
            ctx.moveTo(7.5, 7);
            ctx.lineTo(10.5, 10);
            ctx.lineTo(13.5, 7);
            ctx.stroke();
            break;
        case WindowControlButton.Type.ShadeButton:
            if (checked) {
                ctx.moveTo(7.5, 10.5);
                ctx.lineTo(10.5, 7.5);
                ctx.lineTo(13.5, 10.5);
            } else {
                ctx.moveTo(7.5, 7.5);
                ctx.lineTo(10.5, 10.5);
                ctx.lineTo(13.5, 7.5);
            }
            ctx.moveTo(7.5, 13);
            ctx.lineTo(13.5, 13);
            ctx.stroke();
            break;
        case WindowControlButton.Type.HelpButton:
            const radsInDegree = Math.PI / 180;
            ctx.translate(1.5, 1.5);
            arc(ctx, 7, 5, 4, 135, -180);
            ctx.stroke();
            ctx.beginPath();
            arc(ctx, 9, 8, 4, 135, 45);
            ctx.stroke();
            drawPoint(ctx, 9, 12);
            ctx.translate(-1.5, -1.5);
            break;
        case WindowControlButton.Type.MenuButton:
        case WindowControlButton.Type.AppMenuButton:
            ctx.moveTo(7.5, 7.5);
            ctx.lineTo(13.5, 7.5);
            ctx.moveTo(7.5, 10.5);
            ctx.lineTo(13.5, 10.5);
            ctx.moveTo(7.5, 13.5);
            ctx.lineTo(13.5, 13.5);
            ctx.stroke();
            break;
        default:
            break;
        }
        descaleCtx(ctx, 21);
        ctx.restore();
    }

    function drawButton(ctx, glowColor, sunken) {
        scaleCtx(ctx, 21);
        drawButtonShadow(ctx, shadowColor, 21);
        descaleCtx(ctx, 21);
        scaleCtx(ctx, 18);
        drawButtonSlab(ctx, 18, sunken);
        descaleCtx(ctx, 18);
    }

    function drawButtonShadow(ctx, color, size) {
        let m = (size - 2) / 2;
        let offset = 0.8;
        let k0 = (m - 4) / m;
        let x = m + 1.0;
        let y = m + offset + 1.0;
        let shadowGradient = ctx.createRadialGradient(x, y, 0, x, y, m);
        for (let i = 0; i < 8; i++) {
            let k1 = (k0 * (8 - i) + i) / 8;
            let a = (Math.cos(Math.PI * i / 8) + 1) * 0.3;
            let colorStop = Qt.alpha(color, color.a * a * 1.5);
            shadowGradient.addColorStop(k1, colorStop);
        }
        shadowGradient.addColorStop(1, "transparent");
        ctx.save();
        ctx.translate(0, -0.2);
        ctx.fillStyle = shadowGradient;
        ctx.beginPath();
        ctx.ellipse(0, 0, size, size);
        ctx.fill();
        ctx.restore();
    }

    function drawButtonGlow(ctx, color) {
        let size = 21;
        let m = size / 2;
        let glowWidth = 3;
        let glowBias = 0.6;
        let bias = glowBias * 14 / size;
        let gm = m + bias - 0.9;
        let k0 = (m - glowWidth + bias) / gm;
        let glowGradient = ctx.createRadialGradient(m, m, 0, m, m, gm);
        for (let i = 0; i < 8; i++) {
            let k1 = k0 + i * (1 - k0) / 8;
            let a = 1 - Math.sqrt(i / 8);
            let colorStop = Qt.alpha(color, color.a * a);
            glowGradient.addColorStop(k1, colorStop);
        }
        glowGradient.addColorStop(1, "transparent");
        ctx.save();
        scaleCtx(ctx, 21);
        ctx.translate(0, -0.2);
        ctx.fillStyle = glowGradient;
        ctx.beginPath();
        ctx.ellipse(0, 0, size, size);
        ctx.fill();
        ctx.globalCompositeOperation = "destination-out";
        ctx.fillStyle = "black";
        ctx.beginPath();
        ctx.ellipse(width + 0.5, width + 0.5, size - width - 1, size - width - 1);
        ctx.fill();
        descaleCtx(ctx, 21);
        ctx.restore();
    }

    function drawButtonSlab(ctx, size, sunken) {
        ctx.save();
        ctx.translate(0, 1);
        let lighter = midLightBackgroundColor;
        let darker = midDarkBackgroundColor;
        let backgroundGradient = ctx.createLinearGradient(0, 1.665, 0, (12.33 + 1.665));
        if (sunken) {
            backgroundGradient.addColorStop(1, lighter);
            backgroundGradient.addColorStop(0, darker);
        } else {
            backgroundGradient.addColorStop(1, darker);
            backgroundGradient.addColorStop(0, lighter);
        }
        let contourGradient = ctx.createLinearGradient(0, 1.665, 0, (2.0 * 12.33 + 1.665));
        contourGradient.addColorStop(1, lighter);
        contourGradient.addColorStop(0, darker);
        ctx.beginPath();
        ctx.ellipse(0.5 * (18 - 12.33), 1.665, 12.33, 12.33);
        ctx.fillStyle = backgroundGradient;
        ctx.lineStyle = contourGradient;
        ctx.lineWidth = 0.7 / size / width;
        ctx.fill();
        ctx.stroke();
        ctx.restore();
    }

    function scaleCtx(ctx, scale) {
        ctx.scale(width / scale, width / scale);
    }

    function descaleCtx(ctx, scale) {
        ctx.scale(scale / width, scale / width);
    }

    function normalize(val) {
        return Math.min(1, Math.max(0, val));
    }

    function calcGlowColor() {
        if (buttonType === WindowControlButton.Type.CloseButton) {
            return negativeForegroundColor;
        } else if (hovered && toggleButton && checked) {
            return inactiveForegroundColor;
        } else if (toggleButton && checked) {
            return checkedForegroundColor;
        } else {
            return hoverForegroundColor;
        }
    }

    function arc(ctx, x, y, size, startAngle, spanAngle) {
        let r = size / 2;
        const radsInDegree = Math.PI / 180;
        let start = -startAngle * radsInDegree;
        let end = -(startAngle + spanAngle) * radsInDegree;
        ctx.arc(x + r, y + r, r, start, end, spanAngle > 0);
    }

    function drawPoint(ctx, x, y) {
        let radius = ctx.lineWidth / 2;
        ctx.beginPath();
        ctx.ellipse(x - radius, y - radius, ctx.lineWidth, ctx.lineWidth);
        ctx.fill();
    }

    function isToggleButton() {
        switch (buttonType) {
        case WindowControlButton.Type.AllDesktopsButton:
        case WindowControlButton.Type.KeepAboveButton:
        case WindowControlButton.Type.KeepBelowButton:
            return true;
        default:
            return false;
        }
    }

    onHoveredChanged: Qt.callLater(requestPaint)
    onActiveChanged: Qt.callLater(requestPaint)
    onPressedChanged: Qt.callLater(requestPaint)
    onCheckedChanged: Qt.callLater(requestPaint)
    onWidthChanged: Qt.callLater(requestPaint)
    onHeightChanged: Qt.callLater(requestPaint)
    onColorsChanged: Qt.callLater(requestPaint)
    onButtonTypeChanged: Qt.callLater(requestPaint)
}
