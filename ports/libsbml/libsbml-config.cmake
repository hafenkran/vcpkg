include(CMakeFindDependencyMacro)
find_dependency(@name@ CONFIG)
if(NOT TARGET libsbml)
    add_library(libsbml INTERFACE IMPORTED)
    target_link_libraries(libsbml INTERFACE $<TARGET_NAME:@name@>)
endif()
