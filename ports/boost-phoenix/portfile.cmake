# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/phoenix
    REF boost-1.74.0
    SHA512 aecc39aab0b60980dc451fc234996ea75ec02615a85c004b0157d5b7ed3ab77e1d820f04427c5aaeffacebe0c3924ed56faab2599ee00fd60ae8bccab664f7fa
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
