# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/config
    REF boost-1.72.0
    SHA512 918f8936ced087ab89b32648fdf7194e025043c799f7750623e387a0c5d4f17581614cb8318cac07c5b70ed0e5f14ab94eb69999870cf2cada7ef3bf2503dd40
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
file(APPEND ${CURRENT_PACKAGES_DIR}/include/boost/config/user.hpp "\n#ifndef BOOST_ALL_NO_LIB\n#define BOOST_ALL_NO_LIB\n#endif\n")
file(APPEND ${CURRENT_PACKAGES_DIR}/include/boost/config/user.hpp "\n#undef BOOST_ALL_DYN_LINK\n")

if (VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    file(APPEND ${CURRENT_PACKAGES_DIR}/include/boost/config/user.hpp "\n#define BOOST_ALL_DYN_LINK\n")
endif()
file(COPY ${SOURCE_PATH}/checks DESTINATION ${CURRENT_PACKAGES_DIR}/share/boost-config)
