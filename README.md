# DSView 
DSView is a GUI program for supporting various instruments from [DreamSourceLab](http://www.dreamsourcelab.com), including logic analyzers, oscilloscopes, etc. DSView is based on the [sigrok project](https://sigrok.org).

The sigrok project aims at creating a portable, cross-platform, Free/Libre/Open-Source signal analysis software suite that supports various device types (such as logic analyzers, oscilloscopes, multimeters, and more).

# Status

The DSView software is in a usable state and has official tarball releases. However, it is still a work in progress. Some basic functionality is available and working, but other things are always on the TODO list.

This tree is maintained as a `Qt6`-first build and has been updated to run on modern Linux desktops with native `Wayland` support. `Qt5` remains available as a fallback where needed, but the preferred path is now `Qt6`.

## Qt6 and Wayland

- `Qt6` is the default toolkit in the current build system.
- Native `Wayland` startup is supported and tested on recent Ubuntu GNOME sessions, including Ubuntu `25.10`.
- `xcb` / `XWayland` remains available as a compatibility fallback.
- The Linux UI path was adjusted for window decoration, dialog parenting, popup handling, screenshots, and decoder selection under Wayland.

Typical Linux test commands:

```bash
cmake -S . -B build
cmake --build build -j4

# Native Wayland
QT_QPA_PLATFORM=wayland ./build.dir/DSView

# X11 / XWayland fallback
QT_QPA_PLATFORM=xcb ./build.dir/DSView

# Qt6 smoke test
bash scripts/qt6-smoke.sh
```

# Useful links

- [dreamsourcelab.com](https://www.dreamsourcelab.com)
- [kickstarter.com](https://www.kickstarter.com/projects/dreamsourcelab/dslogic-multifunction-instruments-for-everyone)
- [sigrok.org](https://sigrok.org)

# Copyright and license

DSView software is licensed under the terms of the GNU General Public License
(GPL), version 3 or later.

While some individual source code files are licensed under the GPLv2+, and
some files are licensed under the GPLv3+, this doesn't change the fact that
the program as a whole is licensed under the terms of the GPLv3+ (e.g. also
due to the fact that it links against GPLv3+ libraries).

Please see the individual source files for the full list of copyright holders.
