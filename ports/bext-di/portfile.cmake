vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boost-ext/di
    REF 6078f073feb8560127fbf0308b3794a551146252 # v1.2.0
    SHA512 d7876b10b0365a92095ee7edefdc9cb9a0e237baf2bad124a927f22ed6ec30e18802b20517bc032184f39b7b4d71f44e965bdcea074646871d0194bd4e851d43
    HEAD_REF cpp14
)

file(INSTALL ${SOURCE_PATH}/include/boost
    DESTINATION ${CURRENT_PACKAGES_DIR}/include)

vcpkg_download_distfile(LICENSE
    URLS https://www.boost.org/LICENSE_1_0.txt
    FILENAME "di-copyright"
    SHA512 d6078467835dba8932314c1c1e945569a64b065474d7aced27c9a7acc391d52e9f234138ed9f1aa9cd576f25f12f557e0b733c14891d42c16ecdc4a7bd4d60b8
)
file(INSTALL ${LICENSE} DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
