# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file at
# the root of the source tree or at
# <https://github.com/Krzmbrzl/cmake-compiler-flags/blob/main/LICENSE>.

cmake_minimum_required(VERSION 3.5)

project(CompilerFlagsTest)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/..")

include(CompilerFlags)

# If no options are given, we should get a set of default flags
get_compiler_flags(
	OUTPUT_VARIABLE DEFAULT_FLAGS
)

message(STATUS "Default flags: ${DEFAULT_FLAGS}")

# If we explicitly opt out of the default flags, we should get an empty list
get_compiler_flags(
	DISABLE_DEFAULT_FLAGS
	OUTPUT_VARIABLE EMPTY_FLAGS
)

if (EMPTY_FLAGS)
	message(FATAL_ERROR "Got flags, but expected no flags to be returned: \"${EMPTY_FLAGS}\"")
endif()

get_compiler_flags(
	DISABLE_DEFAULT_FLAGS
	ENABLE_WARNINGS_AS_ERRORS
	OUTPUT_VARIABLE WARNINGS_AS_ERRORS_FLAGS
)

message(STATUS "Flag(s) to turn warnings into errors: ${WARNINGS_AS_ERRORS_FLAGS}")

get_compiler_flags(
	DISABLE_DEFAULT_FLAGS
	ENABLE_MOST_WARNINGS
	OUTPUT_VARIABLE MOST_WARNINGS_FLAGS
)

message(STATUS "Flag(s) to enable most warnings: ${MOST_WARNINGS_FLAGS}")

get_compiler_flags(
	DISABLE_DEFAULT_FLAGS
	ENABLE_ALL_WARNINGS
	OUTPUT_VARIABLE ALL_WARNINGS_FLAGS
)

message(STATUS "Flag(s) to enable all warnings: ${ALL_WARNINGS_FLAGS}")

get_compiler_flags(
	DISABLE_DEFAULT_FLAGS
	DISABLE_ALL_WARNINGS
	OUTPUT_VARIABLE NO_WARNINGS_FLAGS
)

message(STATUS "Flag(s) to disable all warnings: ${NO_WARNINGS_FLAGS}")

get_compiler_flags(
	ENABLE_ALL_WARNINGS
	ENABLE_WARNINGS_AS_ERRORS
	DISABLE_ALL_WARNINGS
	OUTPUT_VARIABLE ALL_FLAGS
)

message(STATUS "All supported flags: ${ALL_FLAGS}")

add_executable(tester "test.cpp")
target_compile_options(tester PRIVATE ${ALL_FLAGS})
