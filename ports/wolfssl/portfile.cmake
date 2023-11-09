vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO wolfssl/wolfssl
    REF v5.6.4-stable
    SHA512 12d9dd264e005f04854d71ded629b20b9563a42b04bfbfd2879c4e3b121902edf2ac4349de27498cddd75d4d9fd742e8f78b82cd319c240485f69b4828e2c80c
    HEAD_REF master
    PATCHES
    )

if ("dtls" IN_LIST FEATURES)
    set(ENABLE_DTLS yes)
else()
    set(ENABLE_DTLS no)
endif()

vcpkg_cmake_get_vars(cmake_vars_file)
include("${cmake_vars_file}")

foreach(config RELEASE DEBUG)
  string(APPEND VCPKG_COMBINED_C_FLAGS_${config} " -DWOLFSSL_ALT_CERT_CHAINS -DWOLFSSL_DES_ECB -DWOLFSSL_CUSTOM_OID -DHAVE_OID_ENCODING -DWOLFSSL_CERT_GEN -DWOLFSSL_ASN_TEMPLATE -DWOLFSSL_KEY_GEN -DHAVE_PKCS7 -DHAVE_AES_KEYWRAP -DWOLFSSL_AES_DIRECT -DHAVE_X963_KDF")
  if ("secret-callback" IN_LIST FEATURES)
      string(APPEND VCPKG_COMBINED_C_FLAGS_${config} " -DHAVE_SECRET_CALLBACK")
  endif()
endforeach()

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
      -DWOLFSSL_BUILD_OUT_OF_TREE=yes
      -DWOLFSSL_EXAMPLES=no
      -DWOLFSSL_CRYPT_TESTS=no
      -DWOLFSSL_OPENSSLEXTRA=yes
      -DWOLFSSL_TPM=yes
      -DWOLFSSL_TLSX=yes
      -DWOLFSSL_OCSP=yes
      -DWOLFSSL_OCSPSTAPLING=yes
      -DWOLFSSL_OCSPSTAPLING_V2=yes
      -DWOLFSSL_CRL=yes
      -DWOLFSSL_DES3=yes
      -DWOLFSSL_DTLS=${ENABLE_DTLS}
      -DWOLFSSL_DTLS13=${ENABLE_DTLS}
      -DWOLFSSL_DTLS_CID=${ENABLE_DTLS}
    OPTIONS_RELEASE
      -DCMAKE_C_FLAGS=${VCPKG_COMBINED_C_FLAGS_RELEASE}
    OPTIONS_DEBUG
      -DCMAKE_C_FLAGS=${VCPKG_COMBINED_C_FLAGS_DEBUG}
      -DWOLFSSL_DEBUG=yes)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/wolfssl)
vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
