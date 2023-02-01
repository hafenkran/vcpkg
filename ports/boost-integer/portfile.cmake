# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/integer
    REF boost-1.81.0
    SHA512 e0307da368ea8d3cab9ba8cfaa833466e3392dc687638636aec22f16d2f56719d56711ec2fe8c0f3b2ee3f91dd47d76ac9907746e5eb3f3799691fcec36e78e2
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
