vcpkg_minimum_required(VERSION 2022-10-12) # for ${VERSION}

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO libjxl/libjxl
    REF "v${VERSION}"
    SHA512 c73039606acf7b2cbc331c6787af5167d711fd1af22bc616e1f478c531b087da82c98f2cb7e88c4d1f8bcfdc4e053ae0dc99cc9a811545b7f9658041489ed04b
    HEAD_REF main
    PATCHES
        fix-dependencies.patch
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        tools JPEGXL_ENABLE_TOOLS
    INVERTED_FEATURES
        tools CMAKE_DISABLE_FIND_PACKAGE_GIF
        tools CMAKE_DISABLE_FIND_PACKAGE_JPEG
        tools CMAKE_DISABLE_FIND_PACKAGE_PNG
        tools CMAKE_DISABLE_FIND_PACKAGE_ZLIB
)

if(VCPKG_TARGET_IS_UWP)
    string(APPEND VCPKG_C_FLAGS " -D_CRT_SECURE_NO_WARNINGS /wd4146")
    string(APPEND VCPKG_CXX_FLAGS " -D_CRT_SECURE_NO_WARNINGS /wd4146")

    # Temporary workaround for #9390
    if(VCPKG_TARGET_ARCHITECTURE STREQUAL "x86")
        list(APPEND FEATURE_OPTIONS -DCMAKE_SYSTEM_PROCESSOR=x86)
    elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
        list(APPEND FEATURE_OPTIONS -DCMAKE_SYSTEM_PROCESSOR=AMD64)
    elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm")
        list(APPEND FEATURE_OPTIONS -DCMAKE_SYSTEM_PROCESSOR=ARM)
    elseif(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
        list(APPEND FEATURE_OPTIONS -DCMAKE_SYSTEM_PROCESSOR=ARM64)
    else()
        message(FATAL_ERROR "Unsupported uwp VCPKG_TARGET_ARCHITECTURE \"${VCPKG_TARGET_ARCHITECTURE}\"")
    endif()
    # Workaround for vcpkg-cmake bug, proper fix in #21857
    set(_TARGETTING_UWP 1)
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        "-DJPEGXL_VERSION=${JPEGXL_VERSION}"
        -DJPEGXL_FORCE_SYSTEM_HWY=ON
        -DJPEGXL_FORCE_SYSTEM_BROTLI=ON
        -DJPEGXL_FORCE_SYSTEM_LCMS2=ON
        ${FEATURE_OPTIONS}
        -DJPEGXL_ENABLE_FUZZERS=OFF
        -DJPEGXL_ENABLE_MANPAGES=OFF
        -DJPEGXL_ENABLE_BENCHMARK=OFF
        -DJPEGXL_ENABLE_EXAMPLES=OFF
        -DJPEGXL_ENABLE_JNI=OFF
        -DJPEGXL_ENABLE_SJPEG=OFF
        -DJPEGXL_ENABLE_OPENEXR=OFF
        -DJPEGXL_ENABLE_PLUGINS=OFF
        -DJPEGXL_ENABLE_SKCMS=OFF
        -DJPEGXL_ENABLE_TCMALLOC=OFF
        -DBUILD_TESTING=OFF
        -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=1
    MAYBE_UNUSED_VARIABLES
        CMAKE_DISABLE_FIND_PACKAGE_GIF
        CMAKE_DISABLE_FIND_PACKAGE_JPEG
        CMAKE_DISABLE_FIND_PACKAGE_PNG
        CMAKE_DISABLE_FIND_PACKAGE_ZLIB
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

if(JPEGXL_ENABLE_TOOLS)
    vcpkg_copy_tools(TOOL_NAMES cjxl djxl cjpeg_hdr jxlinfo AUTO_CLEAN)
endif()

# libjxl always builds static libraries, so we delete them if we don't need them.
if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    if(VCPKG_TARGET_IS_WINDOWS)
        file(GLOB FILES_TO_REMOVE
            "${CURRENT_PACKAGES_DIR}/lib/*-static.lib"
            "${CURRENT_PACKAGES_DIR}/debug/lib/*-static.lib"
        )
    else()
        file(GLOB FILES_TO_REMOVE
            "${CURRENT_PACKAGES_DIR}/lib/*.a"
            "${CURRENT_PACKAGES_DIR}/debug/lib/*.a"
        )
    endif()
    file(REMOVE ${FILES_TO_REMOVE})
endif()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
