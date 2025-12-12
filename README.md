# Jonquil

*Bringing TOML blooms to JSON land*

[![License](https://img.shields.io/badge/license-MIT%7CApache%202.0-blue)](LICENSE-Apache)
[![CI](https://github.com/toml-f/jonquil/actions/workflows/fortran-build.yml/badge.svg)](https://github.com/toml-f/jonquil/actions/workflows/fortran-build.yml)

Jonquil is a JSON library for Fortran, built on top of [TOML Fortran](https://github.com/toml-f/toml-f).
It provides a simple API for parsing and serializing JSON data, with seamless interoperability with TOML data structures.

<div align="center">
<img src="./assets/jonquil.svg" alt="Jonquil Blossoms" width="220">
</div>

## Features

- **Parse JSON** from files or strings
- **Serialize** Fortran data structures to JSON
- **Seamless compatibility** with TOML Fortran data structures
- **Modern Fortran** (2008 standard)
- **Multiple build systems**: fpm, Meson, and CMake


## Quick Start

Add Jonquil to your `fpm.toml`:

```toml
[dependencies]
jonquil.git = "https://github.com/toml-f/jonquil"
```

Parse and work with JSON:

```fortran
program example
  use jonquil
  implicit none

  class(json_value), allocatable :: data
  type(json_object), pointer :: object
  type(json_error), allocatable :: error
  character(:), allocatable :: name
  integer :: count

  ! Parse JSON from a string
  call json_loads(data, '{"name": "Fortran", "count": 42}', error=error)
  if (allocated(error)) error stop error%message

  ! Access values
  object => cast_to_object(data)
  call get_value(object, "name", name)
  call get_value(object, "count", count)

  print '(a,a)', "Name: ", name
  print '(a,i0)', "Count: ", count

  ! Serialize back to JSON
  print '(a)', json_serialize(data)
end program example
```


## Documentation

- **[TOML Fortran Documentation](https://toml-f.readthedocs.io)** - Comprehensive guide (Jonquil follows the same API patterns)
- **[Jonquil Guide](https://toml-f.readthedocs.io/en/latest/how-to/jonquil.html)** - Jonquil-specific documentation
- **[JSON Specification](https://www.json.org/json-en.html)** - Official JSON format reference


## Installation

### Using fpm (recommended)

Add to your `fpm.toml`:

```toml
[dependencies]
jonquil.git = "https://github.com/toml-f/jonquil"
```

Build and run:

```bash
fpm build
fpm test
```

### Using Meson

```bash
git clone https://github.com/toml-f/jonquil
cd jonquil
meson setup _build
meson compile -C _build
meson test -C _build
```

### Using CMake

```bash
git clone https://github.com/toml-f/jonquil
cd jonquil
cmake -B _build -G Ninja
cmake --build _build
ctest --test-dir _build
```

For detailed installation instructions, see the [installation guide](https://toml-f.readthedocs.io/en/latest/how-to/installation.html).


## API Overview

### Key Types

| Jonquil Type | TOML Fortran Type | Description |
|--------------|-------------------|-------------|
| `json_object` | `toml_table` | Key-value mapping |
| `json_array` | `toml_array` | Ordered list of values |
| `json_value` | `toml_value` | Base type for all values |
| `json_error` | `toml_error` | Error information |

### Key Procedures

| Procedure | Description |
|-----------|-------------|
| `json_load(val, filename)` | Load JSON from a file |
| `json_loads(val, string)` | Load JSON from a string |
| `json_dump(val, filename)` | Write JSON to a file |
| `json_dumps(val, string)` | Write JSON to a string |
| `json_serialize(val)` | Serialize and return as string |
| `get_value(object, key, val)` | Get a value from an object |
| `set_value(object, key, val)` | Set a value in an object |


## TOML Fortran Compatibility

Jonquil data structures are fully compatible with TOML Fortran.
You can use procedures from either library interchangeably:

```fortran
program compatibility
  use jonquil, only : json_loads, json_value, json_object, cast_to_object
  use tomlf, only : toml_array, add_array, set_value, toml_serialize
  implicit none

  class(json_value), allocatable :: data
  type(json_object), pointer :: object
  type(toml_array), pointer :: array

  ! Parse with Jonquil
  call json_loads(data, '{"values": [1, 2, 3]}')
  object => cast_to_object(data)

  ! Modify with TOML Fortran
  call add_array(object, "more", array)
  call set_value(array, [4, 5, 6])

  ! Serialize with TOML Fortran
  print '(a)', toml_serialize(object)
end program compatibility
```


## Requirements

- **Fortran compiler** supporting Fortran 2008:
  - GFortran 5+
  - Intel Fortran 18+
  - NAG 7+
- **Build system** (one of):
  - [fpm](https://github.com/fortran-lang/fpm) 0.2.0+
  - [Meson](https://mesonbuild.com) 0.55+
  - [CMake](https://cmake.org/) 3.9+


## Contributing

Contributions are welcome!
Please read the [contributing guidelines](https://github.com/toml-f/toml-f/blob/main/CONTRIBUTING.md) to get started.


## License

Jonquil is free software: you can redistribute it and/or modify it under the terms of the [Apache License, Version 2.0](LICENSE-Apache) or [MIT license](LICENSE-MIT) at your opinion.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an _as is_ basis, without warranties or conditions of any kind, either express or implied. See the License for the specific language governing permissions and limitations under the License.

Unless you explicitly state otherwise, any contribution intentionally submitted for inclusion in Jonquil by you, as defined in the Apache-2.0 license, shall be dual licensed as above, without any additional terms or conditions.
