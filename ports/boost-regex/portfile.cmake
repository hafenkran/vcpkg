# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/regex
    REF boost-1.66.0
    SHA512 def00fc4876fd83a2581eea15228940a665cb79eff26e979079b5df568952f144b74da2f41ddffe6792784fe3fceca94d7b0f49d1a7f01a4df78948244fe86b1
    HEAD_REF master
)

if("icu" IN_LIST FEATURES)
    set(REQUIREMENTS "<library>/user-config//icuuc <library>/user-config//icudt <library>/user-config//icuin <define>BOOST_HAS_ICU=1")
else()
    set(REQUIREMENTS)
endif()

include(${CURRENT_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)
boost_modular_build(SOURCE_PATH ${SOURCE_PATH} REQUIREMENTS "${REQUIREMENTS}")
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
