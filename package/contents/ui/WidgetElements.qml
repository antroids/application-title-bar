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

RowLayout {
    id: widgetElements

    property alias model: sortableItemsRow.model

    anchors.left: parent.left
    anchors.right: parent.right

    Label {
        Layout.alignment: Qt.AlignLeft
        text: i18n("Elements:")
    }

    Rectangle {
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
                    }
                }

                sourceComponent: modelData ? getElementComponent(modelData) : null
            }

        }

    }

}
