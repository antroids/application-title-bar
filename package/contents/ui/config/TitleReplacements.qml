/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import "../"
import "../config"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import "../utils.js" as Utils

KCM.SimpleKCM {
    id: page

    property list<string> cfg_titleReplacementsPatterns
    property list<string> cfg_titleReplacementsTemplates
    property list<int> cfg_titleReplacementsTypes

    enum Type {
        String,
        Regex
    }

    ColumnLayout {
        RowLayout {
            visible: replacementsRepeater.count > 5
            Button {
                text: i18n("Add Title Replacement")
                onClicked: pushNewReplacement()
            }
            Label {
                text: i18n("<a href=\"https://www.w3schools.com/jsref/jsref_obj_regexp.asp\">JavaScript RegExp Reference</a>")
                onLinkActivated: function (link) {
                    Qt.openUrlExternally(link);
                }
                verticalAlignment: Text.AlignVCenter
            }
        }
        Repeater {
            id: replacementsRepeater

            function updateModel() {
                model = cfg_titleReplacementsPatterns.length;
            }

            Component.onCompleted: updateModel()

            delegate: RowLayout {
                id: replacement
                required property int index

                ComboBox {
                    id: titleReplacementsType

                    model: [i18n("String"), i18n("RegExp")]
                    onActivated: function () {
                        cfg_titleReplacementsTypes[replacement.index] = currentIndex;
                    }
                    Component.onCompleted: currentIndex = cfg_titleReplacementsTypes[replacement.index]
                }

                TextField {
                    id: titleReplacementsPattern

                    onTextEdited: function () {
                        cfg_titleReplacementsPatterns[replacement.index] = text;
                    }
                    Layout.alignment: Qt.AlignLeft
                    Component.onCompleted: text = cfg_titleReplacementsPatterns[replacement.index]
                }

                Label {
                    text: "=>"
                }

                TextField {
                    id: titleReplacementsTemplate

                    onTextEdited: function () {
                        cfg_titleReplacementsTemplates[replacement.index] = text;
                    }
                    Layout.alignment: Qt.AlignLeft
                    Component.onCompleted: text = cfg_titleReplacementsTemplates[replacement.index]
                }

                Button {
                    icon.name: "delete"
                    onClicked: function () {
                        deleteReplacement(replacement.index);
                    }
                }
            }
        }
        RowLayout {
            Button {
                text: i18n("Add Title Replacement")
                onClicked: pushNewReplacement()
            }
            Label {
                text: i18n("<a href=\"https://www.w3schools.com/jsref/jsref_obj_regexp.asp\">JavaScript RegExp Reference</a>")
                onLinkActivated: function (link) {
                    Qt.openUrlExternally(link);
                }
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    footer: Kirigami.FormLayout {
        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Title Replacements Testing")
        }

        TextField {
            id: testInput

            Kirigami.FormData.label: i18n("Test input:")
            Layout.alignment: Qt.AlignLeft
            Layout.minimumWidth: 400

            text: "<Application> -- 123 Application title : Freeware / buy 3 - oneone"
        }

        TextField {
            id: testOutput

            Kirigami.FormData.label: i18n("Test output:")
            Layout.alignment: Qt.AlignLeft
            readOnly: true

            Connections {
                target: testInput

                function onTextChanged() {
                    testOutput.updateTestOutput();
                }
            }

            Connections {
                target: page

                function onCfg_titleReplacementsTypesChanged() {
                    testOutput.updateTestOutput();
                }

                function onCfg_titleReplacementsPatternsChanged() {
                    testOutput.updateTestOutput();
                }

                function onCfg_titleReplacementsTemplatesChanged() {
                    testOutput.updateTestOutput();
                }
            }

            function updateTestOutput() {
                const replacements = Utils.Replacement.createReplacementList(cfg_titleReplacementsTypes, cfg_titleReplacementsPatterns, cfg_titleReplacementsTemplates);
                testOutput.text = Utils.Replacement.applyReplacementList(testInput.text, replacements);
            }

            Component.onCompleted: updateTestOutput()
        }
    }

    function pushNewReplacement() {
        cfg_titleReplacementsTypes.push(TitleReplacements.Type.String);
        cfg_titleReplacementsTemplates.push("");
        cfg_titleReplacementsPatterns.push("");
        replacementsRepeater.updateModel();
    }

    function deleteReplacement(index) {
        cfg_titleReplacementsPatterns.splice(index, 1);
        cfg_titleReplacementsTypes.splice(index, 1);
        cfg_titleReplacementsTemplates.splice(index, 1);
        replacementsRepeater.updateModel();
    }
}
