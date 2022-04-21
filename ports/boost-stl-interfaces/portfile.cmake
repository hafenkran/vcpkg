# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/stl_interfaces
    REF boost-1.79.0
    SHA512 e41e0465144ea65d10524f560a90b3a0ad1c60af8f5b679aba7e1bb12a09fccf9a4e271d6e1f6eff02ce7c444a21a8b9ea38709c5c6836ed4d7a35659756b0b8
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
