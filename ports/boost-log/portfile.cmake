# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/log
    REF boost-1.82.0
    SHA512 ae7b1c02eec0eaf922f46e96cd895a03b74c138e1d1388e468adc0ab9bd6702d0756850b8fc039fc4b2838317b1fbccf1e84b2831c439c906d55de7d9bee55aa
    HEAD_REF master
)

file(READ "${SOURCE_PATH}/build/Jamfile.v2" _contents)
string(REPLACE "import ../../config/checks/config" "import ../config/checks/config" _contents "${_contents}")
string(REPLACE " <conditional>@select-arch-specific-sources" "#<conditional>@select-arch-specific-sources" _contents "${_contents}")
file(WRITE "${SOURCE_PATH}/build/Jamfile.v2" "${_contents}")
vcpkg_replace_string("${SOURCE_PATH}/build/log-arch-config.jam"
    "project.load [ path.join [ path.make $(here:D) ] ../../config/checks/architecture ]"
    "project.load [ path.join [ path.make $(here:D) ] ../config/checks/architecture ]"
)
file(COPY "${CURRENT_INSTALLED_DIR}/share/boost-config/checks" DESTINATION "${SOURCE_PATH}/config")
include(${CURRENT_HOST_INSTALLED_DIR}/share/boost-build/boost-modular-build.cmake)
boost_modular_build(SOURCE_PATH ${SOURCE_PATH})
include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
