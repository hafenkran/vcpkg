# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/geometry
    REF boost-1.80.0
    SHA512 3b195957afa51292f21430b9dad8f1ac4a69320bc423de86813c0f3740ee6dc5a33264f91eedbd022a1ccfd520fff45acc39d87c13e70031935b76ce3a584ce1
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
