# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/type_index
    REF boost-1.80.0
    SHA512 9ad38e8560e327ea3f2f419e9b264bb78864bd7a518d90fe65da159d989720f9125fe5d710ed627a61a523e61762f672a7763b100e474cb9b9c54bc592ad80a3
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
