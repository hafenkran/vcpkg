if(WIN32 AND NOT MINGW)
    find_package(unofficial-getopt-win32 REQUIRED)
    set(getopt_lib-static unofficial::getopt-win32::getopt)
    set(MGL_HAVE_GETOPT 1 CACHE INTERNAL "From vcpkg")
endif()
