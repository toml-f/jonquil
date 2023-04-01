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

!> Minimal public API for Jonquil
module jonquil
   use tomlf, only : get_value, set_value, json_path => toml_path, &
      & json_context => toml_context, json_parser_config => toml_parser_config, &
      & json_level => toml_level, json_error => toml_error, json_stat => toml_stat, &
      & json_terminal => toml_terminal, json_object => toml_table, json_array => toml_array, &
      & json_keyval => toml_keyval, json_key => toml_key, json_value => toml_value, &
      & new_object => new_table, add_object => add_table, add_array, add_keyval, sort, len
   use tomlf_type, only : cast_to_object => cast_to_table, cast_to_array, cast_to_keyval
   use tomlf_version, only : tomlf_version_string, tomlf_version_compact, get_tomlf_version
   use jonquil_parser, only : json_load, json_loads
   use jonquil_ser, only : json_serializer, json_serialize, json_dump, json_dumps, &
      & json_ser_config
   implicit none
   public

end module jonquil
