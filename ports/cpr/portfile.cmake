include(vcpkg_common_functions)

vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO whoshuu/cpr
    REF 1.3.0
    SHA512 fd08f8a592a5e1fb8dc93158a4850b81575983c08527fb415f65bd9284f93c804c8680d16c548744583cd26b9353a7d4838269cfc59ccb6003da8941f620c273
    HEAD_REF master
    PATCHES enable-install.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS 
        -DBUILD_CPR_TESTS=OFF
        -DUSE_SYSTEM_CURL=ON
    OPTIONS_DEBUG
        -DDISABLE_INSTALL_HEADERS=ON
)

vcpkg_install_cmake()

vcpkg_copy_pdbs()

# Handle copyright
file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/cpr)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/cpr/LICENSE ${CURRENT_PACKAGES_DIR}/share/cpr/copyright)
