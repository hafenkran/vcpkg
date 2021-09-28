# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/intrusive
    REF boost-1.77.0
    SHA512 9fed1756ca0c4abe1c64bd9794cc5f8548f71fef761d0cef25f6d10ee65d84cdc34216e20e4e29e34d7664a6addac7cbbc4f2f43d5faaa0c0660fad20a594ad3
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
