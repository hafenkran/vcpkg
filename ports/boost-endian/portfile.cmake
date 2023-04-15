# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/endian
    REF boost-1.82.0
    SHA512 07c17826f9a1478e68330da7e57f042d02fd78121b488d1e63c68dc35e17463551dc478de2779f292b6f81ec776249ba161653baf31f873d45913dcd822fe261
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
