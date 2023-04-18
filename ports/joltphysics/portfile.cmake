vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO jrouwe/JoltPhysics
    REF "v${VERSION}"
    SHA512 367e5b945e8f91a0c0c9eb699db6f49351aa39b0af9b8fd0be5f474d65b28a7244880eedad10cbd2db0e031daa28bbabb5f9fb8bf9af653dd1f86904bfde44a2
    HEAD_REF master
)

string(COMPARE EQUAL "${VCPKG_CRT_LINKAGE}" "static" USE_STATIC_CRT)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/Build"
    OPTIONS
        -DTARGET_UNIT_TESTS=OFF
        -DTARGET_HELLO_WORLD=OFF
        -DTARGET_PERFORMANCE_TEST=OFF
        -DTARGET_SAMPLES=OFF
        -DTARGET_VIEWER=OFF
        -DCROSS_PLATFORM_DETERMINISTIC=OFF
        -DUSE_STATIC_MSVC_RUNTIME_LIBRARY=${USE_STATIC_CRT}
        -DENABLE_ALL_WARNINGS=OFF
    OPTIONS_RELEASE
        -DCMAKE_BUILD_TYPE=Distribution
)

vcpkg_cmake_build()

file(
    INSTALL "${SOURCE_PATH}/Jolt"
    DESTINATION "${CURRENT_PACKAGES_DIR}/include"
    FILES_MATCHING
        PATTERN "*.h"
        PATTERN "*.inl"
)

if(VCPKG_TARGET_IS_WINDOWS)
    file(INSTALL "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/Jolt.lib" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")
    file(INSTALL "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/Jolt.lib" DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
else()
    file(INSTALL "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/libJolt.a" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")
    file(INSTALL "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/libJolt.a" DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
endif()

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
