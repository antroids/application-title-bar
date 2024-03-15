# Application Title Bar

[![GPLv3 License](https://img.shields.io/badge/License-GPL%20v3-yellow.svg)](https://opensource.org/licenses/)
![GitHub Release](https://img.shields.io/github/v/release/antroids/application-title-bar)


## Description

KDE plasmoid compatible with Qt6 with window title and buttons.
I like minimalistic display layout and used Active Window Control plasmoid, but it's abandoned for several years and now incompatible with Plasma6.
So, I decided to create my own widget with the minimal set of features.

### Features

* Close, minimize, maximize, keep below/above buttons.
* Title with app name.
* Configure actions on mouse events.
* Configurable elements set and order.
* Different theming options. Internal Breeze icons, System icons and Aurorae theme.
* Configurable layout and geometry.

## Getting Started

### Installing

#### Install via "Add Widgets..." -> "Get New Widgets..." -> "Download..."

or

#### Install from [KDE Store](https://store.kde.org/p/2135509)

or

#### Download Latest \*.plasmoid from [Releases page](https://github.com/antroids/application-title-bar/releases) and install it via "Add Widgets..." -> "Get New Widgets..." -> "Install Widget From Local file"

or

1. Copy plasmoid to local catalog and restart Plasma Shell in case of updated version.

```
mkdir -p ~/.local/share/plasma/plasmoids/com.github.antroids.application-title-bar/ & yes | cp -rf package/* ~/.local/share/plasma/plasmoids/com.github.antroids.application-title-bar/ | plasmashell --replace &
```

2. Add the widget


## License

This project is licensed under the GPL-3.0-or-later License - see the LICENSE.md file for details

## Contributing

Pull requests and Issue reports are always welcome.