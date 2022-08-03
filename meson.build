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

project(
  'jonquil',
  'fortran',
  version: '0.1.0',
  license: 'Apache-2.0 OR MIT',
  meson_version: '>=0.55',
  default_options: [
    'buildtype=debugoptimized',
    'default_library=both',
  ],
)
install = not (meson.is_subproject() and get_option('default_library') == 'static')

# General configuration information
lib_deps = []
subdir('config')

# Collect source of the project
srcs = []
subdir('src')

# Jonquil library target
jonquil_lib = library(
  meson.project_name(),
  sources: srcs,
  version: meson.project_version(),
  dependencies: lib_deps,
  install: install,
)

# Export dependency for other projects and test suite
jonquil_inc = jonquil_lib.private_dir_include()
jonquil_dep = declare_dependency(
  link_with: jonquil_lib,
  dependencies: lib_deps,
  include_directories: jonquil_inc,
)

# Package the license files
jonquil_lic = files(
  'LICENSE-MIT',
  'LICENSE-Apache',
)

if install
  # Distribute the license files in share/licenses/<name>
  install_data(
    jonquil_lic,
    install_dir: get_option('datadir')/'licenses'/meson.project_name()
  )

  module_id = meson.project_name() / 'modules'
  meson.add_install_script(
    find_program(files('config'/'install-mod.py')),
    get_option('includedir') / module_id,
  )

  pkg = import('pkgconfig')
  pkg.generate(
    jonquil_lib,
    description: 'Bringing TOML blooms to JSON land',
    subdirs: ['', module_id],
  )
endif

# add the testsuite
subdir('test')
