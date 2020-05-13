# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/process
    REF boost-1.73.0
    SHA512 6f03f492ebe7b4ceb6ee15f50767c43200f0d0a9237df53d9f893964eed9d28d5784b591b348425d4972d47742fcc78049753ac28a79afd0ca13e2824b2f4690
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
