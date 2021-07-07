# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/heap
    REF boost-1.76.0
    SHA512 11f16b0a573108d2c2f58ba9669371d2db5e6090f9d50abc367fd295fb5966a985793081e222742305e9cc86d950c8545f1afa0a855d43eab6cabf41a36e9335
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
