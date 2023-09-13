# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/range
    REF boost-1.83.0
    SHA512 a1fb0f51c0494e7c018b8b792ab3ae30a08eeb0a6f1eb36dbbce9955f5d83a3ae7f0e630ccb6167ebc4693e42ce3e1d35fcad40dd60b3328918a0d52709523a2
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
