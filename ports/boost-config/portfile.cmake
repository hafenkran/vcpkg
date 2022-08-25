# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/config
    REF boost-1.80.0
    SHA512 1c2a87548e2401fcd3a5ae3ab17b0f4f930b6c5ae1f1820aeb5274132ae2c3ae52b5226b9a9b1c46c8a48aee2e6014e1f4dcfe251d5bdf367681b3ed4d933a90
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
