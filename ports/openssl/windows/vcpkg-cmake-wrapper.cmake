_find_package(${ARGS})
if(OPENSSL_FOUND)
    list(APPEND OPENSSL_LIBRARIES Crypt32.lib ws2_32.lib)
    if(TARGET OpenSSL::Crypto)
        set_property(TARGET OpenSSL::Crypto APPEND PROPERTY INTERFACE_LINK_LIBRARIES "Crypt32.lib;ws2_32.lib")
    endif()
    if(TARGET OpenSSL::SSL)
        set_property(TARGET OpenSSL::SSL APPEND PROPERTY INTERFACE_LINK_LIBRARIES "Crypt32.lib;ws2_32.lib")
    endif()
endif()
