# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/flyweight
    REF boost-1.74.0
    SHA512 66e0a8c8c7d0b2302c58d59e38506ef50d4562bf016b230332741e4ec781833e48c0945380a6028173b56fc542ba59b98edcde7f1c173129f3fdf7e8e54e9a33
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
