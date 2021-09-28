# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/property_tree
    REF boost-1.77.0
    SHA512 60bbac071e1d62bf95e5f490e8ebde97313643ee0ad512f06247fddc89da9934322fe3351274233b7b32ac7d8602b80ae03e9161b2dbad477bdf2ff3f41aca22
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
