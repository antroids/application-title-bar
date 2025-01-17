/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami
import QtQuick.Layouts

RowLayout {
    id: root

    property alias label: label.text
    property var value: undefined
    property alias initValue: slider.value
    property alias from: slider.from
    property alias to: slider.to
    property alias checked: checkBox.checked
    property alias stepSize: slider.stepSize

    signal valueUpdated(var updatedValue)

    Layout.fillWidth: true
    Layout.leftMargin: Kirigami.Units.gridUnit
    Layout.rightMargin: Kirigami.Units.gridUnit

    onValueChanged: function () {
        if (value === undefined) {
            checkBox.checked = false;
        } else {
            checkBox.checked = true;
            slider.value = value;
        }
    }

    Label {
        id: label
        text: "Slider"
        Layout.preferredWidth: 200
    }

    CheckBox {
        id: checkBox

        onToggled: function () {
            if (checked) {
                root.value = slider.value;
            } else {
                root.value = undefined;
            }
            valueUpdated(root.value);
        }
    }

    Slider {
        id: slider
        Layout.fillWidth: true

        enabled: checkBox.checked
        value: 0
        from: -1
        to: 1
        stepSize: 0.05

        onMoved: function () {
            if (checkBox.checked) {
                root.value = value;
                valueUpdated(root.value);
            }
        }
    }
}
