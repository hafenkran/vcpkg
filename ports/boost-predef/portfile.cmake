# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/predef
    REF boost-1.81.0
    SHA512 aef179eb05efa197ba5f608041f6211ee58f36dea1e8e8b9ac64fc9187cd5542dd727e5d94b3f373030fb0f07ac4195be3ec0334c7ed0d44f8efa42b8117d55f
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})

file(COPY ${SOURCE_PATH}/tools/check DESTINATION ${CURRENT_PACKAGES_DIR}/share/boost-predef)
