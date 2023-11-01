file(READ "${CMAKE_CURRENT_LIST_DIR}/usage" usage)
message(WARNING "find_package(libmysql) is deprecated.\n${usage}")
include(CMakeFindDependencyMacro)
find_dependency(unofficial-libmysql CONFIG REQUIRED)
set(libmysql_FOUND 1)
set(MYSQL_LIBRARIES unofficial::libmysql::libmysql)
