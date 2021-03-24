cmake_minimum_required(VERSION 3.10.2)
project(map)

set(SOURCE_FILES src/c/map.c src/c/utils.c)
add_library(map SHARED ${SOURCE_FILES})

target_link_libraries(map PRIVATE m)