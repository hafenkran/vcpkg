vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO sgieseking/anyrpc
    REF b288617d0ae1d6e227bcda7d3db7db5329fa2322
    SHA512 d50ef96ad13f06991e65e9912225b64c1f244bf89b67e4afcddbb18e08a885ec773aea88e1334d6deb73bb3824e916695b3b187b9023368aec3ba21a53dd2830
    HEAD_REF master
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" ANYRPC_LIB_BUILD_SHARED)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
    -DBUILD_EXAMPLES=OFF
    -DBUILD_TESTS=OFF
    -DBUILD_WITH_LOG4CPLUS=OFF
    -DANYRPC_LIB_BUILD_SHARED=${ANYRPC_LIB_BUILD_SHARED}
)

vcpkg_install_cmake()

file(INSTALL ${SOURCE_PATH}/license DESTINATION ${CURRENT_PACKAGES_DIR}/share/anyrpc RENAME copyright)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

vcpkg_copy_pdbs()
