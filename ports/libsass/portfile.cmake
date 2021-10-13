vcpkg_fail_port_install(ON_TARGET "uwp")

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO sass/libsass
    REF 3.6.5
    SHA512 98CC7E12FDF74CD9E92D8D4A62B821956D3AD186FCEE9A8D77B677A621342AA161B73D9ADAD4C1849678A3BAC890443120CC8FEBE1B7429AAB374321D635B8F7
    HEAD_REF master
    PATCHES remove_compiler_flags.patch
)

vcpkg_configure_make(
    SOURCE_PATH "${SOURCE_PATH}"
    AUTOCONFIG
)
vcpkg_install_make(MAKEFILE GNUmakefile)
vcpkg_fixup_pkgconfig()
vcpkg_copy_pdbs()

file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
