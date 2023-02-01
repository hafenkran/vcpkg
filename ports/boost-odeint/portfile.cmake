# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/odeint
    REF boost-1.81.0
    SHA512 649274e1047db48810b495487772768d59187a243ee5e127721dbb57f2f71b6ae38de32b3dcd1020dac588081389e068c15cd76dd6965b9229bf08c62e023e64
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
