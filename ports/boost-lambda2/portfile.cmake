# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/lambda2
    REF boost-1.83.0
    SHA512 0848d250675f271a8f7fd68e2b7934cce6e7447365eb28101b40bb9af26d54b2a4bdcba655ee3cd94c01a812b65279d75e0e9492fb69a1006983cf7969da37ce
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
