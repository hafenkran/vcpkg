# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/variant
    REF boost-1.78.0
    SHA512 456ad20b949a49622cd6ccaf2be896b2ca976b90535f95e1c59efc27e7a02b9c56b6843464586f065c889be149d2afae80368e810a36aa5cd2314e2e64ca1842
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
