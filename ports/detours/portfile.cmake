vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO microsoft/Detours
    REF v4.0.1
    SHA512 0a9c21b8222329add2de190d2e94d99195dfa55de5a914b75d380ffe0fb787b12e016d0723ca821001af0168fd1643ffd2455298bf3de5fdc155b3393a3ccc87
    HEAD_REF master
    PATCHES 
        find-jmp-bounds-arm64.patch
)

vcpkg_build_nmake(
    SOURCE_PATH "${SOURCE_PATH}"
    PROJECT_SUBPATH "src"
    PROJECT_NAME "Makefile"
    OPTIONS "PROCESSOR_ARCHITECTURE=${VCPKG_TARGET_ARCHITECTURE}"
    OPTIONS_RELEASE "DETOURS_CONFIG=Release"
    OPTIONS_DEBUG "DETOURS_CONFIG=Debug"
)

if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "release")
    file(INSTALL "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/lib.${VCPKG_TARGET_ARCHITECTURE}Release/" DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
endif()
if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "debug")
    file(INSTALL "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/lib.${VCPKG_TARGET_ARCHITECTURE}Debug/" DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")
endif()

if(NOT DEFINED VCPKG_BUILD_TYPE OR VCPKG_BUILD_TYPE STREQUAL "release")
    file(INSTALL "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/include/" DESTINATION "${CURRENT_PACKAGES_DIR}/include" RENAME detours)
else()
    file(INSTALL "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/include/" DESTINATION "${CURRENT_PACKAGES_DIR}/include" RENAME detours)
endif()

file(INSTALL "${SOURCE_PATH}/LICENSE.md" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
