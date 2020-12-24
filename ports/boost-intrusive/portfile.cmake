# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/intrusive
    REF boost-1.75.0
    SHA512 4d211523102861cbfa01413dcdaff153bc51ce095e98f8a7cab061901f6dec79ba1cdc898df0e217cff1d1f3febbb9ee4c3188ef200d6161c883b3c6a928d08a
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
