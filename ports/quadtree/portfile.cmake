vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO pvigier/Quadtree
    REF a28cb41eeee3f020eb807cf9d7fd5859f62bbacd
    SHA512 52fcf3b48d87f18a05feb216f5439eba3f19608b4453c27a3c689242ba638588c054c7b5a39f0686073314ed6ac53717a37b6cdc66f9cd6e5d96f0fe84d90d54
    HEAD_REF master
)

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DCODE_COVERAGE=OFF
        -DBUILD_BENCHMARKS=OFF
        -DBUILD_TESTING=OFF
        -DBUILD_EXAMPLES=OFF
)

file(INSTALL ${SOURCE_PATH}/include/ DESTINATION ${CURRENT_PACKAGES_DIR}/include/${PORT})
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
