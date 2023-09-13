# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/integer
    REF boost-1.83.0
    SHA512 7e477d9b5cbba4ba0a9153ad312f33bcfc95654b387233c364bbdf9fc51e098cd4db004fec17c2f8fe4f837eb96e96da0f4fcc3392d6657dc91295c295c3c4d1
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
