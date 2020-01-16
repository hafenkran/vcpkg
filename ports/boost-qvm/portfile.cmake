# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/qvm
    REF boost-1.72.0
    SHA512 8609b636d27934c6bc9eb7fc1123a3f231f60055348fbfe542ce6507c29e511364b1ea3b5a21cb2a57576e489f724221663ecdcdf09e0a9e6c739d80d83aaed7
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
