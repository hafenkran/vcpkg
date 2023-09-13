# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/flyweight
    REF boost-1.83.0
    SHA512 c054403707a0574c0b2e5c7f34521153f604ae17d10a52ed7ff8e222d006ff4875d3e479abacce18c59edd2d44d8fec63f22a806d7a203094ce9e885ffbd903b
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
