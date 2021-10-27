vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO muflihun/easyloggingpp
    REF v9.97.0
    SHA512 E45789EDAF7A43AD6A73861840D24CCCE9B9D6BBA1AAACF93C6AC26FF7449957251D2CA322C9DA85130B893332DD305B13A2499EAFFC65ECFAAAFA3E11F8D63D
    HEAD_REF master
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -Dbuild_static_lib=ON
)
vcpkg_cmake_install()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/easyloggingpp" RENAME copyright)


vcpkg_fixup_pkgconfig()
