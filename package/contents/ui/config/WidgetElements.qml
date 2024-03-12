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

    Layout.fillWidth: true
    Kirigami.FormData.label: i18n("Elements:")
    Layout.preferredWidth: Kirigami.Units.gridUnit * 21

    Rectangle {
        z: 1
        border.color: Kirigami.Theme.textColor
        color: Kirigami.Theme.activeBackgroundColor
        height: Kirigami.Units.iconSizes.medium
        Layout.alignment: Qt.AlignLeft
        Layout.fillWidth: true

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

                    onLoaded: function() {
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

        }

    }

    Rectangle {
        id: elementRemoveArea

        z: 0
        border.color: Kirigami.Theme.textColor
        color: Kirigami.Theme.negativeBackgroundColor
        height: Kirigami.Units.iconSizes.medium
        width: Kirigami.Units.iconSizes.medium
        Layout.alignment: Qt.AlignLeft

        Kirigami.Icon {
            anchors.fill: parent
            source: "delete"
        }

        DropArea {
            id: dropArea

            property var dragSource

            anchors.fill: parent
            anchors.margins: 5
            onEntered: (dragEvent) => {
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
