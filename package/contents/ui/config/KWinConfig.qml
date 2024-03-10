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
    readonly property string reconfigureCommand: "qdbus org.kde.KWin /KWin reconfigure"
    readonly property string setBorderlessMaximizedWindowsCommand: "kwriteconfig6 --file kwinrc --group Windows --key BorderlessMaximizedWindows "
    readonly property string getBorderlessMaximizedWindowsCommand: "kreadconfig6 --file kwinrc --group Windows --key BorderlessMaximizedWindows --default false"
    property var borderlessMaximizedWindows
    property var callbacksOnExited: []
    property var auroraeThemesLocations: StandardPaths.locateAll(StandardPaths.GenericDataLocation, auroraeThemesPath, StandardPaths.LocateDirectory)
    property ListModel auroraeThemes

    function setBorderlessMaximizedWindows(val) {
        let cmd = setBorderlessMaximizedWindowsCommand + val + " && " + reconfigureCommand + " && " + getBorderlessMaximizedWindowsCommand;
        callbacksOnExited.push({
            "cmd": cmd,
            "callback": function(cmd, exitCode, exitStatus, stdout, stderr) {
                borderlessMaximizedWindows = stdout.trim() == "true";
            }
        });
        executable.exec(cmd);
    }

    function updateBorderlessMaximizedWindows() {
        let cmd = getBorderlessMaximizedWindowsCommand;
        callbacksOnExited.push({
            "cmd": cmd,
            "callback": function(cmd, exitCode, exitStatus, stdout, stderr) {
                borderlessMaximizedWindows = stdout.trim() == "true";
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

    ExecutableDataSource {
        id: executable
    }

    Connections {
        function onExited(cmd, exitCode, exitStatus, stdout, stderr) {
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

}
