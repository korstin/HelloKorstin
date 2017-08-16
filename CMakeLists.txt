cmake_minimum_required(VERSION 3.8)
project(CLionPlayground)

configure_file(${CMAKE_SOURCE_DIR}/Shaders/basic.frag ${CMAKE_SOURCE_DIR}/.build/debug COPYONLY)
configure_file(${CMAKE_SOURCE_DIR}/Shaders/basic.vert ${CMAKE_SOURCE_DIR}/.build/debug COPYONLY)

add_custom_target(CLionPlayground ALL
        COMMAND /usr/bin/swift build
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        SOURCES Sources/main.swift)