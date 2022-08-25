# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/property_map
    REF boost-1.80.0
    SHA512 831a8f0973523d7bcaf45a7ad85c9c42a8df48a6d23b44d9282bd3fb980d7f88f73b51d63da535a6cd8c189c1f955ace2b8e337f7f669ee2cffe367503265265
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
