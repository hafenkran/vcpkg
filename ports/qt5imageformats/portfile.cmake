include(vcpkg_common_functions)

string(LENGTH "${CURRENT_BUILDTREES_DIR}" BUILDTREES_PATH_LENGTH)
if(BUILDTREES_PATH_LENGTH GREATER 37)
    message(WARNING "Qt5's buildsystem uses very long paths and may fail on your system.\n"
        "We recommend moving vcpkg to a short path such as 'C:\\src\\vcpkg' or using the subst command."
    )
endif()

if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    message(FATAL_ERROR "Qt5 doesn't currently support static builds. Please use a dynamic triplet instead.")
endif()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

set(SRCDIR_NAME "qtimageformats-5.9.2")
set(ARCHIVE_NAME "qtimageformats-opensource-src-5.9.2")
set(ARCHIVE_EXTENSION ".tar.xz")

set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/${SRCDIR_NAME})
vcpkg_download_distfile(ARCHIVE_FILE
    URLS "http://download.qt.io/official_releases/qt/5.9/5.9.2/submodules/${ARCHIVE_NAME}${ARCHIVE_EXTENSION}"
    FILENAME ${SRCDIR_NAME}${ARCHIVE_EXTENSION}
    SHA512 5f1b93c0e5fffa4c2c063d14c12ad97114a452b16814ca9ac45f00ec36308a09770b3b4d137cb5d19bd3aa3a6f576724084df5d0dad75236d49868af9243c9d2
)
vcpkg_extract_source_archive(${ARCHIVE_FILE})
if (EXISTS ${CURRENT_BUILDTREES_DIR}/src/${ARCHIVE_NAME})
    file(RENAME ${CURRENT_BUILDTREES_DIR}/src/${ARCHIVE_NAME} ${CURRENT_BUILDTREES_DIR}/src/${SRCDIR_NAME})
endif()

# This fixes issues on machines with default codepages that are not ASCII compatible, such as some CJK encodings
set(ENV{_CL_} "/utf-8")

vcpkg_configure_qmake_debug(
    SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/${SRCDIR_NAME}
)

vcpkg_build_qmake_debug()

vcpkg_configure_qmake_release(
    SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/${SRCDIR_NAME}
)

vcpkg_build_qmake_release()

vcpkg_find_acquire_program(PYTHON3)
get_filename_component(PYTHON3_EXE_PATH ${PYTHON3} DIRECTORY)
set(ENV{PATH} "${PYTHON3_EXE_PATH};$ENV{PATH}")
set(_path "$ENV{PATH}")

set(DEBUG_DIR "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg")
set(RELEASE_DIR "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel")

vcpkg_execute_required_process(
    COMMAND ${PYTHON3} ${CMAKE_CURRENT_LIST_DIR}/fixcmake.py
    WORKING_DIRECTORY ${RELEASE_DIR}/lib/cmake
    LOGNAME fix-cmake
)

set(ENV{PATH} "${_path}")

file(INSTALL ${DEBUG_DIR}/plugins DESTINATION ${CURRENT_PACKAGES_DIR}/debug)
file(INSTALL ${DEBUG_DIR}/mkspecs DESTINATION ${CURRENT_PACKAGES_DIR}/share/qt5/debug)

file(INSTALL ${RELEASE_DIR}/plugins DESTINATION ${CURRENT_PACKAGES_DIR})
file(INSTALL ${RELEASE_DIR}/mkspecs DESTINATION ${CURRENT_PACKAGES_DIR}/share/qt5)

file(INSTALL ${RELEASE_DIR}/lib/cmake DESTINATION ${CURRENT_PACKAGES_DIR}/share)

#Create an empty include file so that vcpkg doesn't complain
file(WRITE ${CURRENT_PACKAGES_DIR}/include/.empty_qt5imageformats "")

file(INSTALL ${SOURCE_PATH}/LICENSE.LGPLv3 DESTINATION ${CURRENT_PACKAGES_DIR}/share/qt5imageformats RENAME copyright)