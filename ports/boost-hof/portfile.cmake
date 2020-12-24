# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/hof
    REF boost-1.75.0
    SHA512 85bc5fa2d479557f5265480d310a8a18885980bb1c516a99d73d445758ddc2132ae3cab7162652fd9091918fa2ac440703837f3c7b81466aa43dfd66898e549c
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
