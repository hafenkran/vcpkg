# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/hana
    REF boost-${VERSION}
    SHA512 4bebdab6122fd98a5c1b6a5a4b52965f045c5525cd6683c48498fdbad2d0dbc3aa4d4673163930d96ac24c014bcbd755318780a6798f8ab2edd83463877b57c4
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
