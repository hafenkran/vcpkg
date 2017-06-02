
include(vcpkg_common_functions)
set(GTK_VERSION 3.22.15)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/gtk+-${GTK_VERSION})
vcpkg_download_distfile(ARCHIVE
    URLS "https://ftp.gnome.org/pub/gnome/sources/gtk+/3.22/gtk+-${GTK_VERSION}.tar.xz"
    FILENAME "gtk+-${GTK_VERSION}.tar.xz"
    SHA512 c99c4a52bc447a21be20546bdc7808081abde076af9603424c1de20af031ac3f9bd121709d4c18705db8ba2f66ace0aae9b32741347788a8d81afa358d67e758)

vcpkg_extract_source_archive(${ARCHIVE})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/cmake DESTINATION ${SOURCE_PATH})

# generate sources using python script installed with glib
if(NOT EXISTS ${SOURCE_PATH}/gtk/gtkdbusgenerated.h OR NOT EXISTS ${SOURCE_PATH}/gtk/gtkdbusgenerated.c)
    vcpkg_find_acquire_program(PYTHON3)
    set(GLIB_TOOL_DIR ${CURRENT_INSTALLED_DIR}/tools/glib)

    vcpkg_execute_required_process(
        COMMAND ${PYTHON3} ${GLIB_TOOL_DIR}/gdbus-codegen --interface-prefix org.Gtk. --c-namespace _Gtk --generate-c-code gtkdbusgenerated ./gtkdbusinterfaces.xml
        WORKING_DIRECTORY ${SOURCE_PATH}/gtk
        LOGNAME source-gen)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DGTK_VERSION=${GTK_VERSION}
    OPTIONS_DEBUG
        -DGTK_SKIP_HEADERS=ON)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/gtk)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/gtk/COPYING ${CURRENT_PACKAGES_DIR}/share/gtk/copyright)
