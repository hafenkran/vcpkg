vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO uNetworking/uWebSockets
    REF 0b97cc72d38c59798c2b69dc6486305a38819694 # v19.0.0a5
    SHA512 3f3dc8aa3a1cce19d9f2734f022dbe6c137920c8506fa8c0c18b303ee50f759428076ac00351d8bd8496b003642ca6d565dceea9e0da922dab936974bc0a1b16
    HEAD_REF master
)

file(COPY ${SOURCE_PATH}/src  DESTINATION ${CURRENT_PACKAGES_DIR}/include)
file(RENAME ${CURRENT_PACKAGES_DIR}/include/src ${CURRENT_PACKAGES_DIR}/include/uwebsockets/)

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
