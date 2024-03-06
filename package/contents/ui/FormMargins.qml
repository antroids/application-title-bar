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
    property alias leftValue: leftValue.value
    property alias topValue: topValue.value
    property alias bottomValue: bottomValue.value
    property alias rightValue: rightValue.value

    Label {
        Layout.alignment: Qt.AlignLeft
        text: parent.text
    }

    Label {
        Layout.alignment: Qt.AlignLeft
        text: i18n("left")
    }

    SpinBox {
        id: leftValue
        Layout.alignment: Qt.AlignLeft
        from: parent.from
        to: parent.to
    }

    Label {
        Layout.alignment: Qt.AlignLeft
        text: i18n("top")
    }

    SpinBox {
        id: topValue
        Layout.alignment: Qt.AlignLeft
        from: parent.from
        to: parent.to
    }

    Label {
        Layout.alignment: Qt.AlignLeft
        text: i18n("bottom")
    }

    SpinBox {
        id: bottomValue
        Layout.alignment: Qt.AlignLeft
        from: parent.from
        to: parent.to
    }

    Label {
        Layout.alignment: Qt.AlignLeft
        text: i18n("right")
    }

    SpinBox {
        id: rightValue
        Layout.alignment: Qt.AlignLeft
        from: parent.from
        to: parent.to
    }
}