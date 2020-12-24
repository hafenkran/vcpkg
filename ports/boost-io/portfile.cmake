# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/io
    REF boost-1.75.0
    SHA512 0c5efe91d1a83a7a42e035de0720e92d7f4ca9af692913845d9a5a5e3ba994c5b9664c87b60d5f6345c5dd395e8d0c2074827e37d8e76f75548d95f845c194d2
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
