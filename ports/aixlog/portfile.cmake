include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO badaix/aixlog
    REF c268f271ef7e7181389205e985740f29e6744a8c # v1.4.0
    SHA512 7014d22a0bdbaf85191d18652531af6e0c8ff6d8041bf92a80d51994cfbdf0d9d63c4f8836b9bba16d1895ffa03ad0749a42bd11706eb5f3cde1dcbe76746c24
    )
    
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/include)
file(COPY ${SOURCE_PATH}/include/ DESTINATION ${CURRENT_PACKAGES_DIR}/include)

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

# Post-build test for cmake libraries
# vcpkg_test_cmake(PACKAGE_NAME aixlog)
