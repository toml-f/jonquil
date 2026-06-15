@PACKAGE_INIT@

set("JONQUIL_USE_TOMLF" @JONQUIL_USE_TOMLF@)

if(NOT TARGET "@PROJECT_NAME@::@PROJECT_NAME@")
  include(CMakeFindDependencyMacro)

  if(NOT TARGET "toml-f::toml-f" AND JONQUIL_USE_TOMLF)
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}")
    find_dependency("toml-f")
    list(REMOVE_AT CMAKE_MODULE_PATH -1)
  endif()

  include("${CMAKE_CURRENT_LIST_DIR}/@PROJECT_NAME@-targets.cmake")
endif()
