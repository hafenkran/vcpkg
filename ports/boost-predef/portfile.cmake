# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/predef
    REF boost-1.79.0
    SHA512 329616d4b1e1e160b92f3f33f3172eeb124c9167616c29443804a817230c747fb51f211b2727b28c9a9a50364b4b7fb535000f22572e6db4f9e4b31b8ca375b9
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})

file(COPY ${SOURCE_PATH}/tools/check DESTINATION ${CURRENT_PACKAGES_DIR}/share/boost-predef)
