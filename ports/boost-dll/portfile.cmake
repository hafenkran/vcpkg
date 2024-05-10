# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/dll
    REF boost-${VERSION}
    SHA512 987e6150f06b8b40d00338f72beb34df9356f2b8160a9f383c660434cd7caee28c888d5b9e2081851f30e5f75fbc6c7706db51cadcd734f6d91baf279290bf0d
    HEAD_REF master
)

set(FEATURE_OPTIONS "")
boost_configure_and_install(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
)
