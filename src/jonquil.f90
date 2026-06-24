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

!> Public API for Jonquil - JSON parser and serializer for Fortran.
!>
!> This module provides the main entry point for working with JSON data in Fortran.
!> It re-exports types and procedures from TOML Fortran with JSON-appropriate naming,
!> enabling seamless interoperability between JSON and TOML data structures.
!>
!> ## Quick Start
!>
!> ```fortran
!> use jonquil
!> class(json_value), allocatable :: val
!> type(json_error), allocatable :: error
!>
!> ! Parse JSON from a string
!> call json_loads(val, '{"key": "value"}', error=error)
!>
!> ! Serialize back to JSON
!> print '(a)', json_serialize(val)
!> ```
!>
!> ## Main Types
!>
!> - `json_object` - JSON object (key-value mapping), see [`toml_table`](https://toml-f.github.io/toml-f/type/toml_table.html)
!> - `json_array` - JSON array, see [`toml_array`](https://toml-f.github.io/toml-f/type/toml_array.html)
!> - `json_value` - Base type for all JSON values, see [`toml_value`](https://toml-f.github.io/toml-f/type/toml_value.html)
!> - `json_error` - Error information from parsing/serialization, see [`toml_error`](https://toml-f.github.io/toml-f/type/toml_error.html)
!>
!> ## Main Procedures
!>
!> - [[json_load]] / [[json_loads]] - Parse JSON from files or strings
!> - [[json_dump]] / [[json_dumps]] - Serialize to files or strings
!> - [[json_serialize]] - Serialize and return as string
!> - `get_value` / `set_value` - Access and modify values,
!>   see [`get_value`](https://toml-f.github.io/toml-f/interface/get_value.html)
!>   and [`set_value`](https://toml-f.github.io/toml-f/interface/set_value.html)
module jonquil
   use tomlf, only : get_value, set_value, json_path => toml_path, &
      & json_context => toml_context, json_parser_config => toml_parser_config, &
      & json_level => toml_level, json_error => toml_error, json_stat => toml_stat, &
      & json_terminal => toml_terminal, json_object => toml_table, json_array => toml_array, &
      & json_keyval => toml_keyval, json_key => toml_key, json_value => toml_value, &
      & new_object => new_table, add_object => add_table, add_array, add_keyval, sort, len
   use tomlf_type, only : cast_to_object => cast_to_table, cast_to_array, cast_to_keyval
   use tomlf_version, only : tomlf_version_string, tomlf_version_compact, get_tomlf_version
   use jonquil_version, only : jonquil_version_string, jonquil_version_compact, &
      & get_jonquil_version
   use jonquil_parser, only : json_load, json_loads
   use jonquil_ser, only : json_serializer, json_serialize, json_dump, json_dumps, &
      & json_ser_config
   implicit none
   public

end module jonquil
