# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/pool
    REF boost-1.83.0
    SHA512 1f885d10f66d1292222fe77c1b0dc43612fe12d0f72f0daaa874dc2f807ee40083cce1d5f32ec6fdcaa9f71c48310b442efc215394282214c8b0407cd84841ea
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
