# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/format
    REF boost-1.70.0
    SHA512 a36cc172fec72b5fd989d6e11d8f2f80f93138a99b03a7b1443663ff81ce2f302dd50f25e0308229de9dd6f59b8510151f27255cdafcac152b185c7174d11a86
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
