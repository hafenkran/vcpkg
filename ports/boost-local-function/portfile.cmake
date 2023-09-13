# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/local_function
    REF boost-1.83.0
    SHA512 8dc0a64eba885bae71cb1c7092faba09eaf14ae02534726fad96bc347d90e30f5dc7a62fcf46ed543cd03cec011dcdc459dd27fcd4ac732b8c7c0c38cf632448
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
