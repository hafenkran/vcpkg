# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/multi_array
    REF boost-1.73.0
    SHA512 72e200ed03eaa25e354461f8f4bcddb0a216902e3198d5d653ce4f1dfe6aa637f4f81608e98e2e736ecfd42466dd62ffd10907b908daa4735dadef23bb5950b4
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
