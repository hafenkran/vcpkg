# This portfile adds the Qt Cryptographic Arcitecture
# Changes to the original build:
#   No -qt5 suffix, which is recommended just for Linux
#   Output directories according to vcpkg
#   Updated certstore. See certstore.pem in the output dirs
#
vcpkg_find_acquire_program(PERL)
get_filename_component(PERL_EXE_PATH ${PERL} DIRECTORY)
vcpkg_add_to_path("${PERL_EXE_PATH}")

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDE/qca
    REF v2.3.5
    SHA512 c83ac69597f22d915479fd4fd1557b89c56ba384321c324f93cf2f1bd32a819cb6d7b008c44e7606fa39c8184043d97c36ee1210d23a6e8ce24c41c8a83e4fb9
    PATCHES
        0001-fix-path-for-vcpkg.patch
        0002-fix-build-error.patch
        0003-Define-NOMINMAX-for-botan-plugin-with-MSVC.patch
)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
  set(QCA_FEATURE_INSTALL_DIR_DEBUG ${CURRENT_PACKAGES_DIR}/debug/bin/Qca)
  set(QCA_FEATURE_INSTALL_DIR_RELEASE ${CURRENT_PACKAGES_DIR}/bin/Qca)
else()
  set(QCA_FEATURE_INSTALL_DIR_DEBUG ${CURRENT_PACKAGES_DIR}/debug/lib/Qca)
  set(QCA_FEATURE_INSTALL_DIR_RELEASE ${CURRENT_PACKAGES_DIR}/lib/Qca)
endif()

# According to:
#   https://www.openssl.org/docs/faq.html#USER16
# it is up to developers or admins to maintain CAs.
# So we do it here:
message(STATUS "Importing certstore")
file(REMOVE "${SOURCE_PATH}/certs/rootcerts.pem")
# Using file(DOWNLOAD) to use https
file(DOWNLOAD https://raw.githubusercontent.com/mozilla/gecko-dev/master/security/nss/lib/ckfw/builtins/certdata.txt
    "${CURRENT_BUILDTREES_DIR}/cert/certdata.txt"
    TLS_VERIFY ON
)
vcpkg_execute_required_process(
    COMMAND "${PERL}" "${CMAKE_CURRENT_LIST_DIR}/mk-ca-bundle.pl" -n "${SOURCE_PATH}/certs/rootcerts.pem"
    WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}/cert"
    LOGNAME ca-bundle
)
message(STATUS "Importing certstore done")

set(PLUGINS gnupg logger softstore wincrypto)
if("botan" IN_LIST FEATURES)
    list(APPEND PLUGINS botan)
endif()

# Configure and build
vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DUSE_RELATIVE_PATHS=ON
        "-DBUILD_PLUGINS=${PLUGINS}"
        -DBUILD_TESTS=OFF
        -DBUILD_TOOLS=OFF
        -DBUILD_WITH_QT6=ON
        -DQCA_SUFFIX=OFF
        -DQCA_FEATURE_INSTALL_DIR=share/qca/mkspecs/features
        -DOSX_FRAMEWORK=OFF
    OPTIONS_DEBUG
        -DQCA_PLUGINS_INSTALL_DIR=${QCA_FEATURE_INSTALL_DIR_DEBUG}
    OPTIONS_RELEASE
        -DQCA_PLUGINS_INSTALL_DIR=${QCA_FEATURE_INSTALL_DIR_RELEASE}
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(CONFIG_PATH share/qca/cmake)
file(READ "${CURRENT_PACKAGES_DIR}/share/${PORT}/QcaConfig.cmake" QCA_CONFIG_FILE)
string(REGEX REPLACE "PACKAGE_PREFIX_DIR \"(.*)\" ABSOLUTE"
                     [[PACKAGE_PREFIX_DIR "${CMAKE_CURRENT_LIST_DIR}/../../" ABSOLUTE]]
       QCA_CONFIG_FILE "${QCA_CONFIG_FILE}"
)
file(WRITE "${CURRENT_PACKAGES_DIR}/share/${PORT}/QcaConfig.cmake" "${QCA_CONFIG_FILE}")

# Remove unneeded dirs
file(REMOVE_RECURSE 
    "${CURRENT_BUILDTREES_DIR}/share/man"
    "${CURRENT_PACKAGES_DIR}/share/man"
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

vcpkg_fixup_pkgconfig()

# Handle copyright
file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
