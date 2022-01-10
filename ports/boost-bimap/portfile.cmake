# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/bimap
    REF boost-1.78.0
    SHA512 ab681674da7c1d5cf14f93f9832d5f0010661b42dc0fff2299dd7dced026fd0a474633363d070260a57bad0b3e956431c02ab5116e7d990d04bf37cf2f274c8a
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
