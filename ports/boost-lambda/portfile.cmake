# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/lambda
    REF boost-1.81.0
    SHA512 6267e7bf435906eecdc5cb94e824d92b98dd57563c13207d1d8edf2d0c5ca929254d98d0e15993b5823bf5f27832b69453532168e334528d95c0380243617616
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
