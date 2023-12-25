cmake_minimum_required(VERSION 3.16)

project(discord-social
    VERSION 1.0
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 20)

set(CMAKE_SKIP_BUILD_RPATH FALSE)
set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)

set(CMAKE_INSTALL_RPATH "$ORIGIN")
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

if(MSVC)
else()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Werror")
endif()

add_library(${PROJECT_NAME} SHARED
    src/plugin.cpp
    src/discord_sdk/achievement_manager.cpp
    src/discord_sdk/activity_manager.cpp
    src/discord_sdk/application_manager.cpp
    src/discord_sdk/core.cpp
    src/discord_sdk/image_manager.cpp
    src/discord_sdk/lobby_manager.cpp
    src/discord_sdk/network_manager.cpp
    src/discord_sdk/overlay_manager.cpp
    src/discord_sdk/relationship_manager.cpp
    src/discord_sdk/storage_manager.cpp
    src/discord_sdk/store_manager.cpp
    src/discord_sdk/types.cpp
    src/discord_sdk/user_manager.cpp
    src/discord_sdk/voice_manager.cpp
)

target_link_libraries(${PROJECT_NAME} PRIVATE discord_game_sdk)
install(TARGETS ${PROJECT_NAME} DESTINATION lib)

if(WIN32)
    if ("$ENV{Platform}" STREQUAL "arm64")
        message(FATAL_ERROR "Windows ARM64 is (currently) not supported by the Steamworks SDK")
    else()
        target_sources(${PROJECT_NAME} PRIVATE os/windows/library.manifest)

        if(CMAKE_SIZEOF_VOID_P EQUAL 8)
            target_link_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/lib/x86_64)
            install(FILES lib/x86_64/discord_game_sdk.dll DESTINATION lib)
        else()
            target_link_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/lib/x86)
            install(FILES lib/x86/discord_game_sdk.dll DESTINATION lib)
        endif()
    endif()
elseif(APPLE)
    if (CMAKE_OSX_ARCHITECTURES STREQUAL "arm64")
        target_link_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/lib/aarch64)
        install(FILES lib/osx/libdiscord_game_sdk.dylib RENAME discord_game_sdk.dylib DESTINATION lib)
    else()
        target_link_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/lib/x86_64)
        install(FILES lib/osx/libdiscord_game_sdk.dylib RENAME discord_game_sdk.dylib DESTINATION lib)
    endif()
else()
    target_link_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/lib/x86_64)
    install(FILES lib/x86_64/libdiscord_game_sdk.so DESTINATION lib)
endif()
