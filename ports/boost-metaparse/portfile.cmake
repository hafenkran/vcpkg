# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/metaparse
    REF boost-1.81.0
    SHA512 0e83052cc88ca58228d4bcc6bd0b303eaead883eec9734f103c60bac655035bffc1ee6cc6f68dab93a902241a3db503500a30ff884e4cbd757e5b5ca1d6c5ce7
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
