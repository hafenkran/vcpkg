# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/fusion
    REF boost-1.82.0
    SHA512 142ee69b7438bca8feacb7511a99680bdc669044a8eb58eb059bc5bbd62de3f9319fbb759c110412e515a106e0ea43dcdb194ebe522bebf5e77b567627ab11f3
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
