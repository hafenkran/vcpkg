include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO jpbarrette/curlpp
    REF 8810334c830faa3b38bcd94f5b1ab695a4f05eb9
    SHA512 47eb0738d7cd2d4262c455f9472a21535343bcf08bda6de19771dab9204e068272b41782c87057d50e3781683a29e79d6387577be68d175a7fa890367f15d0d2
    HEAD_REF master
    PATCHES
        fix-cmake.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(
    CONFIG_PATH lib/cmake/${PORT}
    TARGET_PATH share/unofficial-${PORT}
)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    file(REMOVE_RECURSE
        ${CURRENT_PACKAGES_DIR}/bin
        ${CURRENT_PACKAGES_DIR}/debug/bin
    )
endif()

# Handle copyright
configure_file(${SOURCE_PATH}/doc/LICENSE
    ${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright COPYONLY)

vcpkg_copy_pdbs()

# CMake integration test
#vcpkg_test_cmake(PACKAGE_NAME ${PORT})
