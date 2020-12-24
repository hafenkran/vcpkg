# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/iterator
    REF boost-1.75.0
    SHA512 28148a5980f31e8d6e553800387335c9cb9ace06533c54825337178488efe1726f8ceb333da80dff394685c64aaf4848598845555a7f16bbde0bd73cf5c80e9b
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
