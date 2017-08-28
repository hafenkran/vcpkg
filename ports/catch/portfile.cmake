include(vcpkg_common_functions)

set(CATCH_VERSION v1.10.0)

vcpkg_download_distfile(HEADER
    URLS "https://github.com/philsquared/Catch/releases/download/${CATCH_VERSION}/catch.hpp"
    FILENAME "catch-${CATCH_VERSION}.hpp"
    SHA512 275ab5b5d778cc8a91b5f3e8f241a37b680c81d1b8945ff64ad16a9708c98e6535b389746bf8cacbed07f874629f456b56bafbf1879c5a6f84fa87675c1361b6
)

vcpkg_download_distfile(LICENSE
    URLS "https://raw.githubusercontent.com/philsquared/Catch/${CATCH_VERSION}/LICENSE.txt"
    FILENAME "catch-LICENSE-${CATCH_VERSION}.txt"
    SHA512 f1a8d21ccbb6436d289ecfae65b9019278e40552a2383aaf6c1dfed98affe6e7bbf364d67597a131642b62446a0c40495e66a7efca7e6dff72727c6fd3776407
)

file(INSTALL ${HEADER} DESTINATION ${CURRENT_PACKAGES_DIR}/include RENAME catch.hpp)
file(INSTALL ${LICENSE} DESTINATION ${CURRENT_PACKAGES_DIR}/share/catch RENAME copyright)
