# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/serialization
    REF boost-1.83.0
    SHA512 d4d69c383ce486e829e02c95ea714faa776444d457e8ac4cc6e1595853f741a4bbbee35a13d0e625e05854b0799c504472a3912d529ebd3da02c0b6f0adf95a9
    HEAD_REF master
)

include(${CURRENT_HOST_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)
boost_modular_build(SOURCE_PATH ${SOURCE_PATH})
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
