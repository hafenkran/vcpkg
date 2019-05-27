# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/mp11
    REF boost-1.70.0
    SHA512 d09415d5c69a1960c8af3c3e63a61aef62d2a35f00fe42e8dd8ad3eeb2f13eed48e0710485f444e79cfd7ab2fa3f72535e01d9b97337c89328b961fa20aeb047
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
