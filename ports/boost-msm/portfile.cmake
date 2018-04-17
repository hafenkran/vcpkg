# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/msm
    REF boost-1.67.0
    SHA512 073afc97247d0cf6eb579cffafbd43696390b28125d7e104cba4b5e2ac6120b24f64c5fa167f5e5958d7e7fb93eb7ea698b660f9fcee781bd84068919f6512e7
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
