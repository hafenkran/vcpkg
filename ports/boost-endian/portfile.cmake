# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/endian
    REF boost-1.75.0
    SHA512 cd8ba3b22303424b848e2c985cd3e1da632ce299bff1e0fa7ff42539a077707cf50389505786c7418b6b6786c545728583baeaba8a65ead37c8c595457e64458
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
