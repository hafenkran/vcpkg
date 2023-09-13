# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/compatibility
    REF boost-1.83.0
    SHA512 bc6ff1c30acc9f7123e9b28a732960776e1a028bf0fc5459f39266546f1e2466c62366cc689dab6f8a59a4a46fa9ae3370b4bca14b51d364c3d16e680d5ff95b
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
