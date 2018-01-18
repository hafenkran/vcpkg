# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/beast
    REF boost-1.66.0
    SHA512 0559721217469b3862c6653488de245841f351098766d2cbf4d0fd3a2ecdd96460ecaf5591166dc59f7c5a9806edab9101c9939c98b294c3cbd2d738dd07f6c6
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
