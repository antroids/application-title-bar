/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import "../"
import "../utils.js" as Utils
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

RowLayout {
    id: widgetElements

    property alias model: sortableItemsRow.model
    property var iconSize: Kirigami.Units.iconSizes.medium
    property var elements: []

    Kirigami.Theme.colorSet: Kirigami.Theme.View
    Kirigami.Theme.inherit: false

    Layout.fillWidth: true
    Layout.preferredWidth: Kirigami.Units.gridUnit * 21
    spacing: 0

    Component.onCompleted: function () {
        model.ignoreInsertEvent = true;
        for (var i = 0; i < elements.length; i++) {
            model.append({
                "value": elements[i]
            });
        }
        model.ignoreInsertEvent = false;
    }

    model: ListModel {
        property bool ignoreInsertEvent: false

        function updateConfigFromModel() {
            elements = [];
            for (var i = 0; i < count; i++) {
                elements.push(get(i).value);
            }
        }

        onRowsMoved: updateConfigFromModel()
        onRowsRemoved: updateConfigFromModel()
        onRowsInserted: ignoreInsertEvent || updateConfigFromModel()
    }

    Rectangle {
        z: 1
        border.color: Kirigami.Theme.disabledTextColor
        color: Kirigami.Theme.backgroundColor
        height: Kirigami.Units.iconSizes.medium
        Layout.alignment: Qt.AlignLeft
        Layout.fillWidth: true
        Layout.margins: 1
        radius: 2

        SortableItemsRow {
            id: sortableItemsRow

            anchors.fill: parent
            sourceComponent: widgetElementLoaderDelegate

            Component {
                id: widgetElementLoaderDelegate

                Loader {
                    id: widgetElementLoader

                    property var modelData
                    property var elementModel: Utils.widgetElementModelFromName(modelData)

                    onLoaded: function () {
                        item.modelData = elementModel;
                    }
                    sourceComponent: {
                        switch (elementModel.type) {
                        case WidgetElement.Type.WindowControlButton:
                            return windowControlButton;
                        case WidgetElement.Type.WindowTitle:
                            return windowTitle;
                        case WidgetElement.Type.WindowIcon:
                            return windowIcon;
                        case WidgetElement.Type.Spacer:
                            return spacerIcon;
                        }
                    }
                }
            }

            Component {
                id: windowControlButton

                WindowControlButton {
                    id: windowControlButton

                    property var modelData

                    height: widgetElements.iconSize
                    width: widgetElements.iconSize
                    buttonType: modelData.windowControlButtonType
                    mouseAreaEnabled: false
                }
            }

            Component {
                id: windowTitle

                PlasmaComponents.Label {
                    property var modelData

                    text: i18n("Title")
                    font.bold: page.cfg_windowTitleFontBold
                    maximumLineCount: 1
                    elide: Text.ElideRight
                    wrapMode: Text.WrapAnywhere
                    verticalAlignment: Text.AlignVCenter
                    height: widgetElements.iconSize
                    width: widgetElements.iconSize
                }
            }

            Component {
                id: windowIcon

                Kirigami.Icon {
                    property var modelData

                    source: "window"
                    height: widgetElements.iconSize
                    width: widgetElements.iconSize
                }
            }

            Component {
                id: spacerIcon

                Kirigami.Icon {
                    property var modelData

                    source: "adjustcol"
                    height: widgetElements.iconSize
                    width: widgetElements.iconSize / 2
                }
            }
        }
    }

    Rectangle {
        id: elementRemoveArea

        z: 0
        border.color: Kirigami.Theme.disabledTextColor
        color: Kirigami.Theme.negativeBackgroundColor
        height: Kirigami.Units.iconSizes.medium
        width: Kirigami.Units.iconSizes.medium
        Layout.alignment: Qt.AlignLeft
        Layout.margins: 1
        radius: 2

        Kirigami.Icon {
            anchors.fill: parent
            source: "delete"
        }

        DropArea {
            id: dropArea

            property var dragSource

            anchors.fill: parent
            anchors.margins: 5
            onEntered: dragEvent => {
                dragSource = dragEvent.source;
            }
            onExited: () => {
                if (dragSource && !dragSource.pressed)
                    widgetElements.model.remove(dragSource.DelegateModel.itemsIndex);
                dragSource = undefined;
            }

            states: State {
                when: dropArea.dragSource !== undefined

                PropertyChanges {
                    elementRemoveArea.border.color: "red"
                }
            }
        }
    }
}
