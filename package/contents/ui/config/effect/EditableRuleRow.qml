/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import "../../"
import "../../config"
import "../../config/effect"
import "../../common"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

RowLayout {
    id: root

    readonly property list<string> argumentFragments: ["ActiveWindowFlagCondition", "ActiveWindowStringCondition", "ActiveWindowRegExpCondition"]

    property RuleModel ruleModel: RuleModel {}
    required property JsonListModel effects
    signal rowRemoved

    ComboBox {
        Kirigami.FormData.label: i18n("Effect:")
        model: effects
        currentIndex: ruleModel.effectIndex
        textRole: "name"
        onActivated: function (index) {
            ruleModel.effectIndex = index;
        }
    }

    ComboBox {
        Kirigami.FormData.label: i18n("Type:")
        Layout.preferredWidth: Kirigami.Units.gridUnit * 4
        model: [i18n("Flag"), i18n("Value"), i18n("Regex")]
        currentIndex: ruleModel.conditionType
        onActivated: function (index) {
            ruleModel.conditionType = index;
        }
    }

    Loader {
        id: argumentFragmentLoader
        Layout.fillWidth: true
        source: argumentFragments[ruleModel.conditionType] + ".qml"

        Binding {
            when: argumentFragmentLoaderConnections.enabled
            target: argumentFragmentLoader.item
            property: "arg0"
            value: ruleModel.arg0
            delayed: true
        }

        Binding {
            when: argumentFragmentLoaderConnections.enabled
            target: argumentFragmentLoader.item
            property: "arg1"
            value: ruleModel.arg1
            delayed: true
        }

        Connections {
            id: argumentFragmentLoaderConnections

            enabled: argumentFragmentLoader.status === Loader.Ready
            target: argumentFragmentLoader.item
            function onArg0Updated(val) {
                ruleModel.arg0 = val;
            }
            function onArg1Updated(val) {
                ruleModel.arg1 = val;
            }
        }
    }

    Button {
        icon.name: "delete"
        onClicked: function () {
            root.rowRemoved();
        }
    }
}
