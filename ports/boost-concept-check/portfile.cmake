# Automatically generated by boost-vcpkg-helpers/generate-ports.ps1

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/concept_check
    REF boost-1.72.0
    SHA512 8b3ebefa86eab167205a616dbde25fabf850c859b562f71b67b5ddabb15de6020a60440c3191e664bad3058f97476674467d4651e9fcd5412452bcc29a269e7e
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
