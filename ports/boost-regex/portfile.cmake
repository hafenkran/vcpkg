# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/regex
    REF boost-1.71.0
    SHA512 909082d18575a8e6cc8d52cfe38eb661d6cd38f6e2d9c8504af09af53e09ca744a5df850cb8dff96c95c2b17672b7796b938fee4353dc1e878749c1fe827cfe1
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
