# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/variant2
    REF boost-1.77.0
    SHA512 0f4741e29288b2856eaa09c33557117faab71900b50e12f76bc89fea711cf1319ebff4aa9b3efd4012e510192e22c006bf1179c37798b386c7cecc955819dd96
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
