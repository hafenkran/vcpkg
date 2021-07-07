# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/log
    REF boost-1.76.0
    SHA512 9d29404852d9e79241bd745757960563e11c854887d2aa2fad5a0306f7c327351a70f526ebb8e9c603c79c6979678ca220071e6a62e0148a2bd51f30af952f07
    HEAD_REF master
)

file(READ "${SOURCE_PATH}/build/Jamfile.v2" _contents)
string(REPLACE "import ../../config/checks/config" "import config/checks/config" _contents "${_contents}")
string(REPLACE " <conditional>@select-arch-specific-sources" "#<conditional>@select-arch-specific-sources" _contents "${_contents}")
file(WRITE "${SOURCE_PATH}/build/Jamfile.v2" "${_contents}")
file(COPY "${CURRENT_INSTALLED_DIR}/share/boost-config/checks" DESTINATION "${SOURCE_PATH}/build/config")

file(READ ${SOURCE_PATH}/build/log-arch-config.jam _contents)
string(REPLACE
    "project.load [ path.join [ path.make $(here:D) ] ../../config/checks/architecture ]"
    "project.load [ path.join [ path.make $(here:D) ] config/checks/architecture ]"
    _contents "${_contents}")
file(WRITE ${SOURCE_PATH}/build/log-arch-config.jam "${_contents}")

if(NOT DEFINED CURRENT_HOST_INSTALLED_DIR)
    message(FATAL_ERROR "boost-log requires a newer version of vcpkg in order to build.")
endif()
include(${CURRENT_HOST_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)
boost_modular_build(SOURCE_PATH ${SOURCE_PATH})
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
