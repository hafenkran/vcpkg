# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/odeint
    REF boost-1.80.0
    SHA512 9bcebd443556e3d122e4474b728b277d801195adc26ba4e82ee6609c6bd1c902b1a6220d8d5c3856be2daf04b86dc0a56d4bd2d56ae1a17dd88a50b6fa5f97f3
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
