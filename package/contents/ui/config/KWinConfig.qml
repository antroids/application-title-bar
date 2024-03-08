/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import "../"
import QtQuick

Item {
    readonly property string reconfigureCommand: "qdbus org.kde.KWin /KWin reconfigure"
    readonly property string setBorderlessMaximizedWindowsCommand: "kwriteconfig6 --file kwinrc --group Windows --key BorderlessMaximizedWindows "
    readonly property string getBorderlessMaximizedWindowsCommand: "kreadconfig6 --file kwinrc --group Windows --key BorderlessMaximizedWindows --default false"
    property var borderlessMaximizedWindows
    property var callbacksOnExited: []

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

}
