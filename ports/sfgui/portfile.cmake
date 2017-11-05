include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO TankOs/SFGUI
    REF 0.3.2
    SHA512 cd97e421695f6189995c1b7a4180e3738bf785abae37d3eb51ac6d687a88a26a1f088863b37e065edaff6ba43eea379e423b31118324c4daa65dba0b3e904869
    HEAD_REF master
)

if(VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    set(SFGUI_BUILD_SHARED_LIBS ON)
    set(SFML_STATIC_LIBRARIES OFF)
else()
    set(SFGUI_BUILD_SHARED_LIBS OFF)
    set(SFML_STATIC_LIBRARIES ON)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS 
        -DSFGUI_BUILD_DOC=OFF
        -DSFGUI_BUILD_EXAMPLES=OFF
        -DSFGUI_BUILD_SHARED_LIBS=${SFGUI_BUILD_SHARED_LIBS}
        -DSFML_STATIC_LIBRARIES=${SFML_STATIC_LIBRARIES}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

file(INSTALL ${SOURCE_PATH}/LICENSE.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/sfgui RENAME copyright)

file(RENAME ${CURRENT_PACKAGES_DIR}/cmake/Modules/FindSFGUI.cmake ${CURRENT_PACKAGES_DIR}/share/sfgui/FindSFGUI.cmake)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/cmake/Modules)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/cmake)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/cmake)

file(GLOB_RECURSE SFGUI_DOC_RELEASE ${CURRENT_PACKAGES_DIR}/*.md)
file(GLOB_RECURSE SFGUI_DOC_DEBUG ${CURRENT_PACKAGES_DIR}/debug/*.md)
file(REMOVE ${SFGUI_DOC_RELEASE} ${SFGUI_DOC_DEBUG})
