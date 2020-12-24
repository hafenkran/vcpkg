# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/local_function
    REF boost-1.75.0
    SHA512 83807dfc36810a27194841eac25b70905572f6da656e75d5f04e5b4d4abec58710a34d17e69fb6588154950f1099702c8205c26c47770fe21f875a9bd7641fe6
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
