cmake_minimum_required(VERSION 3.14)
project(hyprspace_native VERSION 1.0.0 LANGUAGES C)

# Build the Go shared library as part of the CMake build.
find_program(GO_EXECUTABLE go REQUIRED)

set(GO_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../go")
set(OUTPUT_LIB "${CMAKE_CURRENT_BINARY_DIR}/libhyprspace.so")
set(OUTPUT_HEADER "${CMAKE_CURRENT_BINARY_DIR}/hyprspace_bridge.h")

add_custom_command(
  OUTPUT "${OUTPUT_LIB}" "${OUTPUT_HEADER}"
  COMMAND ${CMAKE_COMMAND} -E env
    CGO_ENABLED=1
    GOOS=linux
    ${GO_EXECUTABLE} build
      -buildmode=c-shared
      -o "${OUTPUT_LIB}"
      "${GO_SOURCE_DIR}"
  WORKING_DIRECTORY "${GO_SOURCE_DIR}"
  COMMENT "Building Go shared library for Linux"
  VERBATIM
)

add_custom_target(hyprspace_go_lib ALL DEPENDS "${OUTPUT_LIB}")

install(FILES "${OUTPUT_LIB}" DESTINATION lib)
