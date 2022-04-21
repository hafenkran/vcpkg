# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/logic
    REF boost-1.79.0
    SHA512 9b3689d4b08cc0edc69aa9f2ea2f182e94d734a407b030b9b41ebaccae20055fae8f8662324abfa1b8217bf10edbc996b6e218df9f9a4bb9dc8952460b5f3cef
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
