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

testdrive_dep = dependency(
  'test-drive',
  fallback: ['test-drive', 'testdrive_dep'],
  default_options: ['default_library=static'],
  static: true,
)

unittests = [
  'lexer',
]

test_srcs = files('main.f90')
foreach t : unittests
  test_srcs += files('test_@0@.f90'.format(t))
endforeach

tester = executable(
  'tftester',
  sources: test_srcs,
  dependencies: [jonquil_dep, testdrive_dep],
)

foreach t : unittests
  test(
    t,
    tester,
    args: [t],
    suite: 'unit',
  )
endforeach
