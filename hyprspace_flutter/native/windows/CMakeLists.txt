cmake_minimum_required(VERSION 3.14)
project(hyprspace_native VERSION 1.0.0 LANGUAGES C)

find_program(GO_EXECUTABLE go REQUIRED)

set(GO_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../go")
set(OUTPUT_DLL "${CMAKE_CURRENT_BINARY_DIR}/hyprspace.dll")
set(OUTPUT_HEADER "${CMAKE_CURRENT_BINARY_DIR}/hyprspace_bridge.h")

add_custom_command(
  OUTPUT "${OUTPUT_DLL}" "${OUTPUT_HEADER}"
  COMMAND ${CMAKE_COMMAND} -E env
    CGO_ENABLED=1
    GOOS=windows
    ${GO_EXECUTABLE} build
      -buildmode=c-shared
      -o "${OUTPUT_DLL}"
      "${GO_SOURCE_DIR}"
  WORKING_DIRECTORY "${GO_SOURCE_DIR}"
  COMMENT "Building Go shared library for Windows"
  VERBATIM
)

add_custom_target(hyprspace_go_lib ALL DEPENDS "${OUTPUT_DLL}")

install(FILES "${OUTPUT_DLL}" DESTINATION bin)
