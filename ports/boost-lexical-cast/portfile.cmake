# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/lexical_cast
    REF boost-1.74.0
    SHA512 bbec1f47a10cd42f130e0b44f00480fb6437e54652b3a235850570978e0e0e975fb020a5539ced5280eadcd6f27eaa24843590f46e2ebe632449001a760e8206
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
