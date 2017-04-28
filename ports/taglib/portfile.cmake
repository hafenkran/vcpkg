include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/taglib-1.11.1)
vcpkg_download_distfile(ARCHIVE
    URLS "http://taglib.org/releases/taglib-1.11.1.tar.gz"
    FILENAME "taglib-1.11.1.tar.gz"
    SHA512 7846775c4954ea948fe4383e514ba7c11f55d038ee06b6ea5a0a1c1069044b348026e76b27aa4ba1c71539aa8143e1401fab39184cc6e915ba0ae2c06133cb98
)
vcpkg_extract_source_archive(${ARCHIVE})

#patches for UWP
vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/ignore_c4996_error.patch
        ${CMAKE_CURRENT_LIST_DIR}/replace_non-uwp_functions.patch
        ${CMAKE_CURRENT_LIST_DIR}/dont-assume-latin-1.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
)

vcpkg_install_cmake()

# remove the debug/include files
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# copyright file
file(COPY ${SOURCE_PATH}/COPYING.LGPL DESTINATION ${CURRENT_PACKAGES_DIR}/share/taglib)
file(COPY ${SOURCE_PATH}/COPYING.MPL DESTINATION ${CURRENT_PACKAGES_DIR}/share/taglib)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/taglib/COPYING.LGPL ${CURRENT_PACKAGES_DIR}/share/taglib/copyright)

# remove bin directory for static builds (taglib creates a cmake batch file there)
if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()

vcpkg_copy_pdbs()