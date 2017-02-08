find_program(vcpkg_configure_cmake_NINJA ninja)
function(vcpkg_configure_cmake)
    cmake_parse_arguments(_csc "" "SOURCE_PATH;GENERATOR" "OPTIONS;OPTIONS_DEBUG;OPTIONS_RELEASE" ${ARGN})

    if(NOT VCPKG_PLATFORM_TOOLSET)
        message(FATAL_ERROR "Vcpkg has been updated with VS2017 support, however you need to rebuild vcpkg.exe by re-running bootstrap.ps1\n    powershell -exec bypass scripts\\bootstrap.ps1\n")
    endif()

    if(_csc_GENERATOR)
        set(GENERATOR ${_csc_GENERATOR})
    elseif(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore" AND TRIPLET_SYSTEM_ARCH MATCHES "x86" AND VCPKG_PLATFORM_TOOLSET MATCHES "v140")
        set(GENERATOR "Visual Studio 14 2015")
    elseif(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore" AND TRIPLET_SYSTEM_ARCH MATCHES "x64" AND VCPKG_PLATFORM_TOOLSET MATCHES "v140")
        set(GENERATOR "Visual Studio 14 2015 Win64")
    elseif(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore" AND TRIPLET_SYSTEM_ARCH MATCHES "arm" AND VCPKG_PLATFORM_TOOLSET MATCHES "v140")
        set(GENERATOR "Visual Studio 14 2015 ARM")
    # elseif(NOT vcpkg_configure_cmake_NINJA MATCHES "NOTFOUND")
    #     set(GENERATOR "Ninja")
    elseif(TRIPLET_SYSTEM_ARCH MATCHES "x86" AND VCPKG_PLATFORM_TOOLSET MATCHES "v140")
        set(GENERATOR "Visual Studio 14 2015")
    elseif(TRIPLET_SYSTEM_ARCH MATCHES "x64" AND VCPKG_PLATFORM_TOOLSET MATCHES "v140")
        set(GENERATOR "Visual Studio 14 2015 Win64")
    elseif(TRIPLET_SYSTEM_ARCH MATCHES "arm")
        set(GENERATOR "Visual Studio 14 2015 ARM" AND VCPKG_PLATFORM_TOOLSET MATCHES "v140")

    elseif(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore" AND TRIPLET_SYSTEM_ARCH MATCHES "x86" AND VCPKG_PLATFORM_TOOLSET MATCHES "v141")
        set(GENERATOR "Visual Studio 15 2017")
    elseif(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore" AND TRIPLET_SYSTEM_ARCH MATCHES "x64" AND VCPKG_PLATFORM_TOOLSET MATCHES "v141")
        set(GENERATOR "Visual Studio 15 2017 Win64")
    elseif(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore" AND TRIPLET_SYSTEM_ARCH MATCHES "arm" AND VCPKG_PLATFORM_TOOLSET MATCHES "v141")
        set(GENERATOR "Visual Studio 15 2017 ARM")
    elseif(TRIPLET_SYSTEM_ARCH MATCHES "x86" AND VCPKG_PLATFORM_TOOLSET MATCHES "v141")
        set(GENERATOR "Visual Studio 15 2017")
    elseif(TRIPLET_SYSTEM_ARCH MATCHES "x64" AND VCPKG_PLATFORM_TOOLSET MATCHES "v141")
        set(GENERATOR "Visual Studio 15 2017 Win64")
    elseif(TRIPLET_SYSTEM_ARCH MATCHES "arm")
        set(GENERATOR "Visual Studio 15 2017 ARM" AND VCPKG_PLATFORM_TOOLSET MATCHES "v141")
    endif()

    file(REMOVE_RECURSE ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg)

    if(DEFINED VCPKG_CMAKE_SYSTEM_NAME)
        list(APPEND _csc_OPTIONS -DCMAKE_SYSTEM_NAME=${VCPKG_CMAKE_SYSTEM_NAME})
    endif()
    if(DEFINED VCPKG_CMAKE_SYSTEM_VERSION)
        list(APPEND _csc_OPTIONS -DCMAKE_SYSTEM_VERSION=${VCPKG_CMAKE_SYSTEM_VERSION})
    endif()
    if(DEFINED VCPKG_LIBRARY_LINKAGE AND VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
        list(APPEND _csc_OPTIONS -DBUILD_SHARED_LIBS=ON)
    elseif(DEFINED VCPKG_LIBRARY_LINKAGE AND VCPKG_LIBRARY_LINKAGE STREQUAL static)
        list(APPEND _csc_OPTIONS -DBUILD_SHARED_LIBS=OFF)
    endif()


    list(APPEND _csc_OPTIONS
        "-DCMAKE_CXX_FLAGS= /DWIN32 /D_WINDOWS /W3 /utf-8 /GR /EHsc /MP"
        "-DCMAKE_C_FLAGS= /DWIN32 /D_WINDOWS /W3 /utf-8 /MP"
        "-DCMAKE_EXPORT_NO_PACKAGE_REGISTRY=ON"
        "-DCMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY=ON"
        "-DCMAKE_FIND_PACKAGE_NO_SYSTEM_PACKAGE_REGISTRY=ON"
        "-DBoost_COMPILER=-vc140"
    )
    if(DEFINED VCPKG_CRT_LINKAGE AND VCPKG_CRT_LINKAGE STREQUAL dynamic)
        list(APPEND _csc_OPTIONS_DEBUG
            "-DCMAKE_CXX_FLAGS_DEBUG=/D_DEBUG /MDd /Zi /Ob0 /Od /RTC1"
            "-DCMAKE_C_FLAGS_DEBUG=/D_DEBUG /MDd /Zi /Ob0 /Od /RTC1"
        )
        list(APPEND _csc_OPTIONS_RELEASE
            "-DCMAKE_CXX_FLAGS_RELEASE=/MD /O2 /Oi /Gy /DNDEBUG /Zi"
            "-DCMAKE_C_FLAGS_RELEASE=/MD /O2 /Oi /Gy /DNDEBUG /Zi"
        )
    elseif(DEFINED VCPKG_CRT_LINKAGE AND VCPKG_CRT_LINKAGE STREQUAL static)
        list(APPEND _csc_OPTIONS_DEBUG
            "-DCMAKE_CXX_FLAGS_DEBUG=/D_DEBUG /MTd /Zi /Ob0 /Od /RTC1"
            "-DCMAKE_C_FLAGS_DEBUG=/D_DEBUG /MTd /Zi /Ob0 /Od /RTC1"
        )
        list(APPEND _csc_OPTIONS_RELEASE
            "-DCMAKE_CXX_FLAGS_RELEASE=/MT /O2 /Oi /Gy /DNDEBUG /Zi"
            "-DCMAKE_C_FLAGS_RELEASE=/MT /O2 /Oi /Gy /DNDEBUG /Zi"
        )
    endif()
    list(APPEND _csc_OPTIONS_RELEASE
        "-DCMAKE_SHARED_LINKER_FLAGS_RELEASE=/DEBUG /INCREMENTAL:NO /OPT:REF /OPT:ICF"
        "-DCMAKE_EXE_LINKER_FLAGS_RELEASE=/DEBUG /INCREMENTAL:NO /OPT:REF /OPT:ICF"
    )

    message(STATUS "Configuring ${TARGET_TRIPLET}-rel")
    file(MAKE_DIRECTORY ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel)
    vcpkg_execute_required_process(
        COMMAND ${CMAKE_COMMAND} ${_csc_SOURCE_PATH} ${_csc_OPTIONS} ${_csc_OPTIONS_RELEASE}
            -G ${GENERATOR}
            -DCMAKE_VERBOSE_MAKEFILE=ON
            -DCMAKE_BUILD_TYPE=Release
            -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TRIPLET_FILE}
            -DCMAKE_PREFIX_PATH=${CURRENT_INSTALLED_DIR}
            -DCMAKE_INSTALL_PREFIX=${CURRENT_PACKAGES_DIR}
        WORKING_DIRECTORY ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel
        LOGNAME config-${TARGET_TRIPLET}-rel
    )
    message(STATUS "Configuring ${TARGET_TRIPLET}-rel done")

    message(STATUS "Configuring ${TARGET_TRIPLET}-dbg")
    file(MAKE_DIRECTORY ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg)
    vcpkg_execute_required_process(
        COMMAND ${CMAKE_COMMAND} ${_csc_SOURCE_PATH} ${_csc_OPTIONS} ${_csc_OPTIONS_DEBUG}
            -G ${GENERATOR}
            -DCMAKE_VERBOSE_MAKEFILE=ON
            -DCMAKE_BUILD_TYPE=Debug
            -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TRIPLET_FILE}
            -DCMAKE_PREFIX_PATH=${CURRENT_INSTALLED_DIR}/debug\\\\\\\;${CURRENT_INSTALLED_DIR}
            -DCMAKE_INSTALL_PREFIX=${CURRENT_PACKAGES_DIR}/debug
        WORKING_DIRECTORY ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg
        LOGNAME config-${TARGET_TRIPLET}-dbg
    )
    message(STATUS "Configuring ${TARGET_TRIPLET}-dbg done")
endfunction()