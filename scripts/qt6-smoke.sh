#!/usr/bin/env bash
set -euo pipefail

src_dir="${1:-/home/captain/Projects/DSView-1.3.2}"
build_dir="${2:-/tmp/dsview-qt6-only-build}"
binary_path="${src_dir}/build.dir/DSView"

echo "[1/5] Configure Qt6 build in ${build_dir}"
cmake -S "${src_dir}" -B "${build_dir}" \
  -DCMAKE_DISABLE_FIND_PACKAGE_Qt5Core=TRUE \
  -DCMAKE_DISABLE_FIND_PACKAGE_Qt5Gui=TRUE \
  -DCMAKE_DISABLE_FIND_PACKAGE_Qt5Widgets=TRUE \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo

echo "[2/5] Build DSView with Qt6"
cmake --build "${build_dir}" -j"$(nproc)"

echo "[3/5] Verify binary links against Qt6"
ldd "${binary_path}" | grep -q 'libQt6Widgets'
ldd "${binary_path}" | grep -E 'Qt[56]'

echo "[4/5] Version smoke"
"${binary_path}" -v

echo "[5/5] Platform smokes"
env QT_QPA_PLATFORM=wayland timeout 8s "${binary_path}" -l 4 >/tmp/dsview-qt6-wayland.log 2>&1 || rc=$?
if [[ "${rc:-0}" -ne 0 && "${rc:-0}" -ne 124 ]]; then
  cat /tmp/dsview-qt6-wayland.log
  exit "${rc}"
fi

unset rc
env QT_QPA_PLATFORM=wayland QT_WAYLAND_DECORATION=adwaita QT_DEBUG_PLUGINS=1 timeout 6s \
  "${binary_path}" -l 4 >/tmp/dsview-qt6-wayland-adwaita.log 2>&1 || rc=$?
if [[ "${rc:-0}" -ne 0 && "${rc:-0}" -ne 124 ]]; then
  cat /tmp/dsview-qt6-wayland-adwaita.log
  exit "${rc}"
fi
grep -q 'libadwaita\.so' /tmp/dsview-qt6-wayland-adwaita.log

unset rc
env QT_QPA_PLATFORM=xcb timeout 8s "${binary_path}" -l 4 >/tmp/dsview-qt6-xcb.log 2>&1 || rc=$?
if [[ "${rc:-0}" -ne 0 && "${rc:-0}" -ne 124 ]]; then
  cat /tmp/dsview-qt6-xcb.log
  exit "${rc}"
fi

echo "Qt6 smoke passed."
echo "Logs:"
echo "  /tmp/dsview-qt6-wayland.log"
echo "  /tmp/dsview-qt6-wayland-adwaita.log"
echo "  /tmp/dsview-qt6-xcb.log"
