# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/odeint
    REF boost-1.75.0
    SHA512 972afd04ca564aa1ac8d803d36b07ccf8fac7f3931e7c916c7459435313de13d511508793364d67e0aa19a79ba91c50ce4dc774ae2702142afdcb4b08de192e9
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
