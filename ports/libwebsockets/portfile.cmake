include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/libwebsockets-2.0.0)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/warmcat/libwebsockets/archive/v2.0.0.zip"
    FILENAME "libwebsockets-v2.0.0.zip"
    SHA512 bf57a46f2c60095e7e6ec6656b185ffd2cf8f553bc22255ae8f6825d3613316d794f139cdefacbdf60ef997b0cd675fe356813d406c9b7c5a5ae838ce5326042
)
vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_apply_patches(
	SOURCE_PATH ${SOURCE_PATH}
	PATCHES
		${CMAKE_CURRENT_LIST_DIR}/0001-Fix-UWP.patch
)

if(VCPKG_CRT_LINKAGE STREQUAL static)
    set(LWS_MSVC_STATIC_RUNTIME ON)
    set(LWS_MSVC_SHARED_RUNTIME OFF)
else()
    set(LWS_MSVC_STATIC_RUNTIME OFF)
    set(LWS_MSVC_SHARED_RUNTIME ON)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DLWS_WITH_STATIC=${LWS_MSVC_STATIC_RUNTIME}
        -DLWS_WITH_SHARED=${LWS_MSVC_SHARED_RUNTIME}
        -DLWS_USE_BUNDLED_ZLIB=OFF
        -DLWS_WITHOUT_TESTAPPS=ON
        -DLWS_IPV6=ON
        -DLWS_HTTP2=ON
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_install_cmake()

file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/share)
file(RENAME ${CURRENT_PACKAGES_DIR}/cmake ${CURRENT_PACKAGES_DIR}/share/libwebsockets)
file(RENAME
    ${CURRENT_PACKAGES_DIR}/debug/cmake/LibwebsocketsTargets-debug.cmake
    ${CURRENT_PACKAGES_DIR}/share/libwebsockets/LibwebsocketsTargets-debug.cmake
)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/cmake)

file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libwebsockets)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/libwebsockets/LICENSE ${CURRENT_PACKAGES_DIR}/share/libwebsockets/copyright)
vcpkg_copy_pdbs()
