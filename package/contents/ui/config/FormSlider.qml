/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

RowLayout {
    anchors.left: parent.left
    anchors.right: parent.right

    property var text: ""
    property var from: 0
    property var to: 100
    property var stepSize: 1
    property alias value: slider.value

    Label {
        Layout.alignment: Qt.AlignLeft
        text: parent.text
    }

    Slider {
        id: slider
        Layout.alignment: Qt.AlignHCenter
        Layout.fillWidth: true
        from: parent.from
        to: parent.to
        stepSize: parent.stepSize
    }

    SpinBox {
        id: spin
        Layout.alignment: Qt.AlignRight
        value: slider.value
        from: parent.from
        to: parent.to
    }

    Binding {
        slider.value: spin.value
    }
}
