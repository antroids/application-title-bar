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
    property alias checked: checkBox.checked
    property color initValue: "black"

    signal valueUpdated(var updatedValue)

    Layout.fillWidth: true
    Layout.leftMargin: Kirigami.Units.gridUnit
    Layout.rightMargin: Kirigami.Units.gridUnit

    onValueChanged: function () {
        if (value === undefined) {
            checkBox.checked = false;
        } else {
            checkBox.checked = true;
            red.value = value.r;
            green.value = value.g;
            blue.value = value.b;
            alpha.value = value.a;
        }
    }

    function updateValue() {
        if (checkBox.checked) {
            root.value = Qt.rgba(red.value, green.value, blue.value, alpha.value);
        } else {
            root.value = undefined;
        }
        valueUpdated(root.value);
    }

    Label {
        id: label
        text: "Color"
        Layout.preferredWidth: 200
    }

    CheckBox {
        id: checkBox

        onToggled: updateValue()
    }

    Slider {
        id: red
        Layout.fillWidth: true

        enabled: checkBox.checked
        value: root.initValue.r
        from: 0
        to: 1
        stepSize: 0.01

        onMoved: updateValue()

        Rectangle {
            anchors.fill: parent
            color: "#22FF0000"
        }
    }

    Slider {
        id: green
        Layout.fillWidth: true

        enabled: checkBox.checked
        value: root.initValue.g
        from: 0
        to: 1
        stepSize: 0.01

        onMoved: updateValue()

        Rectangle {
            anchors.fill: parent
            color: "#2200FF00"
        }
    }

    Slider {
        id: blue
        Layout.fillWidth: true

        enabled: checkBox.checked
        value: root.initValue.b
        from: 0
        to: 1
        stepSize: 0.01

        onMoved: updateValue()

        Rectangle {
            anchors.fill: parent
            color: "#220000FF"
        }
    }

    Slider {
        id: alpha
        Layout.fillWidth: true

        enabled: checkBox.checked
        value: root.initValue.a
        from: 0
        to: 1
        stepSize: 0.01

        onMoved: updateValue()
    }
}
