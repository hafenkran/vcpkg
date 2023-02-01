# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/intrusive
    REF boost-1.81.0
    SHA512 1140d3862f53eb46fab4adefa1535f7ec0270bf555e6720b6c8ad35de583d4635bd564e30a2432faf67cc809d410205649c502ea6355207b48af163349fb748e
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
