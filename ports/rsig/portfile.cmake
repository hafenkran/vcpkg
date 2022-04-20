vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO rioki/rsig
    REF v0.1.0
    SHA512 73de6dfe0b18f141a388c9307d8dff9a0709ceb758f58c474a7ddc5d9d77f2f8808fe4d78f3ad88466f81ca61b15ae3504255595d78387b23f87974de46d1d2b
    )

file(INSTALL ${SOURCE_PATH}/rsig/rsig.h DESTINATION ${CURRENT_PACKAGES_DIR}/include/rsig)

configure_file(${SOURCE_PATH}/README.md ${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright COPYONLY)
