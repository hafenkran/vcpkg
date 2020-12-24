# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/type_index
    REF boost-1.75.0
    SHA512 f76b38f82ea2ba8508715122c6b899034a57e206ac01a4560220df03c185885a6b50f56559f070ae873addccd8b05df2dc1f35dffeee36e8384e8de2f6f5e220
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
