# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/function_types
    REF boost-1.73.0
    SHA512 b4cd2febca5286e293fc4c8c9c234190b675a173b29eb200a745f358120b9fd26681f9f74a84a5b910a66f82834c078f718e242aa4b08753a701b2d622e47078
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
