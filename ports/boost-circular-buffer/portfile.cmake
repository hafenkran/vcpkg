# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/circular_buffer
    REF boost-${VERSION}
    SHA512 e945cb9d701b23043fdd6ceaede292e2605f3ae7b9038e79e95eddf69fe781f4efcea67877f041db1eb8fe95f4bcf4ca34f845e90e5307c72ce811f68d649b6b
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
