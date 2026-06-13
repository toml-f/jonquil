@PACKAGE_INIT@

set("JONQUIL_USE_TOMLF" @JONQUIL_USE_TOMLF@)

if(NOT TARGET "@PROJECT_NAME@::@PROJECT_NAME@")
  include("${CMAKE_CURRENT_LIST_DIR}/@PROJECT_NAME@-targets.cmake")

  include(CMakeFindDependencyMacro)

  if(NOT TARGET "toml-f::toml-f" AND JONQUIL_USE_TOMLF)
    find_dependency("toml-f")
  endif()
endif()
