# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/any
    REF boost-1.75.0
    SHA512 426c4c1b47f86e1637514be45ad60ff2df40c91012c275819a2817ec0edd3fa6de107a16fbdc2cdd3d51d50fa76232f6bfc6b80a963e2fc60e94dd464a7994be
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
