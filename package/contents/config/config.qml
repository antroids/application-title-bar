/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import QtQuick
import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: i18n("Appearance")
        icon: "preferences-desktop-color"
        source: "config/ConfigAppearance.qml"
    }

    ConfigCategory {
        name: i18n("Behavior")
        icon: "preferences-desktop"
        source: "config/ConfigBehavior.qml"
    }

    ConfigCategory {
        name: i18n("Replacements")
        icon: "document-replace"
        source: "config/TitleReplacements.qml"
    }
}
