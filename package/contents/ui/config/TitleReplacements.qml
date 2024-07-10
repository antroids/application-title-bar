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

    ListModel {
        id: replacementsModel

        function updateModelFromConfig() {
            clear();
            for (let i = 0; i < cfg_titleReplacementsPatterns.length; i++) {
                append({
                    "pattern": cfg_titleReplacementsPatterns[i],
                    "template": cfg_titleReplacementsTemplates[i],
                    "type": cfg_titleReplacementsTypes[i]
                });
            }
        }

        function updateConfigFromModel() {
            Qt.callLater(_updateConfigFromModel);
        }

        function _updateConfigFromModel() {
            const length = count;
            cfg_titleReplacementsPatterns.length = length;
            cfg_titleReplacementsTemplates.length = length;
            cfg_titleReplacementsTypes.length = length;
            for (let i = 0; i < length; i++) {
                const rowValue = get(i);
                cfg_titleReplacementsPatterns[i] = rowValue.pattern;
                cfg_titleReplacementsTemplates[i] = rowValue.template;
                cfg_titleReplacementsTypes[i] = rowValue.type;
            }
        }

        function pushNewReplacement() {
            append({
                "pattern": "",
                "template": "",
                "type": TitleReplacements.Type.String
            });
            updateConfigFromModel();
        }

        function deleteReplacement(index) {
            remove(index);
            updateConfigFromModel();
        }

        function setType(index, type) {
            set(index, {
                "type": type
            });
            updateConfigFromModel();
        }

        function setPattern(index, pattern) {
            set(index, {
                "pattern": pattern
            });
            updateConfigFromModel();
        }

        function setTemplate(index, template) {
            set(index, {
                "template": template
            });
            updateConfigFromModel();
        }

        function moveReplacement(from, to) {
            move(from, to, 1);
            updateConfigFromModel();
        }

        Component.onCompleted: updateModelFromConfig()
    }

    ColumnLayout {
        RowLayout {
            Button {
                text: i18n("Add Title Replacement")
                onClicked: replacementsModel.pushNewReplacement()
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

            model: replacementsModel
            delegate: RowLayout {
                id: replacement
                required property int index
                required property var modelData

                Drag.source: dragArea
                Drag.active: dragArea.drag.active
                Drag.hotSpot.y: height / 2

                Kirigami.Icon {
                    Layout.maximumWidth: Kirigami.Units.gridUnit

                    source: "transform-move-vertical"
                    MouseArea {
                        id: dragArea
                        anchors.fill: parent
                        drag.axis: Drag.YAxis
                        drag.target: replacement
                        cursorShape: Qt.DragMoveCursor

                        drag {
                            onActiveChanged: function () {
                                if (!drag.active) {
                                    replacementsModel.updateModelFromConfig();
                                }
                            }
                        }

                        states: State {
                            when: dragArea.drag.active

                            PropertyChanges {
                                target: replacement
                                z: 1
                            }
                        }

                        DropArea {
                            anchors.fill: parent
                            onEntered: drag => {
                                replacementsModel.moveReplacement(drag.source.DelegateModel.itemsIndex, dragArea.DelegateModel.itemsIndex);
                            }
                        }
                    }
                }

                ComboBox {
                    id: titleReplacementsType
                    Layout.maximumWidth: Kirigami.Units.gridUnit * 5

                    model: [i18n("String"), i18n("RegExp")]
                    onActivated: function () {
                        replacementsModel.setType(index, currentIndex);
                    }
                    currentIndex: modelData.type
                }

                TextField {
                    id: titleReplacementsPattern

                    onTextEdited: function () {
                        replacementsModel.setPattern(index, text);
                    }
                    Layout.alignment: Qt.AlignLeft
                    text: modelData.pattern
                }

                Label {
                    text: "=>"
                }

                TextField {
                    id: titleReplacementsTemplate

                    onTextEdited: function () {
                        replacementsModel.setTemplate(index, text);
                    }
                    Layout.alignment: Qt.AlignLeft
                    text: modelData.template
                }

                Button {
                    icon.name: "delete"
                    onClicked: function () {
                        replacementsModel.deleteReplacement(replacement.index);
                    }
                }
            }
        }
        RowLayout {
            visible: replacementsRepeater.count > 5
            Button {
                text: i18n("Add Title Replacement")
                onClicked: replacementsModel.pushNewReplacement()
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
                target: replacementsModel

                function onDataChanged() {
                    testOutput.updateTestOutput();
                }

                function onRowsRemoved() {
                    testOutput.updateTestOutput();
                }
            }

            function _updateTestOutput() {
                let outputText = testInput.text;
                for (let i = 0; i < replacementsModel.count; i++) {
                    const rowValue = replacementsModel.get(i);
                    const replacement = Utils.Replacement.createReplacement(rowValue.type, rowValue.pattern, rowValue.template);
                    outputText = replacement.replace(outputText);
                }
                testOutput.text = outputText;
            }

            function updateTestOutput() {
                Qt.callLater(_updateTestOutput);
            }

            Component.onCompleted: updateTestOutput()
        }
    }
}
