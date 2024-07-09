/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import org.kde.kwindowsystem

QtObject {
    property bool showingDesktop: KWindowSystem.showingDesktop
}
