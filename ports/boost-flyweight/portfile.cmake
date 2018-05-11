# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/flyweight
    REF boost-1.67.0
    SHA512 eec64c8c0d473e6bb07968c8cb2dd9c12788a72008d59c8b53b14ea15ada18e740c518df6bcece1cecd13f9511898c69e00693a769404d4e51e2f7efb6c00754
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
