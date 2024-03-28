/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: listItemsContainer

    property alias model: listItemsRepeater.model
    property Component sourceComponent

    RowLayout {
        Component {
            id: listItemDelegate

            MouseArea {
                id: dragArea

                required property var modelData

                drag.axis: Drag.XAxis
                drag.target: contentLoader
                Layout.preferredWidth: contentLoader.width
                Layout.preferredHeight: contentLoader.height

                DropArea {
                    anchors.fill: parent
                    anchors.margins: 5
                    onEntered: drag => {
                        listItemsRepeater.model.move(drag.source.DelegateModel.itemsIndex, dragArea.DelegateModel.itemsIndex, 1);
                    }
                }

                Loader {
                    id: contentLoader

                    Drag.source: dragArea
                    Drag.active: dragArea.drag.active
                    Drag.hotSpot.x: width / 2
                    Drag.hotSpot.y: height / 2
                    onLoaded: item.modelData = modelData
                    sourceComponent: listItemsContainer.sourceComponent
                }

                states: State {
                    when: dragArea.drag.active

                    ParentChange {
                        target: contentLoader
                        parent: listItemsContainer
                    }

                    AnchorChanges {
                        target: contentLoader

                        anchors {
                            horizontalCenter: undefined
                            verticalCenter: undefined
                        }
                    }
                }
            }
        }

        Repeater {
            id: listItemsRepeater

            delegate: listItemDelegate
        }
    }
}
