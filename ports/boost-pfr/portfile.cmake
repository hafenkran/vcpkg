# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/pfr
    REF boost-1.81.0
    SHA512 07f06666c66e8408775410d8fc2598a139a50caed45346c14234e3f0e060c1d59c803d393f737956d9772055b6f1b0dc84ff9e98583dcfdb0fe265737b726265
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
