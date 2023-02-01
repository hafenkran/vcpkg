# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/ublas
    REF boost-1.81.0
    SHA512 9b599b2def2cf75c8d996453036c8b9249f7f1a9256e0755022bc006430c6beec4dd605e862c2323413ad3816abddc53751e24e4691a556ee55b5dc0adde09c3
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
