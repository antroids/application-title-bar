/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick.Effects

MultiEffect {
    readonly property MultiEffect defaultEffectModel: MultiEffect {}
    property EffectModel effectModel: EffectModel {}

    brightness: effectModel.brightness !== undefined ? effectModel.brightness : defaultEffectModel.brightness
    contrast: effectModel.contrast !== undefined ? effectModel.contrast : defaultEffectModel.contrast
    saturation: effectModel.saturation !== undefined ? effectModel.saturation : defaultEffectModel.saturation
    colorization: effectModel.colorization !== undefined ? effectModel.colorization : defaultEffectModel.colorization
    colorizationColor: effectModel.colorizationColor !== undefined ? effectModel.colorizationColor : defaultEffectModel.colorizationColor

    blurEnabled: effectModel.blur !== undefined
    blur: effectModel.blur !== undefined ? effectModel.blur : defaultEffectModel.blur
    blurMax: effectModel.blurMax !== undefined ? effectModel.blurMax : defaultEffectModel.blurMax
    blurMultiplier: effectModel.blurMultiplier !== undefined ? effectModel.blurMultiplier : defaultEffectModel.blurMultiplier

    shadowEnabled: effectModel.shadowOpacity !== undefined
    shadowOpacity: effectModel.shadowOpacity !== undefined ? effectModel.shadowOpacity : defaultEffectModel.shadowOpacity
    shadowBlur: effectModel.shadowBlur !== undefined ? effectModel.shadowBlur : defaultEffectModel.shadowBlur
    shadowHorizontalOffset: effectModel.shadowHorizontalOffset !== undefined ? effectModel.shadowHorizontalOffset : defaultEffectModel.shadowHorizontalOffset
    shadowVerticalOffset: effectModel.shadowVerticalOffset !== undefined ? effectModel.shadowVerticalOffset : defaultEffectModel.shadowVerticalOffset
    shadowScale: effectModel.shadowScale !== undefined ? effectModel.shadowScale : defaultEffectModel.shadowScale
    shadowColor: effectModel.shadowColor !== undefined ? effectModel.shadowColor : defaultEffectModel.shadowColor

    maskEnabled: effectModel.maskEnabled
    maskInverted: effectModel.maskInverted
    maskThresholdMin: effectModel.maskThresholdMin !== undefined ? effectModel.maskThresholdMin : defaultEffectModel.maskThresholdMin
    maskThresholdMax: effectModel.maskThresholdMax !== undefined ? effectModel.maskThresholdMax : defaultEffectModel.maskThresholdMax
    maskSpreadAtMin: effectModel.maskSpreadAtMin !== undefined ? effectModel.maskSpreadAtMin : defaultEffectModel.maskSpreadAtMin
    maskSpreadAtMax: effectModel.maskSpreadAtMax !== undefined ? effectModel.maskSpreadAtMax : defaultEffectModel.maskSpreadAtMax
}
