# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/yap
    REF boost-${VERSION}
    SHA512 5ed8930d8764eab2edcefd9627315dc812ff80eda8e2982f0c2fcb89ff828e13f4998fa852e57578116863da09b0cf8ca83afea9aa18b6ee2c4852277b14afce
    HEAD_REF master
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)
