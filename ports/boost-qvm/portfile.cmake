# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/qvm
    REF boost-1.81.0
    SHA512 6836aee23678bc4d634bb6cfd3cce800a7f794eaef18e43040019f33980769652e531b29a844e2ffe669cdd14eec526810624a2f2ebd9466aef66b905d1de5a7
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
