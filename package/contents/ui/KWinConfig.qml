/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import "../"
import Qt.labs.folderlistmodel
import QtCore
import QtQuick

Item {
    id: kWinConfig

    readonly property string auroraeThemesPath: "aurorae/themes/"
    readonly property string setBorderlessMaximizedWindowsCommand: "kwriteconfig6 --file kwinrc --group Windows --key BorderlessMaximizedWindows "
    readonly property string getBorderlessMaximizedWindowsCommand: "kreadconfig6 --file kwinrc --group Windows --key BorderlessMaximizedWindows --default false"
    readonly property string checkQdbusApplicationNameCommand: "if command -v qdbus > /dev/null; then echo qdbus; elif command -v qdbus6 > /dev/null; then echo qdbus6; else exit 1; fi"
    property string reconfigureCommand: qdbusApplicationName + " org.kde.KWin /KWin reconfigure"
    property string getAllKWinShortcutNamesCommand: qdbusApplicationName + " org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.shortcutNames"
    property string invokeKWinShortcutCommand: qdbusApplicationName + " org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.invokeShortcut "
    property var borderlessMaximizedWindows
    property var callbacksOnExited: []
    property var auroraeThemesLocations: StandardPaths.locateAll(StandardPaths.GenericDataLocation, auroraeThemesPath, StandardPaths.LocateDirectory)
    property ListModel auroraeThemes
    property var shortcutNames: []
    property string qdbusApplicationName: "qdbus"
    property string lastError: ""

    function setBorderlessMaximizedWindows(val) {
        let cmd = setBorderlessMaximizedWindowsCommand + val + " && " + reconfigureCommand + " && " + getBorderlessMaximizedWindowsCommand;
        callbacksOnExited.push({
            "cmd": cmd,
            "callback": function (cmd, exitCode, exitStatus, stdout, stderr) {
                if (exitCode == 0) {
                    borderlessMaximizedWindows = stdout.trim() == "true";
                } else {
                    lastError = "Unable to update set BorderlessMaximizedWindows status: '" + stderr + "'";
                }
            }
        });
        executable.exec(cmd);
    }

    function updateBorderlessMaximizedWindows() {
        let cmd = getBorderlessMaximizedWindowsCommand;
        callbacksOnExited.push({
            "cmd": cmd,
            "callback": function (cmd, exitCode, exitStatus, stdout, stderr) {
                if (exitCode == 0) {
                    borderlessMaximizedWindows = stdout.trim() == "true";
                } else {
                    lastError = "Unable to update get BorderlessMaximizedWindows status: '" + stderr + "'";
                }
            }
        });
        executable.exec(cmd);
    }

    function updateAuroraeThemes() {
        auroraeThemes.clear();
        for (var locationIndex = 0; locationIndex < auroraeThemesLocationsRepeater.count; locationIndex++) {
            let locationItem = auroraeThemesLocationsRepeater.itemAt(locationIndex);
            for (var themeIndex = 0; themeIndex < locationItem.count; themeIndex++) {
                let themeModel = locationItem.itemAt(themeIndex);
                auroraeThemes.append({
                    "name": themeModel.fileName,
                    "folder": themeModel.fileName,
                    "path": themeModel.filePath
                });
            }
        }
        auroraeThemesChanged();
    }

    function updateKWinShortcutNames() {
        let cmd = getAllKWinShortcutNamesCommand;
        callbacksOnExited.push({
            "cmd": cmd,
            "callback": function (cmd, exitCode, exitStatus, stdout, stderr) {
                if (exitCode == 0) {
                    shortcutNames = stdout.trim().split(/\r?\n/).sort();
                } else {
                    lastError = "Unable to update KWin shortcuts: '" + stderr + "'";
                }
            }
        });
        executable.exec(cmd);
    }

    function invokeKWinShortcut(shortcut) {
        let cmd = invokeKWinShortcutCommand;
        let trimmedShortcut = shortcut.trim();
        if (shortcutNames.length === 0 || shortcutNames.includes(trimmedShortcut))
            executable.exec(cmd + "\"" + trimmedShortcut + "\"");
        else
            print("Error: shortcut '" + trimmedShortcut + "' not found in the list!");
    }

    function updateQdbusApplicationName() {
        let cmd = checkQdbusApplicationNameCommand;
        callbacksOnExited.push({
            "cmd": cmd,
            "callback": function (cmd, exitCode, exitStatus, stdout, stderr) {
                if (exitCode == 0) {
                    qdbusApplicationName = stdout.trim();
                    qdbusApplicationNameChanged();
                } else {
                    lastError = "Unable to find QDbus command";
                }
            }
        });
        executable.exec(cmd);
    }

    function clearLastError() {
        lastError = "";
    }

    ExecutableDataSource {
        id: executable
    }

    Connections {
        function onExited(cmd, exitCode, exitStatus, stdout, stderr) {
            //print("onExited: cmd: " + cmd + "; exitCode:" + exitCode + "; stdout: " + stdout + "; stderr: " + stderr);
            if (exitCode == 0) {
                clearLastError();
            }
            for (var i = 0; i < callbacksOnExited.length; i++) {
                if (callbacksOnExited[i].cmd === cmd) {
                    callbacksOnExited[i].callback(cmd, exitCode, exitStatus, stdout, stderr);
                    callbacksOnExited.splice(i, 1);
                    break;
                }
            }
        }

        target: executable
    }

    Repeater {
        id: auroraeThemesLocationsRepeater

        model: auroraeThemesLocations

        delegate: Repeater {
            required property string modelData

            model: FolderListModel {
                folder: modelData
                showDirs: true
                showFiles: false
                showHidden: true
                onCountChanged: kWinConfig.updateAuroraeThemes()
            }

            delegate: Item {
                required property string fileName
                required property string filePath
            }
        }
    }

    auroraeThemes: ListModel {
    }

    Component.onCompleted: function () {
        updateQdbusApplicationName();
    }

    onQdbusApplicationNameChanged: function () {
        updateBorderlessMaximizedWindows();
        updateKWinShortcutNames();
    }
}
