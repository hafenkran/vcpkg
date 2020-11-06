# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/circular_buffer
    REF boost-1.74.0
    SHA512 8f756c74fe1c15f3591cf40d8dd5c6aaeb2c46e581cd2fe08700b08562c1751975dcfc2793d7fa830a583a0528f7e4e07599c034af522469bb938578e63866fe
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
