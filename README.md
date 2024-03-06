# Project Title

Application Title Bar

## Description

KDE plasmoid compatible with Qt6 with window title and buttons, only top-left aligned for now.
I like minimalistic display layout and used Active Window Control plasmoid, but it's abandoned for several years and now incompatible with Plasma6.
So, I decided to create my own widget with the minimal set of features.

### Features

1. Close, minimize, maximize buttons
2. Title with app name or decorations
3. Move window on drag

## Getting Started

### Installing

1. Copy plasmoid to local catalog and restart Plasma Shell in case of updated version.

```
mkdir -p ~/.local/share/plasma/plasmoids/com.github.antroids.application-title-bar/ & yes | cp -rf package/* ~/.local/share/plasma/plasmoids/com.github.antroids.application-title-bar/ | plasmashell --replace &
```

2. Add the widget


## License

This project is licensed under the GPL-3.0-or-later License - see the LICENSE.md file for details