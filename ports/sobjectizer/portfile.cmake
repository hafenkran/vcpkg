vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO stiffstream/sobjectizer
    REF "v.${VERSION}"
    SHA512 274c9e207e373e2b023ea4810b57b1d31e7411c940407e5d5c5bbb876624638fc4326f08e9c589b7216af6ecf74f279029f978782f81ad452046357facbd153e
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" SOBJECTIZER_BUILD_STATIC )
string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" SOBJECTIZER_BUILD_SHARED)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/dev"
    OPTIONS
        -DSOBJECTIZER_BUILD_STATIC=${SOBJECTIZER_BUILD_STATIC}
        -DSOBJECTIZER_BUILD_SHARED=${SOBJECTIZER_BUILD_SHARED}
)

vcpkg_cmake_install()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/sobjectizer)

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

