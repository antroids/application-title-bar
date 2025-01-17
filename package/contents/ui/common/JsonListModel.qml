/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick

ListModel {
    id: effectsListModel

    required property var tempModel
    property list<string> stringListModel
    dynamicRoles: true

    function updateModelFromConfig() {
        clear();
        for (let i = 0; i < stringListModel.length; i++) {
            const effectJson = stringListModel[i];
            tempModel.updateFromJson(effectJson);
            append(tempModel.toJsonObject());
        }
    }

    function updateConfigFromModel() {
        Qt.callLater(_updateConfigFromModel);
    }

    function _updateConfigFromModel() {
        const length = count;
        stringListModel.length = length;
        for (let i = 0; i < length; i++) {
            tempModel.updateFromJsonObject(get(i));
            stringListModel[i] = tempModel.toJson();
        }
    }

    function pushModel(model) {
        tempModel.updateFromJsonObject(model);
        append(tempModel.toJsonObject());
        updateConfigFromModel();
    }

    function deleteModel(index) {
        remove(index);
        updateConfigFromModel();
    }

    Component.onCompleted: updateModelFromConfig()
}
