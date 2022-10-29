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


# Warnings as errors 
get_compiler_flags(
	DISABLE_DEFAULT_FLAGS
	ENABLE_WARNINGS_AS_ERRORS
	OUTPUT_VARIABLE WARNINGS_AS_ERRORS_FLAGS
)

message(STATUS "Flag(s) to turn warnings into errors: ${WARNINGS_AS_ERRORS_FLAGS}")


# Enable most warnings
get_compiler_flags(
	DISABLE_DEFAULT_FLAGS
	ENABLE_MOST_WARNINGS
	OUTPUT_VARIABLE MOST_WARNINGS_FLAGS
)

message(STATUS "Flag(s) to enable most warnings: ${MOST_WARNINGS_FLAGS}")


# Enable all warnings
get_compiler_flags(
	DISABLE_DEFAULT_FLAGS
	ENABLE_ALL_WARNINGS
	OUTPUT_VARIABLE ALL_WARNINGS_FLAGS
)

message(STATUS "Flag(s) to enable all warnings: ${ALL_WARNINGS_FLAGS}")


# Disable all warnings
get_compiler_flags(
	DISABLE_DEFAULT_FLAGS
	DISABLE_ALL_WARNINGS
	OUTPUT_VARIABLE NO_WARNINGS_FLAGS
)

message(STATUS "Flag(s) to disable all warnings: ${NO_WARNINGS_FLAGS}")


# Ensure plain char is signed
get_compiler_flags(
	DISABLE_DEFAULT_FLAGS
	ENSURE_DEFAULT_CHAR_IS_SIGNED
	OUTPUT_VARIABLE SIGNED_CHAR_FLAGS
)

message(STATUS "Flag(s) to ensure plain char is signed: ${SIGNED_CHAR_FLAGS}")

add_executable(signed_char "char_signedness.cpp")
target_compile_definitions(signed_char PRIVATE EXPECT_CHAR_SIGNED)
target_compile_options(signed_char PRIVATE ${SIGNED_CHAR_FLAGS})


# Ensure plain char is unsigned
get_compiler_flags(
	DISABLE_DEFAULT_FLAGS
	ENSURE_DEFAULT_CHAR_IS_UNSIGNED
	OUTPUT_VARIABLE UNSIGNED_CHAR_FLAGS
)

message(STATUS "Flag(s) to ensure plain char is unsigned: ${UNSIGNED_CHAR_FLAGS}")

add_executable(unsigned_char "char_signedness.cpp")
target_compile_definitions(unsigned_char PRIVATE EXPECT_CHAR_UNSIGNED)
target_compile_options(unsigned_char PRIVATE ${UNSIGNED_CHAR_FLAGS})


# Enable unsafe (aka fast) math
get_compiler_flags(
	DISABLE_DEFAULT_FLAGS
	ENABLE_UNSAFE_MATH
	OUTPUT_VARIABLE UNSAFE_MATH_FLAGS
)

message(STATUS "Flag(s) to enable unsafe (\"fast\") math: ${UNSAFE_MATH_FLAGS}")


# Test all flags at once and see if a program can be compiled with them
# (aka: whether all flags are known to the compiler)
get_compiler_flags(
	ENABLE_ALL_WARNINGS
	ENABLE_WARNINGS_AS_ERRORS
	ENABLE_UNSAFE_MATH
	DISABLE_ALL_WARNINGS
	ENSURE_DEFAULT_CHAR_IS_SIGNED
	ENSURE_DEFAULT_CHAR_IS_UNSIGNED
	OUTPUT_VARIABLE ALL_FLAGS
)

message(STATUS "All supported flags: ${ALL_FLAGS}")

add_executable(tester "test.cpp")
target_compile_options(tester PRIVATE ${ALL_FLAGS})
