# Application Title Bar

[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/)
![GitHub Release](https://img.shields.io/github/v/release/antroids/application-title-bar)


## Description

KDE plasmoid compatible with Qt6 with window title and buttons.
I like minimalistic display layout and used Active Window Control plasmoid, but it's abandoned for several years and now incompatible with Plasma6.
So, I decided to create my own widget with the minimal set of features.

### Goal

Stable and fast widget with control buttons and window title, ideally with the same functionality as Unity panel.
I would like to keep the widget pure QML to avoid incompatibility and maintenance issues.

Disadvantages of pure QML widget:
* Only icons can be used from Aurorae themes, the rest is ignored. Binary themes are unsupported at all (Issues [#18](https://github.com/antroids/application-title-bar/issues/18), [#6](https://github.com/antroids/application-title-bar/issues/6)).
* I cannot see the way to build menu with current plasmoid API (Issue [#13](https://github.com/antroids/application-title-bar/issues/13))

### Features

* Close, minimize, maximize, keep below/above buttons.
* Title with app name.
* Configure actions on mouse events.
* Configurable elements set and order.
* Different theming options. Internal Breeze icons, System icons and Aurorae theme.
* Configurable layout and geometry.

## Getting Started

1. Installing
    - Install via "Add Widgets..." -> "Get New Widgets..." -> "Download..."
    - Install from [KDE Store](https://store.kde.org/p/2135509)
    - Download Latest \*.plasmoid from [Releases page](https://github.com/antroids/application-title-bar/releases) and install it via "Add Widgets..." -> "Get New Widgets..." -> "Install Widget From Local file"
    - Manually:
      1. Copy plasmoid to local catalog and restart Plasma Shell in case of updated version.
          ```
          kpackagetool6 -t Plasma/Applet -i Path/to/Plasmoid/application-title-bar.plasmoid
          ```
      2. For updating run
          ```
          kpackagetool6 -t Plasma/Applet -u Path/to/Plasmoid/application-title-bar.plasmoid
          ```
2. Login & Logout or run `plasmashell --replace &`

## License

This project is licensed under the GPL-3.0-or-later License - see the LICENSE.md file for details

## Contributing

Pull requests and Issue reports are always welcome.
