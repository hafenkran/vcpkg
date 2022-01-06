set(LIBRAW_PREV_MODULE_PATH ${CMAKE_MODULE_PATH})
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})
_find_package(${ARGS})
set(CMAKE_MODULE_PATH ${LIBRAW_PREV_MODULE_PATH})

if (@ENABLE_OPENMP@)
    find_package(OpenMP REQUIRED)
    if (OpenMP_FOUND)
        list(APPEND LibRaw_LIBRARIES gomp)
        list(APPEND LibRaw_r_LIBRARIES gomp)
    endif()
endif()

if (@VCPKG_LIBRARY_LINKAGE@ STREQUAL "static")
    find_package(Jasper REQUIRED)
    if (Jasper_FOUND)
        list(APPEND LibRaw_LIBRARIES ${JASPER_LIBRARIES})
        list(APPEND LibRaw_r_LIBRARIES ${JASPER_LIBRARIES})
    endif ()
    find_package(lcms2 CONFIG REQUIRED)
    if (lcms2_FOUND)
        list(APPEND LibRaw_LIBRARIES lcms2::lcms2)
        list(APPEND LibRaw_r_LIBRARIES lcms2::lcms2)
    endif ()
endif()
