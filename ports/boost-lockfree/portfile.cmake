# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/lockfree
    REF boost-1.77.0
    SHA512 134e9f9d30b4ac124f2a18e0cf265c7ea7342279876625302bfeec8e25aff716e00ccd229389b0197b59d9ca85787eafb3fdec680a70d791497245dd8ca2cbec
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
