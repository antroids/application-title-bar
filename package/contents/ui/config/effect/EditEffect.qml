/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

ColumnLayout {
    id: root

    property EffectModel effectModel: EffectModel {}

    onEffectModelChanged: function () {
        brightness.value = effectModel.brightness;
        contrast.value = effectModel.contrast;
        saturation.value = effectModel.saturation;
        colorization.value = effectModel.colorization;
        colorizationColor.value = effectModel.colorizationColor;

        blur.value = effectModel.blur;
        blurMax.value = effectModel.blurMax;
        blurMultiplier.value = effectModel.blurMultiplier;

        shadowOpacity.value = effectModel.shadowOpacity;
        shadowBlur.value = effectModel.shadowBlur;
        shadowHorizontalOffset.value = effectModel.shadowHorizontalOffset;
        shadowVerticalOffset.value = effectModel.shadowVerticalOffset;
        shadowScale.value = effectModel.shadowScale;
        shadowColor.value = effectModel.shadowColor;

        maskEnabled.value = effectModel.maskEnabled;
        maskInverted.value = effectModel.maskInverted;
        maskThresholdMin.value = effectModel.maskThresholdMin;
        maskThresholdMax.value = effectModel.maskThresholdMax;
        maskSpreadAtMin.value = effectModel.maskSpreadAtMin;
        maskSpreadAtMax.value = effectModel.maskSpreadAtMax;
    }

    spacing: 0

    TabBar {
        id: bar
        Layout.fillWidth: true
        Layout.bottomMargin: 0
        TabButton {
            text: i18n("Color")
            contentItem: tabsLayout
        }
        TabButton {
            text: i18n("Blur")
            contentItem: tabsLayout
        }
        TabButton {
            text: i18n("Shadow")
            contentItem: tabsLayout
        }
        TabButton {
            text: i18n("Mask")
            contentItem: tabsLayout
        }
    }

    Frame {
        Layout.fillWidth: true
        Layout.topMargin: 0
        implicitHeight: tabsLayout.implicitHeight

        StackLayout {
            id: tabsLayout
            width: parent.width
            currentIndex: bar.currentIndex

            ColumnLayout {
                CheckableSlider {
                    id: brightness
                    Layout.topMargin: Kirigami.Units.gridUnit
                    label: i18n("Brightness")
                    onValueUpdated: function (v) {
                        root.effectModel.brightness = v;
                    }
                }

                CheckableSlider {
                    id: contrast
                    label: i18n("Contrast")
                    onValueUpdated: function (v) {
                        root.effectModel.contrast = v;
                    }
                }

                CheckableSlider {
                    id: saturation
                    label: i18n("Saturation")
                    onValueUpdated: function (v) {
                        root.effectModel.saturation = v;
                    }
                }

                CheckableSlider {
                    id: colorization
                    label: i18n("Colorization")
                    from: 0
                    stepSize: 0.01
                    onValueUpdated: function (v) {
                        root.effectModel.colorization = v;
                    }
                }

                CheckableColorSlider {
                    id: colorizationColor
                    Layout.bottomMargin: Kirigami.Units.gridUnit
                    label: i18n("Colorization Color")
                    initValue: "red"
                    onValueUpdated: function (v) {
                        root.effectModel.colorizationColor = v;
                    }
                }
            }
            ColumnLayout {
                CheckableSlider {
                    id: blur
                    Layout.topMargin: Kirigami.Units.gridUnit
                    label: i18n("Blur")
                    from: 0
                    stepSize: 0.01
                    onValueUpdated: function (v) {
                        root.effectModel.blur = v;
                    }
                }

                CheckableSlider {
                    id: blurMax
                    label: i18n("Blur Max")
                    from: 2
                    to: 64
                    initValue: 32
                    stepSize: 1
                    onValueUpdated: function (v) {
                        root.effectModel.blurMax = v;
                    }
                }

                CheckableSlider {
                    id: blurMultiplier
                    Layout.bottomMargin: Kirigami.Units.gridUnit
                    label: i18n("Blur Multiplier")
                    from: 0
                    to: 16
                    stepSize: 0.1
                    onValueUpdated: function (v) {
                        root.effectModel.blurMultiplier = v;
                    }
                }
            }
            ColumnLayout {
                CheckableSlider {
                    id: shadowOpacity
                    Layout.topMargin: Kirigami.Units.gridUnit
                    label: i18n("Shadow")
                    from: 0
                    stepSize: 0.01
                    initValue: 1.0
                    onValueUpdated: function (v) {
                        root.effectModel.shadowOpacity = v;
                    }
                }

                CheckableSlider {
                    id: shadowBlur
                    label: i18n("Shadow Blur")
                    from: 0
                    stepSize: 0.01
                    initValue: 1.0
                    onValueUpdated: function (v) {
                        root.effectModel.shadowBlur = v;
                    }
                }

                CheckableSlider {
                    id: shadowHorizontalOffset
                    label: i18n("Shadow Horizontal Offset")
                    from: -20
                    to: 20
                    stepSize: 0.1
                    onValueUpdated: function (v) {
                        root.effectModel.shadowHorizontalOffset = v;
                    }
                }

                CheckableSlider {
                    id: shadowVerticalOffset
                    label: i18n("Shadow Vertical Offset")
                    from: -20
                    to: 20
                    stepSize: 0.1
                    onValueUpdated: function (v) {
                        root.effectModel.shadowVerticalOffset = v;
                    }
                }

                CheckableSlider {
                    id: shadowScale
                    label: i18n("Shadow Scale")
                    from: 0.7
                    to: 1.3
                    stepSize: 0.01
                    initValue: 1.0
                    onValueUpdated: function (v) {
                        root.effectModel.shadowScale = v;
                    }
                }

                CheckableColorSlider {
                    id: shadowColor
                    Layout.bottomMargin: Kirigami.Units.gridUnit
                    label: i18n("Shadow Color")
                    onValueUpdated: function (v) {
                        root.effectModel.shadowColor = v;
                    }
                }
            }
            ColumnLayout {
                Checkable {
                    id: maskEnabled
                    Layout.topMargin: Kirigami.Units.gridUnit
                    label: i18n("Mask Enabled")
                    onValueUpdated: function (v) {
                        root.effectModel.maskEnabled = v;
                    }
                }

                Checkable {
                    id: maskInverted
                    label: i18n("Mask Inverted")
                    onValueUpdated: function (v) {
                        root.effectModel.maskInverted = v;
                    }
                }

                CheckableSlider {
                    id: maskThresholdMin
                    label: i18n("Mask Threshold Min")
                    from: 0
                    stepSize: 0.01
                    onValueUpdated: function (v) {
                        root.effectModel.maskThresholdMin = v;
                    }
                }

                CheckableSlider {
                    id: maskThresholdMax
                    label: i18n("Mask Threshold Max")
                    from: 0
                    stepSize: 0.01
                    initValue: 1.0
                    onValueUpdated: function (v) {
                        root.effectModel.maskThresholdMax = v;
                    }
                }

                CheckableSlider {
                    id: maskSpreadAtMin
                    label: i18n("Mask Spread At Min")
                    from: 0
                    stepSize: 0.01
                    onValueUpdated: function (v) {
                        root.effectModel.maskSpreadAtMin = v;
                    }
                }

                CheckableSlider {
                    id: maskSpreadAtMax
                    Layout.bottomMargin: Kirigami.Units.gridUnit
                    label: i18n("Mask Spread At Max")
                    from: 0
                    stepSize: 0.01
                    onValueUpdated: function (v) {
                        root.effectModel.maskSpreadAtMax = v;
                    }
                }
            }
        }
    }
}
