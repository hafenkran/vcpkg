# This script is based on the implementation of windeployqt for qt5.7.1
#
# Qt's plugin deployment strategy is that each main Qt Module has a hardcoded
# set of plugin subdirectories. Each of these subdirectories is deployed in
# full if that Module is referenced.
#
# This hardcoded list is found inside qttools\src\windeployqt\main.cpp. For
# updating, inspect the symbols qtModuleEntries and qtModuleForPlugin.

# Note: this function signature and behavior is depended upon by applocal.ps1
function deployPluginsIfQt([string]$targetBinaryDir, [string]$QtPluginsDir, [string]$targetBinaryName) {

    $baseDir = Split-Path $QtPluginsDir -parent
    $binDir = "$baseDir\bin"

    function deployPlugins([string]$pluginSubdirName) {
        if (Test-Path "$QtPluginsDir\$pluginSubdirName") {
            Write-Verbose "  Deploying plugins directory '$pluginSubdirName'"
            New-Item "$targetBinaryDir\$pluginSubdirName" -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
            Get-ChildItem "$QtPluginsDir\$pluginSubdirName\*.dll" | % {
                deployBinary "$targetBinaryDir\$pluginSubdirName" "$QtPluginsDir\$pluginSubdirName" $_.Name
                resolve $_
            }
        } else {
            Write-Verbose "  Skipping plugins directory '$pluginSubdirName': doesn't exist"
        }
    }

    # We detect Qt modules in use via the DLLs themselves. See qtModuleEntries in Qt to find the mapping.
    if ($targetBinaryName -like "Qt5Gui*.dll") {
        Write-Verbose "  Deploying platforms"
        New-Item "$targetBinaryDir\platforms" -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
        Get-ChildItem "$QtPluginsDir\platforms\qwindows*.dll" | % {
            deployBinary "$targetBinaryDir\platforms" "$QtPluginsDir\platforms" $_.Name
        }

        deployPlugins "accessible"
        deployPlugins "imageformats"
        deployPlugins "iconengines"
        deployPlugins "platforminputcontexts"
    } elseif ($targetBinaryName -like "Qt5Network*.dll") {
        deployPlugins "bearer"
        if (Test-Path "$binDir\libeay32.dll")
        {
            deployBinary "$targetBinaryDir" "$binDir" "libeay32.dll"
            deployBinary "$targetBinaryDir" "$binDir" "ssleay32.dll"
        }
    } elseif ($targetBinaryName -like "Qt5Sql*.dll") {
        deployPlugins "sqldrivers"
    } elseif ($targetBinaryName -like "Qt5Multimedia*.dll") {
        deployPlugins "audio"
        deployPlugins "mediaservice"
        deployPlugins "playlistformats"
    } elseif ($targetBinaryName -like "Qt5PrintSupport*.dll") {
        deployPlugins "printsupport"
    } elseif ($targetBinaryName -like "Qt5Quick*.dll") {
        deployPlugins "scenegraph"
        deployPlugins "qmltooling"
    } elseif ($targetBinaryName -like "Qt5Declarative*.dll") {
        deployPlugins "qml1tooling"
    } elseif ($targetBinaryName -like "Qt5Positioning*.dll") {
        deployPlugins "position"
    } elseif ($targetBinaryName -like "Qt5Location*.dll") {
        deployPlugins "geoservices"
    } elseif ($targetBinaryName -like "Qt5Sensors*.dll") {
        deployPlugins "sensors"
        deployPlugins "sensorgestures"
    } elseif ($targetBinaryName -like "Qt5WebEngineCore*.dll") {
        deployPlugins "qtwebengine"
    } elseif ($targetBinaryName -like "Qt53DRenderer*.dll") {
        deployPlugins "sceneparsers"
    } elseif ($targetBinaryName -like "Qt5TextToSpeech*.dll") {
        deployPlugins "texttospeech"
    } elseif ($targetBinaryName -like "Qt5SerialBus*.dll") {
        deployPlugins "canbus"
    }
}
