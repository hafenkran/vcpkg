#header-only library

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO tetsurom/rxqt
    REF bb2138c835ef96a53bb79c47fb318237564f9a0c
    SHA512 df39f05b0b4fcd950dd39f40b32e20097352a935778af1be077a08644b3562d07dcc77ab658bc45437454372be955a40013570124e86943bb32493c66cdce439
    HEAD_REF master
)

file(INSTALL
	${SOURCE_PATH}/include
    DESTINATION ${CURRENT_PACKAGES_DIR}
)

file(INSTALL
	${SOURCE_PATH}/LICENSE
	DESTINATION ${CURRENT_PACKAGES_DIR}/share/rxqt RENAME copyright)