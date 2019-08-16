[CmdletBinding()]
param (
    $libraries = @(),
    $version = "1.70.0"
)

$scriptsDir = split-path -parent $MyInvocation.MyCommand.Definition

function TransformReference()
{
    param (
        [string]$library
    )

    if ($library -match "python|fiber")
    {
        # These two only work on windows desktop
        "$library (windows)"
    }
    elseif ($library -match "thread|type[_-]erasure|contract")
    {
        # thread only works on x86-based processors
        "$library (!arm)"
    }
    elseif ($library -match "iostreams|filesystem|context|stacktrace|coroutine`$|locale|test|wave|log`$")
    {
        "$library (!uwp)"
    }
    else
    {
        "$library"
    }
}

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
    if ($Name -eq "python" -or $Name -eq "asio" -or $Name -eq "mpi")
    {
        $versionsuffix = "-1"
    }

    if ($Name -eq "test")
    {
        $versionsuffix = "-2"
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
    )
    if ($Name -eq "thread")
    {
        $portfileLines += @("    PATCHES avoid-winapi.patch")
    }
    $portfileLines += @(
        ")"
        ""
    )

    if (Test-Path "$scriptsDir/post-source-stubs/$Name.cmake")
    {
        $portfileLines += @(get-content "$scriptsDir/post-source-stubs/$Name.cmake")
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
                "    BOOST_CMAKE_FRAGMENT `"`${CMAKE_CURRENT_LIST_DIR}/cmake-fragment.cmake`""
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
                "boost_modular_build("
                "    SOURCE_PATH `${SOURCE_PATH}"
                "    REQUIREMENTS `"<library>/boost/date_time//boost_date_time`""
                "    OPTIONS /boost/thread//boost_thread"
                "    BOOST_CMAKE_FRAGMENT `${CMAKE_CURRENT_LIST_DIR}/b2-options.cmake"
                ")"
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

    if (Test-Path "$scriptsDir/post-build-stubs/$Name.cmake")
    {
        $portfileLines += @(get-content "$scriptsDir/post-build-stubs/$Name.cmake")
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
else
{
    pushd $scriptsDir/boost
    try
    {
        git fetch
        git checkout -f boost-$version
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
        "safe_numerics"
    }
    elseif ($_ -eq "headers")
    {
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
        & @(vcpkg fetch aria2)[-1] "https://github.com/boostorg/$library/archive/boost-$version.tar.gz" -d "$scriptsDir/downloads" -o "$library-boost-$version.tar.gz"
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
            findstr /si /C:"include <boost/" include/*
            findstr /si /C:"include <boost/" src/*
        ) |
        % { $_ `
                -replace "^[^:]*:","" `
                -replace "boost/numeric/conversion/","boost/numeric_conversion/" `
                -replace "boost/functional/hash.hpp","boost/container_hash/hash.hpp" `
                -replace "boost/detail/([^/]+)/","boost/`$1/" `
                -replace " *# *include *<boost/([a-zA-Z0-9\._]*)(/|>).*", "`$1" `
                -replace "/|\.hp?p?| ","" } | group | % name | % {
            # mappings
            Write-Verbose "${library}: $_"
            if ($_ -match "aligned_storage") { "type_traits" }
            elseif ($_ -match "noncopyable|ref|swap|get_pointer|checked_delete|visit_each") { "core" }
            elseif ($_ -eq "type") { "core" }
            elseif ($_ -match "unordered_") { "unordered" }
            elseif ($_ -match "cstdint") { "integer" }
            elseif ($_ -match "call_traits|operators|current_function|cstdlib|next_prior|compressed_pair") { "utility" }
            elseif ($_ -match "^version|^workaround") { "config" }
            elseif ($_ -match "enable_shared_from_this|shared_ptr|make_shared|make_unique|intrusive_ptr|scoped_ptr|pointer_to_other|weak_ptr|shared_array|scoped_array") { "smart_ptr" }
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
            elseif ($_ -match "token_iterator|token_functions") { "tokenizer" }
            elseif ($_ -eq "numeric" -and $library -notmatch "numeric_conversion|interval|odeint|ublas") { "numeric_conversion"; "interval"; "odeint"; "ublas" }
            else { $_ }
        } | group | % name | ? { $_ -ne $library }

        #"`nFor ${library}:"
        "      [known] " + $($groups | ? { $libraries_found -contains $_ })
        "    [unknown] " + $($groups | ? { $libraries_found -notcontains $_ })

        $deps = @($groups | ? { $libraries_found -contains $_ })

        $deps = @($deps | ? {
            # Boost contains cycles, so remove a few dependencies to break the loop.
            (($library -notmatch "core|assert|mpl|detail|throw_exception|type_traits|^exception") -or ($_ -notmatch "utility")) `
            -and `
            (($library -notmatch "range") -or ($_ -notmatch "algorithm"))`
            -and `
            (($library -ne "config") -or ($_ -notmatch "integer"))`
            -and `
            (($library -notmatch "multiprecision") -or ($_ -notmatch "random|math"))`
            -and `
            (($library -notmatch "lexical_cast") -or ($_ -notmatch "math"))`
            -and `
            (($library -notmatch "functional") -or ($_ -notmatch "function"))`
            -and `
            (($library -notmatch "detail") -or ($_ -notmatch "static_assert|integer|mpl|type_traits"))`
            -and `
            ($_ -notmatch "mpi")`
            -and `
            (($library -notmatch "spirit") -or ($_ -notmatch "serialization"))`
            -and `
            (($library -notmatch "throw_exception") -or ($_ -notmatch "^exception"))`
            -and `
            (($library -notmatch "iostreams") -or ($_ -notmatch "random"))`
            -and `
            (($library -notmatch "utility|concept_check") -or ($_ -notmatch "iterator"))
        } | % { "boost-$_" -replace "_","-" } | % {
            TransformReference $_
        })

        $deps += @("boost-vcpkg-helpers")

        $needsBuild = $false
        if ((Test-Path $unpacked/build/Jamfile.v2) -and $library -ne "metaparse" -and $library -ne "graph_parallel")
        {
            $deps += @("boost-build", "boost-modular-build-helper")
            $needsBuild = $true
        }

        if ($library -eq "python")
        {
            $deps += @("python3")
            $needsBuild = $true
        }
        elseif ($library -eq "iostreams")
        {
            $deps += @("zlib", "bzip2", "liblzma")
        }
        elseif ($library -eq "locale")
        {
            $deps += @("libiconv (!uwp&!windows)")
        }
        elseif ($library -eq "asio")
        {
            $deps += @("openssl")
        }
        elseif ($library -eq "mpi")
        {
            $deps += @("mpi")
        }

        Generate `
            -Name $library `
            -Hash $hash `
            -Depends $deps `
            -NeedsBuild $needsBuild

        $libraries_in_boost_port += @(TransformReference $library)
    }
    finally
    {
        popd
    }
}

if ($libraries_in_boost_port.length -gt 1) {
    # Generate master boost control file which depends on each individual library
    # mpi is excluded due to it having a dependency on msmpi
    $boostDependsList = @($libraries_in_boost_port | % { "boost-$_" -replace "_","-" } | ? { $_ -notmatch "boost-mpi" }) -join ", "

    @(
        "# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1"
        "Source: boost"
        "Version: $version"
        "Description: Peer-reviewed portable C++ source libraries"
        "Build-Depends: $boostDependsList"
        ""
        "Feature: mpi"
        "Description: Build with MPI support"
        "Build-Depends: boost-mpi"
    ) | out-file -enc ascii $scriptsDir/../boost/CONTROL

    "set(VCPKG_POLICY_EMPTY_PACKAGE enabled)`n" | out-file -enc ascii $scriptsDir/../boost/portfile.cmake
}

return
