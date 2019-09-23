#Every update requires an update of these hashes and the version within the control file of each of the 32 ports. 
#So it is probably better to have a central location for these hashes and let the ports update via a script
set(QT_MAJOR_MINOR_VER 5.13)
set(QT_PATCH_VER 1)
set(QT_UPDATE_VERSION 0) # Switch to update qt and not build qt. Creates a file cmake/qt_new_hashes.cmake in qt5-base with the new hashes.

set(QT_PORT_LIST base 3d activeqt charts connectivity datavis3d declarative gamepad graphicaleffects imageformats location macextras mqtt multimedia networkauth
                 purchasing quickcontrols quickcontrols2 remoteobjects script scxml sensors serialport speech svg tools virtualkeyboard webchannel websockets
                 webview winextras xmlpatterns)

set(QT_HASH_qt5-base                86ab39eabb8867c4b038614341b7e49136f4ef898f06d4f1c899ddd2c2c271aa630bf63ad6abcf5c1f01659e6e5005f5da7dd83bb09a1484e15eb47e5274b9b3)
set(QT_HASH_qt5-3d                  dc305162ff87a71736b98aeb710b338ad1c6084819a79073f92b086ecc641caa7798d1c2bea20dd9eb91a9caf853177f01404d19407f8d10cb2bb8198d75cb84)
set(QT_HASH_qt5-activeqt            cc0f9e92957142bbf44734560271e64cc8c3c5c337a8e180e68fd02a8cb7db8d6f8b86431e7c8abf62405a3fc8cef9922b111031310472495d7a75faa320940c)
set(QT_HASH_qt5-charts              c511d5b48f53312f0e7380d2d04019a5e500736a47bf4625f668042152026c1d5dc3299dd82243054119697063daa445329c78793e2107b01e84824968258d34)
set(QT_HASH_qt5-connectivity        de66b7d828f1259f59dac693ffd4bff15313e33b591ab748ca63a6470f1b3975bd30f48f75833400554cdbd8bb2f2a844b980b3db4242f08f43b82a2eb08c763)
set(QT_HASH_qt5-datavis3d           f7ee9973dd7773f52726307de057cfd1a15227b390050bf8eca5294e151726a91152c89c36f7c38039b53564fec191ac3ea630231cd8391ca98ce99621b5ad3d)
set(QT_HASH_qt5-declarative         08cae55ffc51211cdaff0e4092284aa1d8305a08757ce214a54a362df66577ea6efdcf0b3aaae40f70862138369f8ec6b2eabfc55f99d67b5b3538f4e0e1eb21)
set(QT_HASH_qt5-gamepad             0e4e7c307157a09ddb735656306ade50423bbafad03d2cbf322c007d4017a8cb5d2389429f2b487c6e99918c688fd85d732a326be0034c2938ece73ff5015428)
set(QT_HASH_qt5-graphicaleffects    b929ebd56821b2350472a37bc08c84e62c2010b740b3e9b00a8883e131cd585122dc50bfe5815c714c2eab1b4d8bbc458f6659bf02929a42de458f0a3b72f4fe)
set(QT_HASH_qt5-imageformats        8a7ac126e7f88525ce490a13656608cee53db232f4af8a90783a2a2e8540fc0bfeed641d33cf41d3643e46439850f95da701b0d5215872e0882c38209da10144)
set(QT_HASH_qt5-location            661ceff9ebb757e58e9430e0af86e782445029d42da61769264d5706c6633e42bf064c0afdb657e01dd2e3d9edd73e02dbadac2e65820038bbbcc3990a8e35aa)
set(QT_HASH_qt5-macextras           d27ab2b44cfcb1a4d02cd6d2403710546c8cc1bae834418975f7588bf647c822519c4701b4feaa5bca98e5ad089eb2dd9f328956339699274126422324e042fc)
set(QT_HASH_qt5-mqtt                8aef8c8e6b7ef6acba864583396b680321c26b1f4910925e182592482d9363127c0767663cfd815262bdb4c32795c7b3e706c8543c7838e6907abca6d76eb9fd)
set(QT_HASH_qt5-multimedia          4599da3fc627923ce1fae3739124cb609591097870ee873e386429b81ac6a3f5a6e3a8d1316a84fcef8a25de4b7301b1358d2f5da9d87b0c2e18ac1f34184d30)
set(QT_HASH_qt5-networkauth         8a949006a7d2adc1bd7a55d80f93a622b0cc8e4ef644884b430c7ca4b82a2fc8b34b5e28492c175fe1b13da615a0ce66e6d80f58de4290d8515897bc521e80fc)
set(QT_HASH_qt5-purchasing          bdbe386562bd3203c83f61385fb23f4493c8e9f68cd05d64929598192ac80788a214e6a4bb96ea3f19f061b6a689237acf6752bc1012e4263127f1801cb3eef3)
set(QT_HASH_qt5-quickcontrols       f1204d709495197d6f664b7c7cb522be67a891985e4380b009bbd5e0b9854a603aa69f9b84c2189c6f35988ec3ffd7a6032c3ee097c449b40646ec66698b4689)
set(QT_HASH_qt5-quickcontrols2      5325d06a906934d00c6a7eb4e82d9399bc9764366a1374dd2c3c83828e9152d5d646b746437a6128e306157e3a457341747773bf3aa54809346e598687d2aacd)
set(QT_HASH_qt5-remoteobjects       087fd4f9f2f1e11796cce6d09f9adccd620ae664505c0475dab01c67b4afb699d93f788abf2e993961338424f0c9a87784148120221cbbf38febf5ec87012a1d)
set(QT_HASH_qt5-script              31b2088432ae70c7d19be61cfcd5dd5bace7fc33f6882a7d489982c392ab39bdc2bca612e8403c6d30ca7cb41622a93514ad87066998378cdda8bc2ba3a42536)
set(QT_HASH_qt5-scxml               8447f624578a92eee89c9f70cc4a44943cf9d015c06b20b83a90a6344a4ca7fa88e21121b9a98237140b1b59ab74be806ce6319c7b8b54c0aa2d3945af802e35)
set(QT_HASH_qt5-sensors             7a28b57ebadae6f2fc94778f7bf5321464f182ec8c32437c3803ddbbf2dd3ac24e90a6dbefc5634be53e4fb64c82aa7bbb67fa302d58a538493a14a78cf8c798)
set(QT_HASH_qt5-serialport          2465c4e723966d8c365230667b8f441a85e2a46b76e7070fe4b024015add376631c9016efe177364735ba41f34f21eeff6726a6511cee5b1d82b267ee6a58900)
set(QT_HASH_qt5-speech              662fa345c1207143a0bf641455ed4109eb028bd376b9a1bec757747912da169dde84f26f1e47562ee8973d847cac8f258cf771b428af486e19edb5bd3ef7dcc0)
set(QT_HASH_qt5-svg                 76cfb880491bfa8295e5f7abfe842479516d355903ba620ff9bb42dd98ecafa3ef234f52ddd311ea9591b8e500e181c4849c6a0814fc0a1943c18d4697cd1f09)
set(QT_HASH_qt5-tools               b3bd614ed21a1b37829082f2ec89b086b4c8e7cc91be5ba7bef16dc52619e3357d2c9165c3a1eedbd1f1913d215cda3f9a59fc26d45ee0267bc1e3d7205d98b8)
set(QT_HASH_qt5-virtualkeyboard     93840660675717bcce9237df5b6222306ad4b260a83bdae45110e3770acddcbf702e10d505ca0b2c71c24fb6c1742640c8bd56015331b219e8af9e7b9c793d24)
set(QT_HASH_qt5-webchannel          4c0509bf80070ce09c0317e4e4faaa47cc87218e2e78036a3424a6e22c0b4a6175fc86f46103e90b876c73e5a2f7492a9eaaf8777885351fae0b036cc7fb629c)
set(QT_HASH_qt5-websockets          a951f355c3ce8f56fc5c4252e050ef008f4b3f9825a194a3e2e61a5e8ea9a3b89c6d9965acf9360be4655142b2057b4e7fb7a5b41412c3e14bef7846307670fb)
set(QT_HASH_qt5-webview             4933a9a637eb4ca3790310f2921dcbaa44dd7363eb4226f522c6d38a8ada5dfdaf87a8b33390740524ff05056397c530426e3969f798a7c75f2f663c099192b8)
set(QT_HASH_qt5-winextras           279514fc482a6e64a28970af2c69f9bd3db1e4e1ec9bf92be7d6ec47bdbea272149a4353ba0807da03ed8d0ee916f1d7f6efdc86bdb9173227055e0a44ac0155)
set(QT_HASH_qt5-xmlpatterns         6b426e5af2f1f71b77c5cb2bba79a9dc8223c7d57192be445df0d2fe9066f07632ad5ee799b3a782bc582446057197b55fa0260d1ea525db8b3a9a3912081169)

if(QT_UPDATE_VERSION)
    message(STATUS "Running Qt in automatic version port update mode!")
    set(_VCPKG_INTERNAL_NO_HASH_CHECK 1)
    if("${PORT}" MATCHES "qt5-base")
        foreach(_current_qt_port ${QT_PORT_LIST})
            set(_current_control "${VCPKG_ROOT_DIR}/ports/qt5-${_current_qt_port}/CONTROL")
            file(READ ${_current_control} _control_contents)
            #message(STATUS "Before: \n${_control_contents}")
            string(REGEX REPLACE "Version:[^0-9]+[0-9]\.[0-9]+\.[0-9]+[^\n]*\n" "Version: ${QT_MAJOR_MINOR_VER}.${QT_PATCH_VER}\n" _control_contents "${_control_contents}")
            #message(STATUS "After: \n${_control_contents}")
            file(WRITE ${_current_control} "${_control_contents}")
        endforeach()
    endif()
endif()