# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/statechart
    REF boost-1.80.0
    SHA512 c6248ba5e5ca325652ee54c0bba021662c3b04d9d1bcda68b37d8d72ec36a7427354e986d036577d72e3fa4eff5d471327a7d8e84ebacbac2fc9ea3b0f7ef04b
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
