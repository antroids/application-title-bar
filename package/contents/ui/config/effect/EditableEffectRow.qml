/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import "../../"
import "../../config"
import "../../config/effect"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

ColumnLayout {
    id: root

    Layout.fillWidth: true

    property EffectModel effectModel: EffectModel {}
    signal rowRemoved

    RowLayout {
        Layout.fillWidth: true

        Item {
            Layout.fillWidth: true
            height: Kirigami.Units.iconSizes.medium

            TextField {
                id: effectTitle
                anchors.fill: parent
                visible: editEffectButton.checked
                text: effectModel.name

                onTextEdited: function () {
                    effectModel.name = text;
                }
            }
            Text {
                id: editEffectTitle
                anchors.fill: parent
                anchors.leftMargin: Kirigami.Units.smallSpacing
                visible: !editEffectButton.checked
                text: effectTitle.text
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WrapAnywhere
                elide: Text.ElideRight
                maximumLineCount: 1
            }
        }

        Rectangle {
            id: effectPreview

            width: Kirigami.Units.gridUnit * 15

            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: Kirigami.Theme.backgroundColor
                }
                GradientStop {
                    position: 1.0
                    color: Kirigami.Theme.alternateBackgroundColor
                }
            }
            border.color: Kirigami.Theme.disabledTextColor
            height: Kirigami.Units.iconSizes.medium
            radius: Kirigami.Units.cornerRadius

            RowLayout {
                id: effectPreviewContent
                anchors.fill: parent

                Repeater {
                    model: ["window-close", "window-maximize", "window-minimize"]
                    Kirigami.Icon {
                        height: Kirigami.Units.iconSizes.medium
                        width: height
                        source: modelData
                    }
                }
                Text {
                    text: i18n("Preview")
                    color: Kirigami.Theme.textColor
                }
                Text {
                    text: i18n("Preview")
                    color: Kirigami.Theme.disabledTextColor
                }
            }

            MergedMultiEffect {
                source: effectPreviewContent
                anchors.fill: parent
                effectModel: root.effectModel
            }
        }

        Button {
            id: editEffectButton
            checkable: true
            icon.name: "editor"
        }

        Button {
            id: deleteEffectButton
            icon.name: "delete"
            onClicked: function () {
                root.rowRemoved();
            }
        }
    }

    Loader {
        Layout.fillWidth: true
        Layout.preferredHeight: item ? item.Layout.preferredHeight : 0
        active: editEffectButton.checked
        visible: active

        sourceComponent: Component {
            EditEffect {
                Layout.fillWidth: true
                effectModel: root.effectModel
            }
        }
    }
}
