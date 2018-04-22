# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/hof
    REF boost-1.67.0
    SHA512 797240bb1a3ac0ed5335dd858db7816f7f07ce99794e5d7b16b08de82ae1d80e7de9f029673569d9f880cc616037299d50571ad7ffb94e30b2d7b08392b4d1c3
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
