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

module test_serializer
   use jonquil, only : json_serializer, json_serialize, json_ser_config
   use testdrive, only : error_type, new_unittest, unittest_type, check
   use tomlf, only : toml_array, toml_table, add_array, add_table, set_value
   use tomlf_type, only : new_array, new_table
   implicit none
   private
   public :: collect_serializer
contains
subroutine collect_serializer(testsuite)
   type(unittest_type), allocatable, intent(out) :: testsuite(:)
   testsuite = [ &
      & new_unittest("empty", empty_containers), &
      & new_unittest("nested", nested_values), &
      & new_unittest("indent", indented_values), &
      & new_unittest("visitor-prefix", visitor_prefix), &
      & new_unittest("buffer-growth", buffer_growth)]
end subroutine collect_serializer

subroutine empty_containers(error)
   type(error_type), allocatable, intent(out) :: error
   type(toml_array) :: array
   type(toml_table) :: table
   call new_array(array)
   call new_table(table)
   call check(error, json_serialize(array), "[]")
   if (allocated(error)) return
   call check(error, json_serialize(table), "{}"//new_line("a"))
end subroutine empty_containers

subroutine nested_values(error)
   type(error_type), allocatable, intent(out) :: error
   type(toml_array) :: array
   type(toml_array), pointer :: empty
   type(toml_table), pointer :: table
   call new_array(array)
   call add_table(array, table)
   call set_value(table, "number", 3)
   call set_value(table, "enabled", .true.)
   call set_value(table, "text", "a"//new_line("a")//'"'//achar(92))
   call add_array(table, "empty", empty)
   call check(error, json_serialize(array), &
      & '[{"number": 3,"enabled": true,"text": "a\n\"\\","empty": []}]')
end subroutine nested_values

subroutine indented_values(error)
   type(error_type), allocatable, intent(out) :: error
   type(toml_array) :: array
   type(json_ser_config) :: config
   call new_array(array)
   call set_value(array, 1, 1)
   call set_value(array, 2, 2)
   config%indent = "  "
   call check(error, json_serialize(array, config), &
      & "["//new_line("a")//"  1,"//new_line("a")//"  2]")
end subroutine indented_values

subroutine visitor_prefix(error)
   type(error_type), allocatable, intent(out) :: error
   type(toml_array) :: array
   type(json_serializer) :: visitor
   call new_array(array)
   call set_value(array, 1, 1)
   visitor%output = "prefix:"
   call array%accept(visitor)
   call check(error, visitor%output, "prefix:[1]")
   if (allocated(error)) return
   call array%accept(visitor)
   call check(error, visitor%output, "prefix:[1][1]")
   if (allocated(error)) return
   call check(error, visitor%depth, 0)
end subroutine visitor_prefix

subroutine buffer_growth(error)
   type(error_type), allocatable, intent(out) :: error
   type(toml_array) :: array
   type(toml_table) :: table
   integer :: i
   call new_array(array)
   do i = 1, 128
      call set_value(array, i, "x")
   end do
   call check(error, json_serialize(array), "["//repeat('"x",', 127)//'"x"]')
   if (allocated(error)) return
   call new_table(table)
   call set_value(table, "first", repeat("x", 130))
   call set_value(table, "second", repeat("x", 130))
   call check(error, json_serialize(table), &
      & '{"first": "'//repeat("x", 130)//'","second": "'// &
      & repeat("x", 130)//'"}'//new_line("a"))
end subroutine buffer_growth
end module test_serializer
