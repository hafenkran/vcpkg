# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/intrusive
    REF boost-1.82.0
    SHA512 66afd78359bf510770901a89f668b0bb520ec4c6546cbef83d9fb101989fd406e8baf465f35ff8655618d0b169fc8fd5aa8d2f89349269a091c35ef75285ef07
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
