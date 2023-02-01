# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/property_map
    REF boost-1.81.0
    SHA512 13170f7bf807fdcaac37271ced6ad7357cf703c048ef9e9c2db554623ebe276bfbc0f1884b2d1f4b59b0316857ad3f6578401815127439e57064dde7aacc6c43
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
