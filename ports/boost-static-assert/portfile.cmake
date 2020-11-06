# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/static_assert
    REF boost-1.74.0
    SHA512 ed837f88964a9244378f67583a2392bdc493d34ba7910f01e354d9c7508eb5de563075718dd22dca8e5abe2037aa2de46a78ee591df514432f2fd3d64eb4ecc1
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
