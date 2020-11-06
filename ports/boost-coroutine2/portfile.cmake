# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/coroutine2
    REF boost-1.74.0
    SHA512 276e79d7f3476899e91c4cb67670fb1e6aa582e74b12fae1c88f91ac8ec11d212f2672788814676042a1dd2ce50555ef7ed78024871275f9bd66747f4669267f
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
