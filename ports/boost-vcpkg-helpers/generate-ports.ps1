[CmdletBinding()]
param (
    $libraries = @(),
    $version = "1.66.0"
)

$scriptsDir = split-path -parent $MyInvocation.MyCommand.Definition

$libsDisabledInUWP = "iostreams|filesystem|thread|context|python|stacktrace|program-options|program_options|coroutine`$|fiber|locale|test|type-erasure|type_erasure|wave|log"

function Generate()
{
    param (
        [string]$Name,
        [string]$Hash,
        [bool]$NeedsBuild,
        $Depends = @()
    )

    $controlDeps = ($Depends | sort) -join ", "

    $sanitizedName = $name -replace "_","-"

    $versionsuffix = ""
    if ($Name -eq "test" -or $Name -eq "python")
    {
        $versionsuffix = "-1"
    }

    mkdir "$scriptsDir/../boost-$sanitizedName" -erroraction SilentlyContinue | out-null
    $controlLines = @(
        "# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1"
        "Source: boost-$sanitizedName"
        "Version: $version$versionsuffix"
        "Build-Depends: $controlDeps"
        "Description: Boost $Name module"
    )
    if ($Name -eq "locale")
    {
        $controlLines += @(
            ""
            "Feature: icu"
            "Description: ICU backend for Boost.Locale"
            "Build-Depends: icu"
        )
    }
    if ($Name -eq "regex")
    {
        $controlLines += @(
            ""
            "Feature: icu"
            "Description: ICU backend for Boost.Regex"
            "Build-Depends: icu"
        )
    }
    $controlLines | out-file -enc ascii "$scriptsDir/../boost-$sanitizedName/CONTROL"

    $portfileLines = @(
        "# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1"
        ""
        "include(vcpkg_common_functions)"
        ""
        "vcpkg_from_github("
        "    OUT_SOURCE_PATH SOURCE_PATH"
        "    REPO boostorg/$Name"
        "    REF boost-$version"
        "    SHA512 $Hash"
        "    HEAD_REF master"
        ")"
        ""
    )

    if ($Name -eq "python")
    {
        $portfileLines += @(
            "# Find Python. Can't use find_package here, but we already know where everything is"
            "file(GLOB PYTHON_INCLUDE_PATH `"`${CURRENT_INSTALLED_DIR}/include/python[0-9.]*`")"
            "set(PYTHONLIBS_RELEASE `"`${CURRENT_INSTALLED_DIR}/lib`")"
            "set(PYTHONLIBS_DEBUG `"`${CURRENT_INSTALLED_DIR}/debug/lib`")"
            "string(REGEX REPLACE `".*python([0-9\.]+)`$`" `"\\1`" PYTHON_VERSION `"`${PYTHON_INCLUDE_PATH}`")"
        )
    }

    if ($NeedsBuild)
    {
        if ($Name -eq "locale")
        {
            $portfileLines += @(
                "if(`"icu`" IN_LIST FEATURES)"
                "    set(BOOST_LOCALE_ICU on)"
                "else()"
                "    set(BOOST_LOCALE_ICU off)"
                "endif()"
                ""
                "include(`${CURRENT_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)"
                "boost_modular_build("
                "    SOURCE_PATH `${SOURCE_PATH}"
                "    OPTIONS"
                "        boost.locale.iconv=off"
                "        boost.locale.posix=off"
                "        /boost/locale//boost_locale"
                "        boost.locale.icu=`${BOOST_LOCALE_ICU}"
                ")"
            )
        }
        elseif ($Name -eq "regex")
        {
            $portfileLines += @(
                "if(`"icu`" IN_LIST FEATURES)"
                "    set(REQUIREMENTS `"<library>/user-config//icuuc <library>/user-config//icudt <library>/user-config//icuin <define>BOOST_HAS_ICU=1`")"
                "else()"
                "    set(REQUIREMENTS)"
                "endif()"
                ""
                "include(`${CURRENT_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)"
                "boost_modular_build(SOURCE_PATH `${SOURCE_PATH} REQUIREMENTS `"`${REQUIREMENTS}`")"
            )
        }
        elseif ($Name -eq "thread")
        {
            $portfileLines += @(
                "include(`${CURRENT_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)"
                "boost_modular_build(SOURCE_PATH `${SOURCE_PATH} REQUIREMENTS `"<library>/boost/date_time//boost_date_time`")"
            )
        }
        else
        {
            $portfileLines += @(
                "include(`${CURRENT_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)"
                "boost_modular_build(SOURCE_PATH `${SOURCE_PATH})"
                )
        }
    }
    $portfileLines += @(
        "include(`${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)"
        "boost_modular_headers(SOURCE_PATH `${SOURCE_PATH})"
    )

    if ($Name -eq "exception")
    {
        $portfileLines += @(
            ""
            "set(VCPKG_LIBRARY_LINKAGE static)"
            "file(REMOVE_RECURSE `${CURRENT_PACKAGES_DIR}/bin `${CURRENT_PACKAGES_DIR}/debug/bin)"
         )
    }
    if ($Name -eq "config")
    {
        $portfileLines += @(
            "file(APPEND `${CURRENT_PACKAGES_DIR}/include/boost/config/user.hpp `"\n#ifndef BOOST_ALL_NO_LIB\n#define BOOST_ALL_NO_LIB\n#endif\n`")"
            "file(APPEND `${CURRENT_PACKAGES_DIR}/include/boost/config/user.hpp `"\n#undef BOOST_ALL_DYN_LINK\n`")"
            ""
            "if (VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)"
            "    file(APPEND `${CURRENT_PACKAGES_DIR}/include/boost/config/user.hpp `"\n#define BOOST_ALL_DYN_LINK\n`")"
            "endif()"
        )
    }
    if ($Name -eq "test")
    {
        $portfileLines += @(
            "file(MAKE_DIRECTORY `${CURRENT_PACKAGES_DIR}/lib/manual-link)"
            "file(MAKE_DIRECTORY `${CURRENT_PACKAGES_DIR}/debug/lib/manual-link)"
            ""
            "file(GLOB MONITOR_LIBS `${CURRENT_PACKAGES_DIR}/lib/*_exec_monitor*)"
            "file(COPY `${MONITOR_LIBS} DESTINATION `${CURRENT_PACKAGES_DIR}/lib/manual-link)"
            "file(GLOB DEBUG_MONITOR_LIBS `${CURRENT_PACKAGES_DIR}/debug/lib/*_exec_monitor*)"
            "file(COPY `${DEBUG_MONITOR_LIBS} DESTINATION `${CURRENT_PACKAGES_DIR}/debug/lib/manual-link)"
            ""
            "file(REMOVE `${DEBUG_MONITOR_LIBS} `${MONITOR_LIBS})"
        )
    }

    $portfileLines | out-file -enc ascii "$scriptsDir/../boost-$sanitizedName/portfile.cmake"
}

