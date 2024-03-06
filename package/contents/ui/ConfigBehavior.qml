/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

KCM.SimpleKCM {
    id: page

    property alias cfg_windowTitleDragEnabled: windowTitleDragEnabled.checked
    property alias cfg_windowTitleDragThreshold: windowTitleDragThreshold.value
    property bool cfg_windowTitleDragEnabledDefault: true
    property real cfg_windowTitleDragThresholdDefault: 10

    Kirigami.FormLayout {
        anchors.left: parent.left
        anchors.right: parent.right

        RowLayout {
            anchors.left: parent.left

            Label {
                Layout.alignment: Qt.AlignLeft
                text: i18n("Window title drag:")
            }

            CheckBox {
                id: windowTitleDragEnabled

                text: i18n("enabled")
            }

            Label {
                Layout.alignment: Qt.AlignLeft
                text: i18n("Threshold:")
            }

            SpinBox {
                id: windowTitleDragThreshold

                Layout.alignment: Qt.AlignLeft
                from: 0
                to: 512
            }

        }

    }

}
