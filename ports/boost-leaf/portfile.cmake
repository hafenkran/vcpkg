# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/leaf
    REF boost-1.78.0
    SHA512 07f15896fe8dd1029aefe2988c82b688243b11f344fafe7ad80a93e70e75c7b35083d1a84944bc564aa591a086f20dfcb4010fc701b1e6780f93ac2dd5701c6b
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