if (!(Test-Path "$scriptsDir/boost"))
{
    "Cloning boost..."
    pushd $scriptsDir
    try
    {
        git clone https://github.com/boostorg/boost --branch boost-$version
    }
    finally
    {
        popd
    }
}

$libraries_found = ls $scriptsDir/boost/libs -directory | % name | % {
    if ($_ -match "numeric")
    {
        "numeric_conversion"
        "interval"
        "odeint"
        "ublas"
    }
    else
    {
        $_
    }
}

mkdir $scriptsDir/downloads -erroraction SilentlyContinue | out-null

if ($libraries.Length -eq 0)
{
    $libraries = $libraries_found
}

$libraries_in_boost_port = @()

foreach ($library in $libraries)
{
    "Handling boost/$library..."
    $archive = "$scriptsDir/downloads/$library-boost-$version.tar.gz"
    if (!(Test-Path $archive))
    {
        "Downloading boost/$library..."
        Invoke-WebRequest "https://github.com/boostorg/$library/archive/boost-$version.tar.gz" -OutFile $archive
    }
    $hash = vcpkg hash $archive
    $unpacked = "$scriptsDir/libs/$library-boost-$version"
    if (!(Test-Path $unpacked))
    {
        "Unpacking boost/$library..."
        mkdir $scriptsDir/libs -erroraction SilentlyContinue | out-null
        pushd $scriptsDir/libs
        try
        {
            cmake -E tar xf $archive
        }
        finally
        {
            popd
        }
    }
    pushd $unpacked
    try
    {
        $groups = $(
            findstr /si /C:"#include <boost/" include/*
            findstr /si /C:"#include <boost/" src/*
        ) |
        % { $_ -replace "^[^:]*:","" -replace "boost/numeric/conversion/","boost/numeric_conversion/" -replace "boost/detail/([^/]+)/","boost/`$1/" -replace "#include ?<boost/([a-zA-Z0-9\._]*)(/|>).*", "`$1" -replace "/|\.hp?p?| ","" } | group | % name | % {
            # mappings
            Write-Verbose "${library}: $_"
            if ($_ -match "aligned_storage") { "type_traits" }
            elseif ($_ -match "noncopyable|ref|swap|get_pointer|checked_delete|visit_each") { "core" }
            elseif ($_ -eq "type") { "core" }
            elseif ($_ -match "unordered_") { "unordered" }
            elseif ($_ -match "cstdint") { "integer" }
            elseif ($_ -match "call_traits|operators|current_function|cstdlib|next_prior") { "utility" }
            elseif ($_ -eq "version") { "config" }
            elseif ($_ -match "shared_ptr|make_shared|intrusive_ptr|scoped_ptr|pointer_to_other|weak_ptr|shared_array|scoped_array") { "smart_ptr" }
            elseif ($_ -match "iterator_adaptors|generator_iterator|pointee") { "iterator" }
            elseif ($_ -eq "regex_fwd") { "regex" }
            elseif ($_ -eq "make_default") { "convert" }
            elseif ($_ -eq "foreach_fwd") { "foreach" }
            elseif ($_ -eq "cerrno") { "system" }
            elseif ($_ -eq "archive") { "serialization" }
            elseif ($_ -eq "none") { "optional" }
            elseif ($_ -eq "integer_traits") { "integer" }
            elseif ($_ -eq "limits") { "compatibility" }
            elseif ($_ -eq "math_fwd") { "math" }
            elseif ($_ -match "polymorphic_cast|implicit_cast") { "conversion" }
            elseif ($_ -eq "nondet_random") { "random" }
            elseif ($_ -eq "memory_order") { "atomic" }
            elseif ($_ -eq "blank") { "detail" }
            elseif ($_ -match "is_placeholder|mem_fn") { "bind" }
            elseif ($_ -eq "exception_ptr") { "exception" }
            elseif ($_ -eq "multi_index_container") { "multi_index" }
            elseif ($_ -eq "lexical_cast") { "lexical_cast"; "math" }
            elseif ($_ -eq "numeric" -and $library -notmatch "numeric_conversion|interval|odeint|ublas") { "numeric_conversion"; "interval"; "odeint"; "ublas" }
            else { $_ }
        } | group | % name | ? { $_ -ne $library }

        #"`nFor ${library}:"
        "      [known] " + $($groups | ? { $libraries_found -contains $_ })
        "    [unknown] " + $($groups | ? { $libraries_found -notcontains $_ })

        $deps = @($groups | ? { $libraries_found -contains $_ })

        $deps = @($deps | ? {
            # Boost contains cycles, so remove a few dependencies to break the loop.
            (($library -notmatch "core|assert|mpl|detail|type_traits") -or ($_ -notmatch "utility")) `
            -and `
            (($library -notmatch "lexical_cast") -or ($_ -notmatch "math"))`
            -and `
            (($library -notmatch "functional") -or ($_ -notmatch "function"))`
            -and `
            (($library -notmatch "detail") -or ($_ -notmatch "static_assert|integer|mpl|type_traits"))`
            -and `
            (($library -notmatch "property_map") -or ($_ -notmatch "mpi"))`
            -and `
            (($library -notmatch "spirit") -or ($_ -notmatch "serialization"))`
            -and `
            (($library -notmatch "utility|concept_check") -or ($_ -notmatch "iterator"))
        } | % { "boost-$_" -replace "_","-" } | % {
            if ($_ -match $libsDisabledInUWP)
            {
                "$_ (windows)"
            }
            else
            {
                $_
            }
        })

        $deps += @("boost-vcpkg-helpers")

        $needsBuild = $false
        if ((Test-Path $unpacked/build/Jamfile.v2) -and $library -ne "metaparse")
        {
            $deps += @("boost-build")
            $needsBuild = $true
        }

        if ($library -eq "python")
        {
            $deps += @("python3")
            $needsBuild = $true
        }
        elseif ($library -eq "iostreams")
        {
            $deps += @("zlib", "bzip2")
        }

        Generate `
            -Name $library `
            -Hash $hash `
            -Depends $deps `
            -NeedsBuild $needsBuild

        if ($library -match $libsDisabledInUWP)
        {
            $libraries_in_boost_port += @("$library (windows)")
        }
        else
        {
            $libraries_in_boost_port += @($library)
        }

    }
    finally
    {
        popd
    }
}

# Generate master boost control file which depends on each individual library
$boostDependsList = @($libraries_in_boost_port | % { "boost-$_" -replace "_","-" }) -join ", "

@(
    "Source: boost"
    "Version: $version"
    "Build-Depends: $boostDependsList"
) | out-file -enc ascii $scriptsDir/../boost/CONTROL

"set(VCPKG_POLICY_EMPTY_PACKAGE enabled)`n" | out-file -enc ascii $scriptsDir/../boost/portfile.cmake

return
