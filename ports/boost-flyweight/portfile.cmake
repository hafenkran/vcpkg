# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/flyweight
    REF boost-1.71.0
    SHA512 7ddd93cc12070faeae30249b30dabf5d5cbd41bb7f0f92531baff163702b9cb53d28a0211b4e9352476576cecd1e1734f2c757c674549dc93f366cb9d60657a3
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
