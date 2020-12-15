# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/tuple
    REF boost-1.74.0
    SHA512 a3547b82801917a76612db31d4c33e06cfc3b4ce57bf3f9c7f6555de6c542f6fc7dc95ce39b49c109cfb75b1df21738782144735ad548b690605b50708863a17
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
