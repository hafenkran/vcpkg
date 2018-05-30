include(vcpkg_common_functions)

if (VCPKG_LIBRARY_LINKAGE STREQUAL static)
    message(STATUS "Warning: Static building will not support load data through plugins.")
    set(VCPKG_LIBRARY_LINKAGE dynamic)
endif()

if(VCPKG_CRT_LINKAGE STREQUAL static)
    message(FATAL_ERROR "osgearth does not support static CRT linkage")
endif()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO gwaldron/osgearth
    REF d06e47995620674900d96eb694ff4866a29a9d4f
    SHA512 d4b790dc2be4b6ffcd3ab5b4c1062bb56dd4503511ea3f4033a2546ce553dbd45535bfb70ba646416acebf67eba2e5d2740a05477387acad87956bf99fc4038a
    HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
)

vcpkg_install_cmake()

#Release
set(OSGEARTH_TOOL_PATH ${CURRENT_PACKAGES_DIR}/tools/osgearth)
set(OSGEARTH_TOOL_PLUGIN_PATH ${OSGEARTH_TOOL_PATH}/osgPlugins-3.5.6)

file(MAKE_DIRECTORY ${OSGEARTH_TOOL_PATH})
file(MAKE_DIRECTORY ${OSGEARTH_TOOL_PLUGIN_PATH})

file(GLOB OSGEARTH_TOOLS ${CURRENT_PACKAGES_DIR}/bin/*.exe)
file(GLOB OSGDB_PLUGINS ${CURRENT_PACKAGES_DIR}/bin/osgdb*.dll)

file(COPY ${OSGEARTH_TOOLS} DESTINATION ${OSGEARTH_TOOL_PATH})
file(COPY ${OSGDB_PLUGINS} DESTINATION ${OSGEARTH_TOOL_PLUGIN_PATH})

file(REMOVE_RECURSE ${OSGEARTH_TOOLS})
file(REMOVE_RECURSE ${OSGDB_PLUGINS})

#Debug
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

set(OSGEARTH_DEBUG_TOOL_PATH ${CURRENT_PACKAGES_DIR}/debug/tools/osgearth)
set(OSGEARTH_DEBUG_TOOL_PLUGIN_PATH ${OSGEARTH_DEBUG_TOOL_PATH}/osgPlugins-3.5.6)

file(MAKE_DIRECTORY ${OSGEARTH_DEBUG_TOOL_PATH})
file(MAKE_DIRECTORY ${OSGEARTH_DEBUG_TOOL_PLUGIN_PATH})

file(GLOB OSGEARTH_DEBUG_TOOLS ${CURRENT_PACKAGES_DIR}/debug/bin/*.exe)
file(GLOB OSGDB_DEBUG_PLUGINS ${CURRENT_PACKAGES_DIR}/debug/bin/osgdb*.dll)

file(COPY ${OSGEARTH_DEBUG_TOOLS} DESTINATION ${OSGEARTH_DEBUG_TOOL_PATH})
file(COPY ${OSGDB_DEBUG_PLUGINS} DESTINATION ${OSGEARTH_DEBUG_TOOL_PLUGIN_PATH})

file(REMOVE_RECURSE ${OSGEARTH_DEBUG_TOOLS})
file(REMOVE_RECURSE ${OSGDB_DEBUG_PLUGINS})


# Handle copyright
file(COPY ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/osgearth)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/osgearth/LICENSE.txt ${CURRENT_PACKAGES_DIR}/share/osgearth/copyright)