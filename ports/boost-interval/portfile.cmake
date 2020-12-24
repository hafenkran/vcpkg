# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/interval
    REF boost-1.75.0
    SHA512 25ba8052f562585ca1d98be93fe97facd0d485a70e230f0f7d95911a6ce92bd60d3d56844782e5136a89a51303fbf8d751897578ac4e9bc8c2672b84cac7cc3d
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
