set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)
if(VCPKG_TARGET_IS_WINDOWS)
    set(VCPKG_POLICY_EMPTY_PACKAGE enabled)
    message(STATUS "${PORT} will not build any artifacts on Windows!")
endif()
include(${CURRENT_INSTALLED_DIR}/share/qt5/qt_port_functions.cmake)
qt_submodule_installation()