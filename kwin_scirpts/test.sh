# qdbus org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.cleanUp

qdbus org.kde.KWin /Scripting org.kde.kwin.Scripting.loadScript /home/exec/Projects/github.com/eval-exec/nixos-configuration/kwin_scirpts/toggle.js
qdbus org.kde.KWin /Scripting org.kde.kwin.Scripting.start
qdbus org.kde.KWin /KWin reconfigure
