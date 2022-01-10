# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/container_hash
    REF boost-1.78.0
    SHA512 344ed155031904336c48c61b66a23b420cb63e5601ea1f5eb614dcac576aff8900b3cd79889b5313f2f7558ece81efc3a1944c07d0374a00a3766eb4b1dda3e0
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
