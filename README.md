# Jonquil: *Bringing TOML blooms to JSON land*

[![License](https://img.shields.io/badge/license-MIT%7CApache%202.0-blue)](LICENSE-Apache)

This project started out of the idea to make a TOML parser speak JSON.
Turns out this kind of works good enough.

Jonquil takes the TOML Fortran API and implements a JSON lexer as well as a JSON serializer, for consistency it applies some renaming on top and here we are with yet another JSON library.
The resulting JSON parser reaches a similar performance as the established [JSON Fortran](https://github.com/jacobwilliams/json-fortran).

The goal of Jonquil is not to provide the most conforming JSON library, but to provide a compatibility layer to enable TOML Fortran using libraries to consume JSON as well as allow JSON consuming libraries to try out TOML.

* [JSON specification](https://www.json.org/json-en.html)
* [TOML Fortran documentation](https://toml-f.readthedocs.io)

<div align="center">
<img src="./assets/jonquil.svg" alt="Jonquil Blossoms" width="220">
</div>


## Installation

Since Jonquil is just another bloom of TOML Fortran, you can simply follow its installation guide.
You can also find these instructions in the user documentation at [Installing TOML Fortran](https://toml-f.readthedocs.io/en/latest/how-to/installation.html) and apply the flavor provided by Jonquil on top.


## Building from source

To build this project from the source code in this repository you need to have

- a Fortran compiler supporting Fortran 2008

  - GFortran 5 or newer
  - Intel Fortran 18 or newer
  - NAG 7 or newer

- One of the supported build systems

  - [meson](https://mesonbuild.com) version 0.55 or newer
  - [CMake](https://cmake.org/) version 3.9 or newer
  - [Fortran package manager (fpm)](https://github.com/fortran-lang/fpm) version 0.2.0 or newer

Get the source by cloning the repository

```
git clone https://github.com/toml-f/jonquil
cd jonquil
```


### Building with meson

To integrate Jonquil in your meson project checkout the [Integrate with meson](https://toml-f.readthedocs.io/en/latest/how-to/integration.html#integrate-with-meson) recipe and apply the same steps as for TOML Fortran.

To build this project with meson a build-system backend is required, *i.e.* [ninja](https://ninja-build.org) version 1.7 or newer.
Setup a build with

```
meson setup _build --prefix=/path/to/install
```

You can select the Fortran compiler by the `FC` environment variable.
To compile the project run

```
meson compile -C _build
```

Finally, you can install Jonquil using

```
meson install -C _build
```



### Building with CMake

To integrate Jonquil in your CMake project checkout the [Integrate with CMake](https://toml-f.readthedocs.io/en/latest/how-to/integration.html#integrate-with-cmake) recipe and apply the same steps for Jonquil as well.

While meson is the preferred way to build this project it also offers CMake support.
Configure the CMake build with

```
cmake -B _build -G Ninja -DCMAKE_INSTALL_PREFIX=/path/to/install
```

Similar to meson the compiler can be selected with the `FC` environment variable.
You can build the project using

```
cmake --build _build
```

Finally, you can install Jonquil using

```
cmake --install _build
```



### Building with fpm

To integrate Jonquil in your fpm project checkout the [Using the Fortran package manager](https://toml-f.readthedocs.io/en/latest/how-to/integration.html#using-the-fortran-package-manager) recipe, just replace *toml-f* with *jonquil* and you are good to go.

The Fortran package manager ([fpm](https://github.com/fortran-lang/fpm)) supports the addition of Jonquil as a dependency.
In the package manifest, `fpm.toml`, you can add TOML Fortran dependency via:

```toml
[dependencies]
jonquil.git = "https://github.com/toml-f/jonquil"
```

Then build and test normally.

```
fpm build
fpm test
```


## Usage

You can follow all recipes and tutorials in the [TOML Fortran documentation](https://toml-f.readthedocs) using Jonquil by just replacing the *tomlf* module with the *jonquil* module.
All derived types, procedure names and interfaces use the *json\_* prefix instead of *toml\_*, with the exception of the *toml\_table* type which becomes a *json\_object*.

The following example program shows how to load JSON data from a string and access the value using the build interface as well as the compatibility of with TOML Fortran.

```f90
program demo
  use jonquil, only : json_loads, json_value, json_object, json_error, &
    & cast_to_object, get_value
  implicit none

  class(json_value), allocatable :: val
  type(json_object), pointer :: object
  type(json_error), allocatable :: error
  integer :: ival

  call json_loads(val, '{"a":1,"b":2}', error=error)
  if (allocated(error)) then
    print '(a)', error%message
    stop
  end if

  object => cast_to_object(val)
  if (associated(object)) then
    call get_value(object, "a", ival)
    print '(a,1x,i0)', "a is", ival

    call get_value(object, "b", ival)
    print '(a,1x,i0)', "b is", ival
  end if

  block
    use tomlf, only : toml_table, toml_array, add_array, set_value, toml_serializer

    type(toml_table), pointer :: table
    type(toml_array), pointer :: array
    type(toml_serializer) :: ser

    ! Add an array to the object
    call add_array(object, "c", array)
    call set_value(array, [-1, 0, 1])

    ! Create a new subobject / subtable
    call get_value(object, "d", table, requested=.true.)
    call set_value(table, "sub", "table")

    print '(a)', "# representation in TOML land"
    call object%accept(ser)
  end block

end program demo
```

Jonquil promises seamless compatibility with TOML Fortran, the data structure we just loaded can be manipulated with any procedure from the *tomlf* module and vice versa.


## Contributing

This is a volunteer open source projects and contributions are always welcome.
Please, take a moment to read the [contributing guidelines](https://github.com/toml-f/toml-f/blob/main/CONTRIBUTING.md) on how to get involved with TOML Fortran and Jonquil.


## License

Jonquil is free software: you can redistribute it and/or modify it under the terms of the [Apache License, Version 2.0](LICENSE-Apache) or [MIT license](LICENSE-MIT) at your opinion.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an _as is_ basis, without warranties or conditions of any kind, either express or implied. See the License for the specific language governing permissions and limitations under the License.

Unless you explicitly state otherwise, any contribution intentionally submitted for inclusion in Jonquil by you, as defined in the Apache-2.0 license, shall be dual licensed as above, without any additional terms or conditions.
