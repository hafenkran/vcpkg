# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/bind
    REF boost-${VERSION}
    SHA512 3cec732e7de8c6a7a3f752d3c25a2d3411d522995880e4014a188b8bc2767f87e12801862362ce6c6618ebb65d17b6611afdf2b25f2b87c09aab4191d0f71ba6
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
