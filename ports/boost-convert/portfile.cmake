# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/convert
    REF boost-1.81.0
    SHA512 4c49c53e0084aa126ef9be3734d38f51448621275728cb00878f08a755eb753899b812c09ad754d5ae4d60940cda442dbc77223ef06a497be9627c2c05836d76
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
