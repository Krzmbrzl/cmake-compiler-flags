# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file at
# the root of the source tree or at
# <https://github.com/Krzmbrzl/cmake-compiler-flags/blob/main/LICENSE>.

cmake_minimum_required(VERSION 3.5)

include(CheckCXXCompilerFlag)

function(get_compiler_flags)
	set(options
		ENABLE_WARNINGS_AS_ERRORS
		ENABLE_MOST_WARNINGS
		ENABLE_ALL_WARNINGS
		DISABLE_DEFAULT_FLAGS
	)
	set(oneValueArgs
		COMPILER_ID
		LANG
		OUTPUT_VARIABLE
	)
	set(multiValueArgs "")

	cmake_parse_arguments(GET_COMPILER_FLAGS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

	######################################
	############ Preprocessing ###########
	######################################
	if (GET_COMPILER_FLAGS_LANG)
		string(TOUPPER "${GET_COMPILER_FLAGS_LANG}" GET_COMPILER_FLAGS_LANG)
	endif()

	######################################
	########### Error handling ###########
	######################################
	if (GET_COMPILER_FLAGS_UNPARSED_ARGUMENTS)
		message(FATAL_ERROR "get_compiler_flags: Unrecognized arguments: \"${GET_COMPILER_FLAGS_UNPARSED_ARGUMENTS}\"")
	endif()
	if (GET_COMPILER_FLAGS_LANG AND NOT GET_COMPILER_FLAGS_COMPILER_ID STREQUAL "CXX")
		# Limitation of the current implementation
		message(FATAL_ERROR "get_compiler_flags: Languages other than CXX (C++) are not yet supported")
	endif()
	if (NOT GET_COMPILER_FLAGS_OUTPUT_VARIABLE)
		message(FATAL_ERROR "get_compiler_flags: OUTPUT_VARIABLE not defined or empty")
	endif()

	######################################
	########### Handle defaults ##########
	######################################
	if (NOT GET_COMPILER_FLAGS_LANG)
		# Use C++ as the default language
		set(GET_COMPILER_FLAGS_LANG "CXX")
	endif()
	if (NOT GET_COMPILER_FLAGS_COMPILER_ID)
		# Use current compiler as default
		set(GET_COMPILER_FLAGS_COMPILER_ID "${CMAKE_${GET_COMPILER_FLAGS_LANG}_COMPILER_ID}")
	endif()

	######################################
	########### Postprocessing ###########
	######################################
	# Upper-casing
	string(TOUPPER "${GET_COMPILER_FLAGS_COMPILER_ID}" GET_COMPILER_FLAGS_COMPILER_ID)

	# Stripping
	string(STRIP "${GET_COMPILER_FLAGS_LANG}" GET_COMPILER_FLAGS_LANG)
	string(STRIP "${GET_COMPILER_FLAGS_COMPILER_ID}" GET_COMPILER_FLAGS_COMPILER_ID)


	######################################
	############ Post-checks #############
	######################################
	if (NOT GET_COMPILER_FLAGS_COMPILER_ID)
		message(FATAL_ERROR "get_compiler_flags: Missing/empty compiler ID")
	endif()



	######################################
	########### Flag handling ############
	######################################
	set(compiler_flags "")

	# Warnings as errors
	if (GET_COMPILER_FLAGS_ENABLE_WARNINGS_AS_ERRORS)
		if (GET_COMPILER_FLAGS_COMPILER_ID STREQUAL "GNU" OR GET_COMPILER_FLAGS_COMPILER_ID MATCHES ".*CLANG")
			list(APPEND compiler_flags "-Werror")
		elseif(GET_COMPILER_FLAGS_COMPILER_ID STREQUAL "MSVC")
			list(APPEND compiler_flags "/WX")
		else()
			message(FATAL_ERROR
				"get_compiler_flags: Unsupported compiler \"${GET_COMPILER_FLAGS_COMPILER_ID}\" for feature ENABLE_WARNINGS_AS_ERRORS")
		endif()
	endif()

	# Enable most warnings
	if (GET_COMPILER_FLAGS_ENABLE_MOST_WARNINGS)
		if (GET_COMPILER_FLAGS_COMPILER_ID STREQUAL "GNU" OR GET_COMPILER_FLAGS_COMPILER_ID MATCHES ".*CLANG")
			list(APPEND compiler_flags "-Wall" "-Wpedantic" "-Wextra")
		elseif(GET_COMPILER_FLAGS_COMPILER_ID STREQUAL "MSVC")
			list(APPEND compiler_flags "/W4")
		else()
			message(FATAL_ERROR
				"get_compiler_flags: Unsupported compiler \"${GET_COMPILER_FLAGS_COMPILER_ID}\" for feature ENABLE_MOST_WARNINGS")
		endif()
	endif()

	# Enable all warnings
	if (GET_COMPILER_FLAGS_ENABLE_ALL_WARNINGS)
		if (GET_COMPILER_FLAGS_COMPILER_ID STREQUAL "GNU" OR GET_COMPILER_FLAGS_COMPILER_ID MATCHES ".*CLANG")
			list(APPEND compiler_flags "-Wall" "-Wpedantic" "-Wextra" "-Wabi")
		elseif(GET_COMPILER_FLAGS_COMPILER_ID STREQUAL "MSVC")
			list(APPEND compiler_flags "/Wall")
		else()
			message(FATAL_ERROR
				"get_compiler_flags: Unsupported compiler \"${GET_COMPILER_FLAGS_COMPILER_ID}\" for feature ENABLE_ALL_WARNINGS")
		endif()
	endif()


	if (NOT GET_COMPILER_FLAGS_DISABLE_DEFAULT_FLAGS)
		if (GET_COMPILER_FLAGS_COMPILER_ID STREQUAL "GNU" OR GET_COMPILER_FLAGS_COMPILER_ID MATCHES ".*CLANG")
			# Avoid "File too big" error
			check_cxx_compiler_flag("-Wa-mbig-obj" COMPILER_HAS_MBIG_OBJ)
			if (COMPILER_HAS_MBIG_OBJ)
				list(APPEND compiler_flags "-Wa,-mbig-obj")
			endif()
		elseif (GET_COMPILER_FLAGS_COMPILER_ID STREQUAL "MSVC")
			# Avoid "Fatal Error C1128: number of sections exceeded object file format limit" error
			# Penalty of using this flag by default should be small to non-existent
			# (see https://stackoverflow.com/q/15110580)
			list(APPEND compiler_flags "/bigobj")

			# Treat unrecognized compiler options as errors (otherwise the actual behavior of the code
			# might end up not being the one the programmer thinks it is).
			list(APPEND compiler_flags "/options:strict")
		endif()
	endif()

	set(${GET_COMPILER_FLAGS_OUTPUT_VARIABLE} ${compiler_flags} PARENT_SCOPE)
endfunction()
