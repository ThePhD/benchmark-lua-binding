# # lua bindings shootout
# The MIT License (MIT)
# 
# Copyright � 2018 ThePhD
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

include(ExternalProject)
include(FindPackageHandleStandardArgs)
include(Common/Core)

# # Base variables
set(luawrapper_version 0.5.0)
set(luawrapper_lib luawrapper_lib_${luawrapper_version})

# # Useful locations
set(luawrapper_dev_toplevel "${CMAKE_BINARY_DIR}/vendor/luawrapper_${luawrapper_version}")
set(luawrapper_include_dirs "${luawrapper_dev_toplevel}/include")

# # luawrapper library sources
set(luawrapper_sources LuaContext.hpp)
prepend(luawrapper_sources "${luawrapper_dev_toplevel}/include/" ${luawrapper_sources})

# # External project to get sources
ExternalProject_Add(LUAWRAPPERDEV_SOURCE
	BUILD_IN_SOURCE TRUE
	BUILD_ALWAYS FALSE
	# # Use Git to get what we need
	GIT_SHALLOW TRUE
	GIT_REPOSITORY https://github.com/ahupowerdns/luawrapper.git
	PREFIX ${luawrapper_dev_toplevel}
	SOURCE_DIR ${luawrapper_dev_toplevel}
	DOWNLOAD_DIR ${luawrapper_dev_toplevel}
	TMP_DIR "${luawrapper_dev_toplevel}-tmp"
	STAMP_DIR "${luawrapper_dev_toplevel}-stamp"
	INSTALL_DIR "${luawrapper_dev_toplevel}/local"
	CONFIGURE_COMMAND ""
	BUILD_COMMAND ""
	INSTALL_COMMAND ""
	TEST_COMMAND ""
	BUILD_BYPRODUCTS "${luawrapper_sources}")

find_package(Boost REQUIRED)

add_library(${luawrapper_lib} INTERFACE)
add_dependencies(${luawrapper_lib} LUAWRAPPERDEV_SOURCE)
target_include_directories(${luawrapper_lib} INTERFACE ${luawrapper_include_dirs})
target_link_libraries(${luawrapper_lib} INTERFACE ${LUA_LIBRARIES})
if (NOT MSVC)
	target_compile_options(${luawrapper_lib} INTERFACE
		-Wno-noexcept-type -Wno-ignored-qualifiers -Wno-unused-parameter)
endif()
target_link_libraries(${luawrapper_lib}
	INTERFACE ${Boost_LIBRARIES}
)
target_include_directories(${luawrapper_lib}
	INTERFACE ${Boost_INCLUDE_DIRS}
)

set(LUAWRAPPERDEV_FOUND TRUE)
set(LUAWRAPPER_LIBRARIES ${luawrapper_lib})
set(LUAWRAPPER_INCLUDE_DIRS ${luawrapper_include_dirs})

FIND_PACKAGE_HANDLE_STANDARD_ARGS(LuawrapperDev
	FOUND_VAR LUAWRAPPERDEV_FOUND
	REQUIRED_VARS LUAWRAPPER_LIBRARIES LUAWRAPPER_INCLUDE_DIRS
	VERSION_VAR luawrapper_version)
