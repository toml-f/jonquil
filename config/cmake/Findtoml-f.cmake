# This file is part of jonquil.
# SPDX-Identifier: Apache-2.0 OR MIT
#
# Licensed under either of Apache License, Version 2.0 or MIT license
# at your option; you may not use this file except in compliance with
# the License.
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#[[.rst:
Find TOML Fortran
-----------------

Makes the TOML Fortran (toml-f) project available.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported target, if found:

``toml-f::toml-f``
  The toml-f library


Result Variables
^^^^^^^^^^^^^^^^

This module will define the following variables:

``TOML_FORTRAN_FOUND``
  True if the toml-f library is available

``TOML_FORTRAN_SOURCE_DIR``
  Path to the source directory of the toml-f project,
  only set if the project is included as source.

``TOML_FORTRAN_BINARY_DIR``
  Path to the binary directory of the toml-f project,
  only set if the project is included as source.

Cache variables
^^^^^^^^^^^^^^^

The following cache variables may be set to influence the library detection:

``TOML_FORTRAN_FIND_METHOD``
  Methods to find or make the project available. Available methods are

  - ``cmake``: Try to find via CMake config file
  - ``pkgconf``: Try to find via pkg-config file
  - ``subproject``: Use source in subprojects directory
  - ``fetch``: Fetch the source from upstream

``TOML_FORTRAN_DIR``
  Used for searching the CMake config file

``TOML_FORTRAN_SUBPROJECT``
  Directory to find the toml-f subproject, relative to the project root

#]]

set(_lib "toml-f")
set(_pkg "TOML_FORTRAN")
set(_url "https://github.com/toml-f/toml-f")
set(_rev "HEAD")

if(NOT DEFINED "${_pkg}_FIND_METHOD")
  if(DEFINED "${PROJECT_NAME}-dependency-method")
    set("${_pkg}_FIND_METHOD" "${${PROJECT_NAME}-dependency-method}")
  else()
    set("${_pkg}_FIND_METHOD" "cmake" "pkgconf" "subproject" "fetch")
  endif()
  set("_${_pkg}_FIND_METHOD")
endif()

foreach(method ${${_pkg}_FIND_METHOD})
  if(TARGET "${_lib}::${_lib}")
    break()
  endif()

  if("${method}" STREQUAL "cmake")
    message(STATUS "${_lib}: Find installed package")
    if(DEFINED "${_pkg}_DIR")
      set("_${_pkg}_DIR")
      set("${_lib}_DIR" "${_pkg}_DIR")
    endif()
    find_package("${_lib}" CONFIG QUIET)
    if("${_lib}_FOUND")
      message(STATUS "${_lib}: Found installed package")
      break()
    endif()
  endif()

  if("${method}" STREQUAL "pkgconf")
    find_package(PkgConfig QUIET)
    pkg_check_modules("${_pkg}" QUIET "${_lib}")
    if("${_pkg}_FOUND")
      message(STATUS "Found ${_lib} via pkg-config")

      add_library("${_lib}::${_lib}" INTERFACE IMPORTED)
      target_link_libraries(
        "${_lib}::${_lib}"
        INTERFACE
        "${${_pkg}_LINK_LIBRARIES}"
        )
      target_include_directories(
        "${_lib}::${_lib}"
        INTERFACE
        "${${_pkg}_INCLUDE_DIRS}"
        )

      break()
    endif()
  endif()

  if("${method}" STREQUAL "subproject")
    if(NOT DEFINED "${_pkg}_SUBPROJECT")
      set("_${_pkg}_SUBPROJECT")
      set("${_pkg}_SUBPROJECT" "subprojects/${_lib}")
    endif()
    set("${_pkg}_SOURCE_DIR" "${PROJECT_SOURCE_DIR}/${${_pkg}_SUBPROJECT}")
    set("${_pkg}_BINARY_DIR" "${PROJECT_BINARY_DIR}/${${_pkg}_SUBPROJECT}")
    if(EXISTS "${${_pkg}_SOURCE_DIR}/CMakeLists.txt")
      message(STATUS "Include ${_lib} from ${${_pkg}_SUBPROJECT}")
      add_subdirectory(
        "${${_pkg}_SOURCE_DIR}"
        "${${_pkg}_BINARY_DIR}"
      )

      add_library("${_lib}::${_lib}" INTERFACE IMPORTED)
      target_link_libraries("${_lib}::${_lib}" INTERFACE "${_lib}")
      break()
    endif()
  endif()

  if("${method}" STREQUAL "fetch")
    message(STATUS "Retrieving ${_lib} from ${_url}")
    include(FetchContent)
    FetchContent_Declare(
      "${_lib}"
      GIT_REPOSITORY "${_url}"
      GIT_TAG "${_rev}"
      )
    FetchContent_MakeAvailable("${_lib}")

    add_library("${_lib}::${_lib}" INTERFACE IMPORTED)
    target_link_libraries("${_lib}::${_lib}" INTERFACE "${_lib}")

    FetchContent_GetProperties("${_lib}" SOURCE_DIR "${_pkg}_SOURCE_DIR")
    FetchContent_GetProperties("${_lib}" BINARY_DIR "${_pkg}_BINARY_DIR")
    break()
  endif()

endforeach()

if(TARGET "${_lib}::${_lib}")
  set("${_pkg}_FOUND" TRUE)
else()
  set("${_pkg}_FOUND" FALSE)
endif()

if(DEFINED "_${_pkg}_SUBPROJECT")
  unset("${_pkg}_SUBPROJECT")
  unset("_${_pkg}_SUBPROJECT")
endif()
if(DEFINED "_${_pkg}_DIR")
  unset("${_lib}_DIR")
  unset("_${_pkg}_DIR")
endif()
if(DEFINED "_${_pkg}_FIND_METHOD")
  unset("${_pkg}_FIND_METHOD")
  unset("_${_pkg}_FIND_METHOD")
endif()
unset(_lib)
unset(_pkg)
unset(_url)
unset(_rev)
