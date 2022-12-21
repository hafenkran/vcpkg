file(READ "${CMAKE_CURRENT_LIST_DIR}/usage" usage)
message(AUTHOR_WARNING "find_package(skia) is deprecated.\n${usage}")
include(CMakeFindDependencyMacro)
find_dependency(unofficial-skia)
add_library(skia ALIAS unofficial::skia::skia)
add_library(skia::skia ALIAS unofficial::skia::skia)
