vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO googleapis/google-cloud-cpp
    REF "v${VERSION}"
    SHA512 52cab0e1ee1ebd51097d28b2cd9a390110ce3f45e92d262fb301cfebdea369ea8b9290c44c26d6b6ba568b0dab1e4871ea819f8a440efeefb38c99f2776aac27
    HEAD_REF main
    PATCHES
        support_absl_cxx17.patch
)

if ("grpc-common" IN_LIST FEATURES)
    vcpkg_add_to_path(PREPEND "${CURRENT_HOST_INSTALLED_DIR}/tools/grpc")
endif ()

set(GOOGLE_CLOUD_CPP_ENABLE "${FEATURES}")
list(REMOVE_ITEM GOOGLE_CLOUD_CPP_ENABLE "core")
# This feature does not exist, but allows us to simplify the vcpkg.json
# file.
list(REMOVE_ITEM GOOGLE_CLOUD_CPP_ENABLE "grpc-common")
list(REMOVE_ITEM GOOGLE_CLOUD_CPP_ENABLE "rest-common")
list(REMOVE_ITEM GOOGLE_CLOUD_CPP_ENABLE "googleapis")
# google-cloud-cpp uses dialogflow_cx and dialogflow_es. Underscores
# are invalid in `vcpkg` features, we use dashes (`-`) as a separator
# for the `vcpkg` feature name, and convert it here to something that
# `google-cloud-cpp` would like.
if ("dialogflow-cx" IN_LIST FEATURES)
    list(REMOVE_ITEM GOOGLE_CLOUD_CPP_ENABLE "dialogflow-cx")
    list(APPEND GOOGLE_CLOUD_CPP_ENABLE "dialogflow_cx")
endif ()
if ("dialogflow-es" IN_LIST FEATURES)
    list(REMOVE_ITEM GOOGLE_CLOUD_CPP_ENABLE "dialogflow-es")
    list(APPEND GOOGLE_CLOUD_CPP_ENABLE "dialogflow_es")
endif ()
if ("experimental-storage-grpc" IN_LIST FEATURES)
    list(REMOVE_ITEM GOOGLE_CLOUD_CPP_ENABLE "experimental-storage-grpc")
    list(APPEND GOOGLE_CLOUD_CPP_ENABLE "experimental-storage_grpc")
endif ()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS
        "-DGOOGLE_CLOUD_CPP_ENABLE=${GOOGLE_CLOUD_CPP_ENABLE}"
        -DGOOGLE_CLOUD_CPP_ENABLE_MACOS_OPENSSL_CHECK=OFF
        -DGOOGLE_CLOUD_CPP_ENABLE_WERROR=OFF
        -DGOOGLE_CLOUD_CPP_ENABLE_CCACHE=OFF
        -DGOOGLE_CLOUD_CPP_ENABLE_EXAMPLES=OFF
        -DBUILD_TESTING=OFF
)

vcpkg_cmake_install()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

function (google_cloud_cpp_cmake_config_fixup library)
    string(REPLACE "experimental-" "" library "${library}")
    string(REPLACE "-" "_" library "${library}")
    set(config_path "lib/cmake/google_cloud_cpp_${library}")
    # If the library exists and is installed, tell vcpkg about it.
    if(NOT IS_DIRECTORY "${CURRENT_PACKAGES_DIR}/${config_path}")
        return()
    endif()
    vcpkg_cmake_config_fixup(PACKAGE_NAME "google_cloud_cpp_${library}"
                             CONFIG_PATH "${config_path}"
                             DO_NOT_DELETE_PARENT_CONFIG_PATH)
endfunction ()

foreach(feature IN LISTS GOOGLE_CLOUD_CPP_ENABLE)
    google_cloud_cpp_cmake_config_fixup(${feature})
    google_cloud_cpp_cmake_config_fixup(${feature}_mocks)
endforeach()

# These packages are automatically installed depending on what features are
# enabled.
foreach(feature common compute_protos googleapis grpc_utils iam_v2 logging_type rest_internal rest_protobuf_internal)
    google_cloud_cpp_cmake_config_fixup(${feature})
endforeach()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib/cmake"
                    "${CURRENT_PACKAGES_DIR}/debug/lib/cmake"
                    "${CURRENT_PACKAGES_DIR}/debug/share")
file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

vcpkg_copy_pdbs()
