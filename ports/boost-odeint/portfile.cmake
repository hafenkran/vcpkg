# Automatically generated by scripts/boost/generate-ports.ps1

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO boostorg/odeint
    REF boost-1.78.0
    SHA512 780e08bc8f36e3d6cb3c98dff10ae9c35f84ad468a9358d95238a08475c3091c7ed44d5b76067cc0a6db5ec1c364f3bc43ab58bd120e110353d6f39115022d93
    HEAD_REF master
)

include(${CURRENT_INSTALLED_DIR}/share/boost-vcpkg-helpers/boost-modular-headers.cmake)
boost_modular_headers(SOURCE_PATH ${SOURCE_PATH})
