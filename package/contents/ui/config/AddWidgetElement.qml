/*
 * SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami

ComboBox {
    textRole: "name"
    valueRole: "value"
    displayText: currentText ? i18n(currentText) : ""

    model: ListModel {
        ListElement {
            name: "Add element..."
        }

        ListElement {
            name: "Window close button"
            value: "windowCloseButton"
        }

        ListElement {
            name: "Window minimize button"
            value: "windowMinimizeButton"
        }

        ListElement {
            name: "Window maximize button"
            value: "windowMaximizeButton"
        }

        ListElement {
            name: "Keep window above button"
            value: "windowKeepAboveButton"
        }

        ListElement {
            name: "Keep window below button"
            value: "windowKeepBelowButton"
        }

        ListElement {
            name: "Shade window button"
            value: "windowShadeButton"
        }

        ListElement {
            name: "Window title"
            value: "windowTitle"
        }

        ListElement {
            name: "Window Icon"
            value: "windowIcon"
        }

        ListElement {
            name: "Spacer"
            value: "spacer"
        }
    }
}
