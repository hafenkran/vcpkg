# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/local_function
    REF boost-1.78.0
    SHA512 4df1e13e9314dc31fabd2e0451e09a69b6f976efa41b2fae87766bb9ba271ab47604f15ae138c694b8e15ea51289ca8c2e882179ca55b9abd904bd166b0bd2b4
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
