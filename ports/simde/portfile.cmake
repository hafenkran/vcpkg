# header-only library

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO nemequ/simde
    REF v0.7.2
    SHA512 E4EE5A4A7E8453F116F1325D147F91D358A300F41EA5566EA30FC19649BABABF3B87E3DC838D5608B578BD152207DF4156200FFC7FB98141BC7C0BB60C75F1F5
    HEAD_REF master
    PATCHES
        fix-windows-minmax.patch
)

file(COPY "${SOURCE_PATH}/simde" DESTINATION "${CURRENT_PACKAGES_DIR}/include")

file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
