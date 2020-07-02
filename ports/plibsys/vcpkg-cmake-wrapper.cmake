include(FindPackageHandleStandardArgs)
include(SelectLibraryConfigurations)

find_path(PLIBSYS_INCLUDE_DIR NAMES plibsys.h HINTS ${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET} PATH_SUFFIXES plibsys)

find_library(PLIBSYS_LIBRARY_DEBUG NAMES plibsys plibsysstatic libplibsys NAMES_PER_DIR PATH_SUFFIXES lib PATHS "${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/debug" NO_DEFAULT_PATH REQUIRED)
find_library(PLIBSYS_LIBRARY_RELEASE NAMES plibsys plibsysstatic libplibsys NAMES_PER_DIR PATH_SUFFIXES lib PATHS "${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}" NO_DEFAULT_PATH REQUIRED)

select_library_configurations(PLIBSYS)

set(PLIBSYS_INCLUDE_DIRS ${PLIBSYS_INCLUDE_DIR})
set(PLIBSYS_LIBRARIES ${PLIBSYS_LIBRARY})
