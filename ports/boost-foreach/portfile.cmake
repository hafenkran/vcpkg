# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/foreach
    REF boost-1.74.0
    SHA512 84987912eb07a85f34a9e10ef7711e8203f7b0cd86f3a9615470e17a51790d6e4b8e33e03c7743696ab50849d990606cebfd044be0eecd80ed41bf99dc4900bf
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
