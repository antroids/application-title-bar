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
    property string setBorderlessMaximizedWindowsCommand: kwriteconfigCommandName !== "" ? kwriteconfigCommandName + " --file kwinrc --group Windows --key BorderlessMaximizedWindows " : ""
    property string getBorderlessMaximizedWindowsCommand: kreadconfigCommandName !== "" ? kreadconfigCommandName + " --file kwinrc --group Windows --key BorderlessMaximizedWindows --default false" : ""
    property string reconfigureCommand: qdbusCommandName !== "" ? qdbusCommandName + " org.kde.KWin /KWin reconfigure" : ""
    property string getAllKWinShortcutNamesCommand: qdbusCommandName !== "" ? qdbusCommandName + " org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.shortcutNames" : ""
    property string invokeKWinShortcutCommand: qdbusCommandName !== "" ? qdbusCommandName + " org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.invokeShortcut " : ""
    property var borderlessMaximizedWindows
    property var callbacksOnExited: []
    property var auroraeThemesLocations: StandardPaths.locateAll(StandardPaths.GenericDataLocation, auroraeThemesPath, StandardPaths.LocateDirectory)
    property ListModel auroraeThemes
    property var shortcutNames: []
    property string qdbusCommandName: "qdbus"
    property string kwriteconfigCommandName: "kwriteconfig6"
    property string kreadconfigCommandName: "kreadconfig6"
    property string lastError: ""

    function findExistingFromListCommand(commandsList) {
        let cmd = "";
        if (commandsList) {
            cmd += "if command -v " + commandsList[0] + " > /dev/null; then echo " + commandsList[0] + "; ";
            for (const c of commandsList.slice(1)) {
                cmd += "elif command -v " + c + " > /dev/null; then echo " + c + "; ";
            }
            cmd += "else exit 1; fi";
        }
        return cmd;
    }

    function setBorderlessMaximizedWindows(val) {
        if (setBorderlessMaximizedWindowsCommand === "") {
            return;
        }
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
        if (getBorderlessMaximizedWindowsCommand === "") {
            return;
        }
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
        if (getAllKWinShortcutNamesCommand === "") {
            return;
        }
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

    function updateQdbusCommandName() {
        updateCommandName(["qdbus", "qdbus6", "qdbus-qt6"], function (commandName) {
            qdbusCommandName = commandName;
            qdbusCommandNameChanged();
        });
    }

    function updateKwriteconfigCommandName() {
        updateCommandName(["kwriteconfig6", "kwriteconfig"], function (commandName) {
            kwriteconfigCommandName = commandName;
            kwriteconfigCommandNameChanged();
        });
    }

    function updateKreadconfigCommandName() {
        updateCommandName(["kreadconfig6", "kreadconfig"], function (commandName) {
            kreadconfigCommandName = commandName;
            kreadconfigCommandNameChanged();
        });
    }

    function updateCommandName(commandsList, setCommandNameCallback) {
        const cmd = findExistingFromListCommand(commandsList);
        callbacksOnExited.push({
            "cmd": cmd,
            "callback": function (cmd, exitCode, exitStatus, stdout, stderr) {
                if (exitCode == 0) {
                    setCommandNameCallback(stdout.trim());
                } else {
                    setCommandNameCallback("");
                    lastError = "Unable to find command from list: " + commandsList;
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

    auroraeThemes: ListModel {}

    Component.onCompleted: function () {
        updateQdbusCommandName();
        updateKwriteconfigCommandName();
        updateKreadconfigCommandName();
    }

    onQdbusCommandNameChanged: function () {
        updateKWinShortcutNames();
    }

    onKreadconfigCommandNameChanged: function () {
        updateBorderlessMaximizedWindows();
    }
}
