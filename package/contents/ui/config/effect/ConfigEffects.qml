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
import QtQuick.Effects
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

KCM.SimpleKCM {
    id: page

    property alias cfg_effects: effectsListModel.stringListModel
    property alias cfg_effectRules: rulesListModel.stringListModel

    verticalScrollBarPolicy: ScrollBar.AlwaysOff

    JsonListModel {
        id: effectsListModel
        tempModel: EffectModel {}
    }

    JsonListModel {
        id: rulesListModel
        tempModel: RuleModel {}

        function removeConnectedRulesAndEffect(index) {
            for (let i = rulesListModel.count - 1; i >= 0; i--) {
                const rule = rulesListModel.get(i);
                if (rule.effectIndex === index) {
                    rulesListModel.deleteModel(i);
                } else if (rule.effectIndex > index) {
                    rulesRepeater.itemAt(i).ruleModel.effectIndex = rule.effectIndex - 1;
                }
            }
            effectsListModel.deleteModel(index);
        }
    }

    Dialog {
        id: removeConnectedRulesDialog
        title: i18n("Remove Effect and connected Rules")
        standardButtons: Dialog.Ok | Dialog.Cancel
        width: 400
        modal: true

        onAccepted: rulesListModel.removeConnectedRulesAndEffect(effectIndex)

        property int connectedRulesCount: 0
        property int effectIndex: 0

        contentItem: Text {
            wrapMode: Text.WordWrap
            text: i18n("%1 Rules are connected to the Effect and will be removed.", removeConnectedRulesDialog.connectedRulesCount)
        }
    }

    TabBar {
        id: bar

        anchors.top: parent.top
        width: page.width
        TabButton {
            text: i18n("Effects")
            contentItem: tabsLayout
        }
        TabButton {
            text: i18n("Rules")
            contentItem: tabsLayout
        }
    }

    Frame {
        anchors.top: bar.bottom
        width: parent.width
        height: page.height - bar.height - Kirigami.Units.mediumSpacing

        StackLayout {
            id: tabsLayout
            anchors.fill: parent
            currentIndex: bar.currentIndex

            ScrollView {
                id: effectsScrollView

                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    width: effectsScrollView.availableWidth
                    RowLayout {
                        Button {
                            text: i18n("Add Effect")
                            onClicked: function () {
                                const effectName = effectsRepeater.getUniqueEffectName();
                                effectsListModel.pushModel({
                                    name: effectName,
                                    maskEnabled: false,
                                    maskInverted: false
                                });
                            }
                        }
                        AddPresetEffect {
                            Layout.preferredWidth: Kirigami.Units.gridUnit * 10
                            onActivated: function (index) {
                                const effectName = effectsRepeater.getUniqueEffectName(textAt(index));
                                const effectModel = valueAt(index);
                                effectModel.name = effectName;
                                effectsListModel.pushModel(effectModel);
                            }
                        }
                    }

                    Repeater {
                        id: effectsRepeater

                        model: effectsListModel

                        onItemAdded: function (index, item) {
                            item.effectModel.updateFromJsonObject(model.get(index));
                        }

                        function getUniqueEffectName(effectPrefix) {
                            const prefix = effectPrefix || "Effect";
                            let name = prefix;

                            outer: for (let i = 1; i < Number.MAX_SAFE_INTEGER; i++) {
                                for (let index = 0; index < count; index++) {
                                    if (model.get(index).name == name) {
                                        name = prefix + " " + i;
                                        continue outer;
                                    }
                                }
                                return name;
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: editableEffectRow.implicitHeight + Kirigami.Units.mediumSpacing * 2
                            border.color: Kirigami.Theme.disabledTextColor
                            radius: Kirigami.Units.cornerRadius
                            color: Kirigami.Theme.backgroundColor

                            property alias effectModel: editableEffectRow.effectModel

                            required property int index
                            required property var modelData

                            EditableEffectRow {
                                id: editableEffectRow
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.margins: Kirigami.Units.mediumSpacing

                                onRowRemoved: function () {
                                    let connectedRulesCount = 0;
                                    for (let i = 0; i < rulesListModel.count; i++) {
                                        const rule = rulesListModel.get(i);
                                        if (rule.effectIndex === index) {
                                            connectedRulesCount++;
                                        }
                                    }
                                    if (connectedRulesCount === 0) {
                                        rulesListModel.removeConnectedRulesAndEffect(index);
                                    } else {
                                        removeConnectedRulesDialog.effectIndex = index;
                                        removeConnectedRulesDialog.connectedRulesCount = connectedRulesCount;
                                        removeConnectedRulesDialog.open();
                                    }
                                }
                            }

                            Connections {
                                target: effectModel
                                function onPropertyChanged(propertyName, propertyValue) {
                                    effectsListModel.setProperty(index, propertyName, propertyValue);
                                    effectsListModel.updateConfigFromModel();
                                }
                            }
                        }
                    }
                }
            }
            ScrollView {
                id: rulesScrollView

                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    width: rulesScrollView.availableWidth
                    Button {
                        text: i18n("Add Effect Rule")
                        onClicked: function () {
                            rulesListModel.pushModel({
                                effectIndex: 0,
                                conditionType: 0,
                                arg0: "maximized",
                                arg1: true
                            });
                        }
                    }

                    Repeater {
                        id: rulesRepeater

                        model: rulesListModel

                        onItemAdded: function (index, item) {
                            item.ruleModel.updateFromJsonObject(model.get(index));
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: editableRuleRow.implicitHeight + Kirigami.Units.mediumSpacing * 2
                            border.color: Kirigami.Theme.disabledTextColor
                            radius: Kirigami.Units.cornerRadius
                            color: Kirigami.Theme.backgroundColor

                            property alias ruleModel: editableRuleRow.ruleModel

                            required property int index
                            required property var modelData

                            EditableRuleRow {
                                id: editableRuleRow
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.margins: Kirigami.Units.mediumSpacing

                                effects: effectsListModel

                                onRowRemoved: function () {
                                    rulesRepeater.model.deleteModel(index);
                                }
                            }

                            Connections {
                                target: ruleModel
                                function onPropertyChanged(propertyName, propertyValue) {
                                    rulesListModel.setProperty(index, propertyName, propertyValue);
                                    rulesListModel.updateConfigFromModel();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
