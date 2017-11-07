include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO glennrp/libpng
    REF v1.6.34
    SHA512 23b6112a1d16a34c8037d5c5812944d4385fc96ed819a22172776bdd5acd3a34e55f073b46087b77d1c12cecc68f9e8ba7754c86b5ab6ed3016063e1c795de7a
    HEAD_REF master
)

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/use-abort-on-all-platforms.patch
)

if(VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    set(PNG_STATIC_LIBS OFF)
    set(PNG_SHARED_LIBS ON)
else()
    set(PNG_STATIC_LIBS ON)
    set(PNG_SHARED_LIBS OFF)
endif()

# Libpng's cmake uses if(${CMAKE_SYSTEM_PROCESSOR} ....) which performs double-evaluation and breaks if the variable is not defined.
if(VCPKG_TARGET_ARCHITECTURE STREQUAL x64)
    set(CMAKE_SYSTEM_PROCESSOR AMD64)
else()
    set(CMAKE_SYSTEM_PROCESSOR ${VCPKG_TARGET_ARCHITECTURE})
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DPNG_STATIC=${PNG_STATIC_LIBS}
        -DPNG_SHARED=${PNG_SHARED_LIBS}
        -DPNG_TESTS=OFF
        -DSKIP_INSTALL_PROGRAMS=ON
        -DSKIP_INSTALL_EXECUTABLES=ON
        -DSKIP_INSTALL_FILES=ON
        -DCMAKE_SYSTEM_PROCESSOR=${CMAKE_SYSTEM_PROCESSOR}
    OPTIONS_DEBUG
        -DSKIP_INSTALL_HEADERS=ON
)

vcpkg_install_cmake()

if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    file(RENAME ${CURRENT_PACKAGES_DIR}/lib/libpng16_static.lib ${CURRENT_PACKAGES_DIR}/lib/libpng16.lib)
    file(RENAME ${CURRENT_PACKAGES_DIR}/debug/lib/libpng16_staticd.lib ${CURRENT_PACKAGES_DIR}/debug/lib/libpng16d.lib)
endif()

# Remove CMake config files as they are incorrectly generated and everyone uses built-in FindPNG anyway.
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/lib/libpng ${CURRENT_PACKAGES_DIR}/debug/lib/libpng)
file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libpng)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/libpng/LICENSE ${CURRENT_PACKAGES_DIR}/share/libpng/copyright)

vcpkg_copy_pdbs()
