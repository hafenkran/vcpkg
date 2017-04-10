 # Glib uses winapi functions not available in WindowsStore
if (VCPKG_CMAKE_SYSTEM_NAME STREQUAL WindowsStore)
    message(FATAL_ERROR "Error: UWP builds are currently not supported.")
endif()

# Glib relies on DllMain
if (VCPKG_LIBRARY_LINKAGE STREQUAL static)
    message(STATUS "Warning: Static building not supported. Building dynamic.")
    set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()

include(vcpkg_common_functions)
set(GLIB_VERSION 2.52.1)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/glib-${GLIB_VERSION})
vcpkg_download_distfile(ARCHIVE
    URLS "https://ftp.gnome.org/pub/gnome/sources/glib/2.52/glib-${GLIB_VERSION}.tar.xz"
    FILENAME "glib-${GLIB_VERSION}.tar.xz"
    SHA512 6f0475b4ee1078867671a79b1751674926ba1caa872cec3896e2830c61c3cde67972afa9f2d606a2b6705e9846222462b003c6e966a9b63982f3fc3fb58c4d37)

vcpkg_extract_source_archive(${ARCHIVE})
vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/use-libiconv-on-windows.patch)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/cmake DESTINATION ${SOURCE_PATH})
file(REMOVE_RECURSE ${SOURCE_PATH}/glib/pcre)
file(REMOVE ${SOURCE_PATH}/glib/win_iconv.c)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DGLIB_VERSION=${GLIB_VERSION}
    OPTIONS_DEBUG
        -DGLIB_SKIP_HEADERS=ON
        -DGLIB_SKIP_TOOLS=ON)

vcpkg_install_cmake()
vcpkg_copy_pdbs()
vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/glib)

file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/glib)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/glib/COPYING ${CURRENT_PACKAGES_DIR}/share/glib/copyright)

