include(vcpkg_common_functions)

if(VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
  message(WARNING "building static")
  set(VCPKG_LIBRARY_LINKAGE static)
endif()

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO ccxvii/mujs
  REF c86267d8b2b5f9a6ae318dc69886109eee0c7b61
  SHA512 927b000cd6a28b785d510917445a5a39a4dbaf0e13eab920cf83c7838b111b8a0542cfab0110f8493dc65b88a48261deb6ba7a871cbe77fb46119b536a69d470
  HEAD_REF master
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

vcpkg_configure_cmake(
  SOURCE_PATH ${SOURCE_PATH}
  PREFER_NINJA
  OPTIONS_DEBUG -DDISABLE_INSTALL_HEADERS=ON -DDISABLE_INSTALL_TOOLS=ON
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/mujs RENAME copyright)
