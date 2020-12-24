# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/utility
    REF boost-1.75.0
    SHA512 43c02e8e1ca9e81e6de660c677ea6af6a84a82de0be06a24db1277bb38150b15da0c5466adc7b8f1c527718ebcbd51945671b8362c790322ae9468e4381b1752
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
