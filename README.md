# cmake-compiler-flags

CMake utilities to expose common compiler flags in a compiler-independent way. This works by exposing a CMake function `get_compiler_flags` that can
optionally take some arguments specifying what kind of flags to enable. It then tries to figure out the appropriate flags for the given compiler.

The available options are:
| **Option** | **Description** |
| ---------- | --------------- |
| `ENABLE_WARNINGS_AS_ERRORS` | Turns warnings into errors |
| `ENABLE_MOST_WARNINGS` | Enables most of the available compiler warnings. The choice of which exactly this includes, is arguably subjective. |
| `ENABLE_ALL_WARNINGS` | Attempts to enable all available compiler warnings. Even those, that might be considered inappropriate by some/many developers. |
| `DISABLE_ALL_WARNINGS` | Disables all warnings |
| `DISABLE_DEFAULT_FLAGS` | If this is given, the function omits adding some common default flags, which are normally returned in addition to the ones explicitly requested. |
| `ENSURE_DEFAULT_CHAR_IS_SIGNED` | Ensures that a plain `char` will be signed. |
| `ENSURE_DEFAULT_CHAR_IS_UNSIGNED` | Ensures that a plain `char` will be unsigned. |
| `COMPILER_ID <id>` | Specifies the compiler ID of the compiler to obtain the flags for. The ID must be one of the possible values of `CMAKE_<LANG>_COMPILER_ID`. Note that currently only `GNU` (GCC), `Clang`, `AppleClang` and `MSVC` are supported. If not given, this option defaults to the currently used compiler for the chosen language. |
| `LANG <lang>` | The language for which to obtain compiler flags. Note, that currently only `CXX` (C++) is supported. If not given, this defaults to `CXX`. |
| `OUTPUT_VARIABLE` | The name of the variable the result shall be stored in. This is the only **mandatory** function argument. |

Thus, an example invocation could look like this:
```cmake
get_compiler_flags(
	ENABLE_MOST_WARNINGS
	ENABLE_WARNINGS_AS_ERRORS
	OUTPUT_VARIABLE MY_FLAGS
)

# Note: In general you should prefer per-target flag definitions
add_compile_options(${MY_FLAGS})
```

For more examples, have a look at the [tests](test/CMakeLists.txt).
