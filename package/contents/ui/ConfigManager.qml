/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import QtCore
import QtQuick.Dialogs

Loader {
    id: settingsLoader

    active: false

    property string name
    property date dateCreated
    property string settingsJson
    property url location
    property bool writeMode: true

    signal configSaved(url fileUrl)
    signal configLoaded(url fileUrl, var settings)

    property var configExportFileDialog: FileDialog {
        nameFilters: ["Configuration (*.cfg)"]
        defaultSuffix: "cfg"
        fileMode: FileDialog.SaveFile
        onAccepted: savePlasmoidConfig(selectedFile)
    }

    property var configImportFileDialog: FileDialog {
        nameFilters: ["Configuration (*.cfg)"]
        defaultSuffix: "cfg"
        fileMode: FileDialog.OpenFile
        onAccepted: loadPlasmoidConfig(selectedFile)
    }

    sourceComponent: Settings {
        location: settingsLoader.location
        property int version: 0
        property string name
        property date dateCreated
        property string settingsJson
    }

    onLoaded: function () {
        if (writeMode) {
            item.name = name;
            item.dateCreated = new Date();
            item.settingsJson = settingsJson;
            configSaved(item.location);
        } else {
            name = item.value("name", "");
            dateCreated = item.value("dateCreated", new Date());
            settingsJson = item.value("settingsJson", "{}");
            configLoaded(item.location, JSON.parse(settingsJson));
        }
        active = false;
    }

    function showConfigExportFileDialog() {
        configExportFileDialog.open();
    }

    function showConfigImportFileDialog() {
        configImportFileDialog.open();
    }

    function saveSettings(name, settings, fileUrl) {
        name = name;
        settingsJson = JSON.stringify(settings);
        location = fileUrl;
        writeMode = true;
        active = true;
    }

    function loadSettings(fileUrl) {
        location = fileUrl;
        writeMode = false;
        active = true;
    }

    function getPlasmoidConfig() {
        let configMap = {};
        const config = plasmoid.configuration;
        const propertyNames = config.keys();
        for (let index = 0; index < propertyNames.length; index++) {
            const propertyName = propertyNames[index];
            const propertyValue = config[propertyName];
            configMap[propertyName] = propertyValue;
        }
        return configMap;
    }

    function savePlasmoidConfig(fileUrl) {
        const config = getPlasmoidConfig();
        saveSettings("Application Title Bar Configuration", config, fileUrl);
    }

    function loadPlasmoidConfig(fileUrl) {
        const loadedConfig = loadSettings(fileUrl);
    }

    function updatePlasmoidConfig(loadedConfig) {
        let plasmoidConfig = plasmoid.configuration;
        for (const propertyName in loadedConfig) {
            let loadedValue = loadedConfig[propertyName];
            let loadedValueString = JSON.stringify(loadedValue);
            let plasmoidValue = plasmoidConfig[propertyName];
            let plasmoidValueString = JSON.stringify(plasmoidValue);
            if (loadedValueString !== plasmoidValueString && !plasmoidConfig.isImmutable(propertyName)) {
                //console.log("Diff in " + propertyName + " : '" + plasmoidConfig[propertyName] + "' !== '" + loadedValue + "'");
                plasmoidConfig[propertyName] = loadedValue;
            }
        }
    }
}
