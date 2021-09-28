# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/winapi
    REF boost-1.77.0
    SHA512 a14aefe991dfb9f4845734990bcd567ef55f431658cabe8fb61a4380e323b5149652b8b2ed53e73215009b4e5672bac51bd5207d073a80d89dcbdaa736315f4e
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
