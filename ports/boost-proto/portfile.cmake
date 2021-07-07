# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/proto
    REF boost-1.76.0
    SHA512 0acca1fe1e0d41f919fd721a60dedcba9c88fc490a37012cdda617272caac036a2f1686bbf8cc380b3989cee4e3cfce9fed4ebe3242ef9b7394b944212ba545d
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
