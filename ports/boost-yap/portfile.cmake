# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/yap
    REF boost-1.81.0
    SHA512 def98e5c2b1de0587eb5d954cf025ae5242b0dbc3d5eecd9e718c617d6b269bb1842bd6cc0f705c3b29c6a63061a38974aadbab24b31e3acfecd97eb69c48616
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
