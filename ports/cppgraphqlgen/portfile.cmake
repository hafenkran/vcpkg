vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO microsoft/cppgraphqlgen
    REF fb4a589c84c102d867e7bfb03884d40f7776315b
    SHA512 88fedd83b49ae25f2165cff8e3a5e3e46ed853312658924f08b3192c790e92583dc8b8f7a88f39ec17798bd7d986143a78633a89d3867400539c4d315015e29b
    HEAD_REF main
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS 
        -DGRAPHQL_BUILD_TESTS=OFF 
        -DGRAPHQL_UPDATE_VERSION=OFF 
        -DGRAPHQL_UPDATE_SAMPLES=OFF 
        -DGRAPHQL_INSTALL_CONFIGURATIONS=Release
    OPTIONS_RELEASE 
        -DGRAPHQL_INSTALL_CMAKE_DIR=${CURRENT_PACKAGES_DIR}/share 
        -DGRAPHQL_INSTALL_TOOLS_DIR=${CURRENT_PACKAGES_DIR}/tools
    OPTIONS_DEBUG 
        -DGRAPHQL_INSTALL_CMAKE_DIR=${CURRENT_PACKAGES_DIR}/debug/share 
        -DGRAPHQL_INSTALL_TOOLS_DIR=${CURRENT_PACKAGES_DIR}/debug/tools
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets()

vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/cppgraphqlgen)

vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
