#!/usr/bin/env bash
set -euxo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
script_path="${script_dir}/toggle.js"

qdbus org.kde.KWin /Scripting org.kde.kwin.Scripting.unloadScript "${script_path}"
qdbus org.kde.KWin /Scripting org.kde.kwin.Scripting.loadScript "${script_path}"
qdbus org.kde.KWin /Scripting org.kde.kwin.Scripting.start
qdbus org.kde.KWin /KWin reconfigure
