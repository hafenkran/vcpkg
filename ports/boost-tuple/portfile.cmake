# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular.cmake)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/tuple
    REF boost-1.66.0
    SHA512 c65bd37871256f1edb1db4d9ac158788c3a76248d7f7ff72eece874ea521d9846d55373e223d783a4c6fe3a524088fe2e4e58e533d1144671e4a1d22443f0414
    HEAD_REF master
)

boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
