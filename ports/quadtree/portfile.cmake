vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO pvigier/Quadtree
    REF fec2e1a011f656353ba12c58cefe33482e1a27b5
    SHA512 8291afb29b9ff5714125e411122f6f10e1c2e4c2109384e25afa834548dc1f63c90b2d09c7cfed213ad69a8c54cf32fc598783b3ff0882bc86562594895d5c35
    HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DCODE_COVERAGE=OFF
        -DBUILD_BENCHMARKS=OFF
        -DBUILD_TESTING=OFF
        -DBUILD_EXAMPLES=OFF
)

file(INSTALL ${SOURCE_PATH}/include/ DESTINATION ${CURRENT_PACKAGES_DIR}/include/${PORT})
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
