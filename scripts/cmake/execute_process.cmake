#[===[.md:
# execute_process

Intercepts all calls to execute_process() inside portfiles and fails when Download Mode
is enabled.

In order to execute a process in Download Mode call `vcpkg_execute_in_download_mode()` instead.
#]===]

if (NOT DEFINED OVERRIDEN_EXECUTE_PROCESS)
  set(OVERRIDEN_EXECUTE_PROCESS ON)

  if (DEFINED VCPKG_DOWNLOAD_MODE)
    macro(execute_process)
      message(FATAL_ERROR "This command cannot be executed in Download Mode.\nHalting portfile execution.\n")
    endmacro()
  endif()
endif()
