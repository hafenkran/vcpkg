# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/compatibility
    REF boost-1.71.0
    SHA512 200da5b918150f08fa7c033c8323d08132eb3f744215e4e5ae723cab235c9d4643e253e1c7f2682af774283eb41d4d73322fdd396e74fafb93fd1716c368d79d
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
