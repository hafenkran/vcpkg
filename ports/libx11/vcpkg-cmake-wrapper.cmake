_find_package(${ARGS})
if(TARGET X11::xcb)
    if(TARGET X11:X11)
        target_link_libraries(X11::X11 INTERFACE X11:xcb)
    endif()
    if(TARGET X11:xdmcp)
        target_link_libraries(X11::xcb INTERFACE X11:xdmcp)
    endif()
    if(TARGET X11:xau)
        target_link_libraries(X11::xcb INTERFACE X11:xau)
    endif()
endif()
