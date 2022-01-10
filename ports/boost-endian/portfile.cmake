# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/endian
    REF boost-1.78.0
    SHA512 f010f4c1d301637fc8fbd9220eb7456cd9f0ce04cfc56af2c25092a7a53a4f7e541cfc65bab46e65fe6007184d335b99b03ec0d26ab7935ffd5d622c99caf817
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
