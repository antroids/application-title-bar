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
    Layout.fillWidth: true
    Layout.leftMargin: Kirigami.Units.gridUnit
    Layout.rightMargin: Kirigami.Units.gridUnit
    property alias value: checkBox.checked
    property alias label: label.text

    signal valueUpdated(var updatedValue)

    Label {
        id: label
        text: "CheckBox"
        Layout.preferredWidth: 200
    }

    CheckBox {
        id: checkBox

        onToggled: function () {
            valueUpdated(checked);
        }
    }
}
