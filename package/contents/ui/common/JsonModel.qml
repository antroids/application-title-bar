/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Effects

QtObject {
    id: model

    required property list<string> _propertyNames

    signal propertyChanged(string propertyName, var propertyValue)

    Component.onCompleted: {
        for (const propertyName of model._propertyNames) {
            model[propertyName + "Changed"].connect(function () {
                propertyChanged(propertyName, model[propertyName]);
            });
        }
    }

    function toJson() {
        let cloned = toJsonObject();
        return JSON.stringify(cloned);
    }

    function toJsonObject() {
        let cloned = {};
        for (const propertyName of model._propertyNames) {
            const value = model[propertyName];
            if (value !== undefined && value !== null) {
                cloned[propertyName] = value;
            }
        }
        return cloned;
    }

    function updateFromJson(json) {
        const obj = JSON.parse(json);
        updateFromJsonObject(obj);
    }

    function updateFromJsonObject(jsonObject) {
        for (const propertyName of model._propertyNames) {
            const value = jsonObject[propertyName];
            model[propertyName] = value === null ? undefined : value;
        }
    }
}
