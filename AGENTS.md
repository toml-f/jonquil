# AGENTS.md - Guidelines for AI Coding Assistants

This document provides guidance for AI coding assistants (GitHub Copilot, Claude, etc.) working with the jonquil codebase.

## Project Overview

**Jonquil** is a Fortran library that brings JSON parsing and serialization capabilities to the TOML Fortran ecosystem. It implements a JSON lexer and serializer on top of the [TOML Fortran](https://github.com/toml-f/toml-f) API, providing seamless interoperability between JSON and TOML data structures.

- **Language**: Fortran 2008
- **License**: Apache-2.0 OR MIT (dual-licensed)
- **Repository**: https://github.com/toml-f/jonquil

## Code Structure

```
src/
├── jonquil.f90          # Main public API module
└── jonquil/
    ├── lexer.f90        # JSON tokenizer/lexer
    ├── parser.f90       # JSON parser implementation
    ├── ser.f90          # JSON serializer
    └── version.f90      # Version information

test/
└── unit/
    ├── main.f90         # Test driver
    └── test_lexer.f90   # Lexer unit tests

config/                  # Build configuration files
subprojects/             # Meson subproject dependencies
```

## Build Systems

The project supports three build systems:

1. **Meson** (preferred): `meson setup _build && meson compile -C _build`
2. **CMake**: `cmake -B _build -G Ninja && cmake --build _build`
3. **fpm** (Fortran Package Manager): `fpm build && fpm test`

## Coding Conventions

### File Headers

All source files must include the SPDX license header:

```fortran
! This file is part of jonquil.
! SPDX-Identifier: Apache-2.0 OR MIT
!
! Licensed under either of Apache License, Version 2.0 or MIT license
! at your option; you may not use this file except in compliance with
! the License.
!
! Unless required by applicable law or agreed to in writing, software
! distributed under the License is distributed on an "AS IS" BASIS,
! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
! See the License for the specific language governing permissions and
! limitations under the License.
```

### Fortran Style

- Use **free-form** Fortran source format (`.f90` extension)
- Use `implicit none` in all program units
- Prefer `intent(in)`, `intent(out)`, or `intent(inout)` for all dummy arguments
- Use descriptive variable and procedure names
- Document public procedures with comment blocks describing parameters
- Use `allocatable` for dynamic data rather than pointers where possible

### Naming Conventions

- Module names: `jonquil_<component>` (e.g., `jonquil_lexer`, `jonquil_parser`)
- Public API uses `json_` prefix (e.g., `json_load`, `json_dumps`, `json_object`)
- Internal/private procedures use descriptive names without prefix
- Test modules: `test_<component>` (e.g., `test_lexer`)

### Module Structure

```fortran
module jonquil_example
   use dependency_module, only : specific_imports
   implicit none
   private

   public :: public_type, public_procedure

   ! Type definitions

   ! Interface definitions

contains

   ! Procedure implementations

end module jonquil_example
```

## Dependencies

- **toml-f** (>=0.4.0): The TOML Fortran library that jonquil builds upon
- **test-drive** (v0.4.0): Unit testing framework (test dependency only)

## Testing

- Unit tests are located in `test/unit/`
- Tests use the [test-drive](https://github.com/fortran-lang/test-drive) framework
- Each test module should have a `collect_<name>` subroutine that returns a testsuite
- Run tests with: `meson test -C _build` or `fpm test` or `ctest`

### Adding New Tests

1. Create a new test file `test/unit/test_<name>.f90`
2. Add the test to the build system files (`meson.build`, `CMakeLists.txt`)
3. Register the test collection in `test/unit/main.f90`

## API Compatibility

Jonquil is designed for seamless compatibility with TOML Fortran:

- `json_object` corresponds to `toml_table`
- `json_array` corresponds to `toml_array`
- `json_value` corresponds to `toml_value`
- Data structures can be manipulated using either `jonquil` or `tomlf` module procedures

## Important Implementation Notes

1. The JSON lexer (`jonquil_lexer`) extends `abstract_lexer` from toml-f
2. The lexer inserts a prelude of tokens to wrap JSON in a pseudo-TOML structure
3. The parser reuses toml-f's parser infrastructure with the custom lexer
4. Special handling exists for annotated JSON test format values (type/value pairs)

## When Making Changes

1. Ensure changes compile with all three build systems
2. Add or update unit tests for new functionality
3. Maintain backward compatibility with the public API
4. Update version numbers in `src/jonquil/version.f90` and build files for releases
5. Follow the existing code style in neighboring code

## Resources

- [JSON Specification](https://www.json.org/json-en.html)
- [TOML Fortran Documentation](https://toml-f.readthedocs.io)
- [Fortran Best Practices](https://fortran-lang.org/learn/best_practices)
