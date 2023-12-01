vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO podofo/podofo
    REF "${VERSION}"
    SHA512 b5b7d4236a1f15b4eeee9d24210015b983910e88efa4727dd551f58b4d39cf7566314513b99099f54835b90a209cbf8231e04d19b63019223113abe6520fc932
    PATCHES
        fix-interface-include.patch
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        fontconfig  CMAKE_REQUIRE_FIND_PACKAGE_Fontconfig
    INVERTED_FEATURES
        fontconfig  CMAKE_DISABLE_FIND_PACKAGE_Fontconfig
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" PODOFO_BUILD_STATIC)

file(REMOVE "${SOURCE_PATH}/cmake/modules/FindOpenSSL.cmake")
file(REMOVE "${SOURCE_PATH}/cmake/modules/FindZLIB.cmake")

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DPKG_CONFIG_FOUND=true # enable pc file for shared linkage
        -DPODOFO_BUILD_LIB_ONLY=1
        -DPODOFO_BUILD_STATIC=${PODOFO_BUILD_STATIC}
        -DCMAKE_DISABLE_FIND_PACKAGE_Libidn=ON
    MAYBE_UNUSED_VARIABLES
        PKG_CONFIG_FOUND # Fix the warning of static build.
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

vcpkg_replace_string( "${CURRENT_PACKAGES_DIR}/share/${PORT}/podofo-config.cmake"
    "# Generated by CMake"
    "include(CMakeFindDependencyMacro)
find_dependency(Freetype)
find_dependency(JPEG)
find_dependency(LibXml2)
find_dependency(OpenSSL)
find_dependency(PNG)
find_dependency(TIFF)
find_dependency(ZLIB)
if(\"${CMAKE_REQUIRE_FIND_PACKAGE_Fontconfig}\")
    find_dependency(Fontconfig)
endif()
\n# Generated by CMake")

vcpkg_cmake_config_fixup()
vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

# Handle copyright
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
