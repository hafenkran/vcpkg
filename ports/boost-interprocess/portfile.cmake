# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/interprocess
    REF boost-1.74.0
    SHA512 96311610208f322275434f1a271a2782673e11f5dd133c6994d64397ac2099f4561711f08b12eeb3b25fb78e743a2d5bbbe4a331843e306ae1698bd327d959f3
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
