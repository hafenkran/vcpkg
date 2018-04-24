# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/property_tree
    REF boost-1.67.0
    SHA512 b22b596af0a6a39a4671c44aa099cd4c2235a5f51e1400f14df2925a5a17487d8910253228c61b1198f0184e58e6e2940c7fde5c193549c21efe737bed363d67
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
