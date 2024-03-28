/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import org.kde.plasma.plasma5support as P5Support

// Replace by QML plugin when it will be available: https://invent.kde.org/plasma/plasma-workspace/-/issues/54
P5Support.DataSource {
    id: executable

    signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)

    function exec(cmd) {
        if (cmd)
            connectSource(cmd);
    }

    engine: "executable"
    connectedSources: []
    onNewData: function (sourceName, data) {
        var exitCode = data["exit code"];
        var exitStatus = data["exit status"];
        var stdout = data["stdout"];
        var stderr = data["stderr"];
        exited(sourceName, exitCode, exitStatus, stdout, stderr);
        disconnectSource(sourceName);
    }
}
