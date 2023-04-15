# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/any
    REF boost-1.82.0
    SHA512 3d65777d2b2037e996199c56420f6de419661e6dc79a226d42860f526232b31a256c0ddccb605244d98b9fc854fef42134ffe9e20b138c8f2309984345d3fc86
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
