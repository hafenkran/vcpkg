# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/parameter
    REF boost-1.74.0
    SHA512 251770908e4e167136fe6963c131be7da9589970e8c8dfbc96033e82b1a6f1d31bf810859c495d202dbfe19de817865a7c7988a9ca96f5df5f3a14d930c0df9e
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
