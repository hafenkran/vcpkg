include(vcpkg_common_functions)

include(${CURRENT_INSTALLED_DIR}/share/qt5modularscripts/qt_modular_library.cmake)

qt_modular_library(qttools d37c0e11a26a21aa60f29f3b17ddc9895385d848692956e4481e49003cbe9c227daf8fda1c40a2ab70ac8e7e56d3771c1b2964524589eb77ac1f2362c269162e)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/tools/qt5-tools/plugins/platforminputcontexts)