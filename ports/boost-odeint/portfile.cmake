# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/odeint
    REF boost-1.74.0
    SHA512 650156c1c177a3438964a35a160b89b84e598e771cd7e113f7165b979d36004e1ea28bbd74f70dab0033cd62caea178a75400ffd55b1ddf79b778b1dd08cfd57
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
