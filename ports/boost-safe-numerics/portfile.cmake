# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/safe_numerics
    REF boost-1.83.0
    SHA512 b9b62491b64a320a57edd3306db7936f0a6a383c17111a72db29aa284ff8955cf00094eff0a315d236cf2c32d4f6a50b4ecf83d3a74f957853002ec676a8ccf9
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
