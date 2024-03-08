/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */


function copyLayoutConstraint(from, to) {
    Object.assign(to.Layout, {
        "alignment": Qt.binding(function () { return from.Layout.alignment }),
        "bottomMargin": Qt.binding(function () { return from.Layout.bottomMargin }),
        "column": Qt.binding(function () { return from.Layout.column }),
        "columnSpan": Qt.binding(function () { return from.Layout.columnSpan }),
        "fillHeight": Qt.binding(function () { return from.Layout.fillHeight }),
        "fillWidth": Qt.binding(function () { return from.Layout.fillWidth }),
        "horizontalStretchFactor": Qt.binding(function () { return from.Layout.horizontalStretchFactor }),
        "leftMargin": Qt.binding(function () { return from.Layout.leftMargin }),
        "maximumHeight": Qt.binding(function () { return from.Layout.maximumHeight }),
        "maximumWidth": Qt.binding(function () { return from.Layout.maximumWidth }),
        "minimumHeight": Qt.binding(function () { return from.Layout.minimumHeight }),
        "minimumWidth": Qt.binding(function () { return from.Layout.minimumWidth }),
        "preferredHeight": Qt.binding(function () { return from.Layout.preferredHeight }),
        "preferredWidth": Qt.binding(function () { return from.Layout.preferredWidth }),
        "rightMargin": Qt.binding(function () { return from.Layout.rightMargin }),
        "row": Qt.binding(function () { return from.Layout.row }),
        "rowSpan": Qt.binding(function () { return from.Layout.rowSpan }),
        "topMargin": Qt.binding(function () { return from.Layout.topMargin }),
        "verticalStretchFactor": Qt.binding(function () { return from.Layout.verticalStretchFactor })
    })
}