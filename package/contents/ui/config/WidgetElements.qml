/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import "../"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents

RowLayout {
    id: widgetElements

    property alias model: sortableItemsRow.model

    Layout.fillWidth: true
    Kirigami.FormData.label: i18n("Elements:")
    Layout.preferredWidth: Kirigami.Units.gridUnit * 20

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

            Component {
                id: windowCloseButton

                Kirigami.Icon {
                    source: "window-close"
                    height: Kirigami.Units.iconSizes.medium
                    width: Kirigami.Units.iconSizes.medium
                }

            }

            Component {
                id: windowMinimizeButton

                Kirigami.Icon {
                    source: "window-minimize"
                    height: Kirigami.Units.iconSizes.medium
                    width: Kirigami.Units.iconSizes.medium
                }

            }

            Component {
                id: windowMaximizeButton

                Kirigami.Icon {
                    source: "window-maximize"
                    height: Kirigami.Units.iconSizes.medium
                    width: Kirigami.Units.iconSizes.medium
                }

            }

            Component {
                id: windowTitle

                PlasmaComponents.Label {
                    text: i18n("Window title")
                    font.pointSize: page.cfg_windowTitleFontSize
                    font.bold: page.cfg_windowTitleFontBold
                    fontSizeMode: page.cfg_windowTitleFontSizeMode
                    maximumLineCount: 1
                    elide: Text.ElideRight
                    wrapMode: Text.WrapAnywhere
                }

            }

            Component {
                id: windowIcon

                Kirigami.Icon {
                    source: "window"
                    height: Kirigami.Units.iconSizes.medium
                    width: Kirigami.Units.iconSizes.medium
                }

            }

            sourceComponent: Loader {
                property var modelData

                function getElementComponent(value) {
                    switch (value) {
                    case "windowCloseButton":
                        return windowCloseButton;
                    case "windowMinimizeButton":
                        return windowMinimizeButton;
                    case "windowMaximizeButton":
                        return windowMaximizeButton;
                    case "windowTitle":
                        return windowTitle;
                    case "windowIcon":
                        return windowIcon;
                    }
                }

                sourceComponent: modelData ? getElementComponent(modelData) : null
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
