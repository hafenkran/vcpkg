# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/compute
    REF boost-1.67.0
    SHA512 d7f470eb2dcf96198d68d61edf8d53491819f8e29452f80e4140e34a11e044ecd45cfdbcd28cc29da2e905c6f324872704d4a834c62242050a0d5fc46deda029
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
