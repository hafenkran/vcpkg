# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/wave
    REF boost-1.82.0
    SHA512 598f7052b66f54d00949f59107ddbfa8a9fcca9ca5c7aa3c60b3d9611edd69797211a0a32d4048b1c78262ddade0e011c6bc01001b12c195950aa3d6ce6fb0d7
    HEAD_REF master
)

vcpkg_replace_string("${SOURCE_PATH}/build/Jamfile.v2"
    "import ../../config/checks/config"
    "import ../config/checks/config"
)
file(COPY "${CURRENT_INSTALLED_DIR}/share/boost-config/checks" DESTINATION "${SOURCE_PATH}/config")
include(${CURRENT_HOST_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)
boost_modular_build(SOURCE_PATH ${SOURCE_PATH})
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
