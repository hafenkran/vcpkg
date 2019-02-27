# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/unordered
    REF boost-1.69.0
    SHA512 51bbbdcc0661b502445e53091bb5ab859ece03ce549365ac58964459e0b7c162e10b166324b8b9c28a9a8aef5532fa31fed68bbb878e3d36f115a6279109e4b7
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
