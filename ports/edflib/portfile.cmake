vcpkg_from_gitlab(
    GITLAB_URL https://gitlab.com
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Teuniz/EDFlib
    REF "v${VERSION}"
    SHA512 3994d108efa45f49c4b9b68e6cfd10997b0c379631c1096dad7dd637cabe69c946d02e4204883308439ee5c9fe2382fc2f533ea14fe36bbbe6cedbaf04736b67
    HEAD_REF master
)

file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" DESTINATION "${SOURCE_PATH}")

vcpkg_check_features(
    OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        tools BUILD_TOOLS
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
)

vcpkg_cmake_install()

vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

if(VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    vcpkg_replace_string(
        "${CURRENT_PACKAGES_DIR}/include/edflib.h"
        "#if defined(EDFLIB_SO_DLL)"
        "#if 1 // defined(EDFLIB_SO_DLL)"
    )
endif()

vcpkg_cmake_config_fixup(PACKAGE_NAME unofficial-EDFlib)

if ("tools" IN_LIST FEATURES)
    vcpkg_copy_tools(
        TOOL_NAMES
            sine_generator
            sweep_generator
        AUTO_CLEAN
    )
endif()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
