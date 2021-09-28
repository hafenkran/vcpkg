# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/align
    REF boost-1.77.0
    SHA512 786c63da7d5593282356dc0010a63b46b5f50236890228481c9676f543ab2d56cb5418d913bce2daad8c5bbad3feded7068ac2ab6d68481be9c25401b22ff7f6
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
