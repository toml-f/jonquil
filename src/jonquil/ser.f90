! This file is part of toml-f.
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

!> Implementation of a serializer for TOML values to JSON, used for testing only.
module jonquil_ser
   use tomlf_constants
   use tomlf_datetime
   use tomlf_type, only : toml_value, toml_visitor, toml_key, toml_table, &
      & toml_array, toml_keyval, is_array_of_tables, len
   use tomlf_utils, only : to_string
   implicit none
   private

   public :: json_serializer
   public :: json_serialize


   !> Serializer to produduce a JSON document from a TOML datastructure
   type, extends(toml_visitor) :: json_serializer

      !> Output string
      character(len=:), allocatable :: output

      !> Indentation
      character(len=:), allocatable :: indentation

      !> Current depth in the tree
      integer :: depth = 0

   contains

      !> Visit a TOML value
      procedure :: visit

   end type json_serializer


contains


function json_serialize(val) result(string)
   !> TOML value to visit
   class(toml_value), intent(inout) :: val

   !> Serialized JSON value
   character(len=:), allocatable :: string

   type(json_serializer) :: ser

   ser = json_serializer()
   call val%accept(ser)
   string = ser%output

end function json_serialize


!> Visit a TOML value
subroutine visit(self, val)

   !> Instance of the JSON serializer
   class(json_serializer), intent(inout) :: self

   !> TOML value to visit
   class(toml_value), intent(inout) :: val

   if (.not.allocated(self%output)) self%output = ""

   select type(val)
   class is(toml_keyval)
      call visit_keyval(self, val)
   class is(toml_array)
      call visit_array(self, val)
   class is(toml_table)
      call visit_table(self, val)
   end select

end subroutine visit


!> Visit a TOML key-value pair
subroutine visit_keyval(visitor, keyval)

   !> Instance of the JSON serializer
   class(json_serializer), intent(inout) :: visitor

   !> TOML value to visit
   type(toml_keyval), intent(inout) :: keyval

   character(kind=tfc, len=:), allocatable :: str, key
   character(kind=tfc, len=:), pointer :: sdummy
   type(toml_datetime), pointer :: ts
   integer(tfi), pointer :: idummy
   real(tfr), pointer :: fdummy
   logical, pointer :: ldummy

   call indent(visitor)

   if (allocated(keyval%key)) then
      call escape_string(keyval%key, key)
      visitor%output = visitor%output // """" // key // """: "
   end if

   select case(keyval%get_type())
   case default
      visitor%output = visitor%output // "null"

   case(toml_type%string)
      call keyval%get(sdummy)
      call escape_string(sdummy, str)
      visitor%output = visitor%output // """" // str // """"

   case(toml_type%boolean)
      call keyval%get(ldummy)
      if (ldummy) then
         visitor%output = visitor%output // "true"
      else
         visitor%output = visitor%output // "false"
      end if

   case(toml_type%int)
      call keyval%get(idummy)
      visitor%output = visitor%output // to_string(idummy)

   case(toml_type%float)
      call keyval%get(fdummy)
      if (fdummy > huge(fdummy)) then
         visitor%output = visitor%output // """+inf"""
      else if (fdummy < -huge(fdummy)) then
         visitor%output = visitor%output // """-inf"""
      else if (fdummy /= fdummy) then
         visitor%output = visitor%output // """nan"""
      else
         visitor%output = visitor%output // to_string(fdummy)
      end if

   case(toml_type%datetime)
      call keyval%get(ts)
      visitor%output = visitor%output // """" // to_string(ts) // """"

   end select

end subroutine visit_keyval


!> Visit a TOML array
subroutine visit_array(visitor, array)

   !> Instance of the JSON serializer
   class(json_serializer), intent(inout) :: visitor

   !> TOML value to visit
   type(toml_array), intent(inout) :: array

   class(toml_value), pointer :: ptr
   character(kind=tfc, len=:), allocatable :: key
   integer :: i, n

   call indent(visitor)

   if (allocated(array%key)) then
      call escape_string(array%key, key)
      visitor%output = visitor%output // """" // key // """: "
   end if

   visitor%output = visitor%output // "["
   visitor%depth = visitor%depth + 1
   n = len(array)
   do i = 1, n
      call array%get(i, ptr)
      call ptr%accept(visitor)
      if (i /= n) visitor%output = visitor%output // ","
   end do
   visitor%depth = visitor%depth - 1
   call indent(visitor)
   visitor%output = visitor%output // "]"

end subroutine visit_array


!> Visit a TOML table
subroutine visit_table(visitor, table)

   !> Instance of the JSON serializer
   class(json_serializer), intent(inout) :: visitor

   !> TOML table to visit
   type(toml_table), intent(inout) :: table

   class(toml_value), pointer :: ptr
   type(toml_key), allocatable :: list(:)
   character(kind=tfc, len=:), allocatable :: key
   integer :: i, n

   call indent(visitor)

   if (allocated(table%key)) then
      call escape_string(table%key, key)
      visitor%output = visitor%output // """" // key // """: "
   end if

   visitor%output = visitor%output // ","
   visitor%depth = visitor%depth + 1

   call table%get_keys(list)

   n = size(list, 1)
   do i = 1, n
      call table%get(list(i)%key, ptr)
      call ptr%accept(visitor)
      if (i /= n) visitor%output = visitor%output // ","
   end do

   visitor%depth = visitor%depth - 1
   call indent(visitor)
   if (visitor%depth == 0) then
      if (allocated(visitor%indentation)) visitor%output = visitor%output // new_line('a')
      visitor%output = visitor%output // "}" // new_line('a')
   else
      visitor%output = visitor%output // "}"
   endif

end subroutine visit_table


!> Produce indentations for emitted JSON documents
subroutine indent(self)

   !> Instance of the JSON serializer
   class(json_serializer), intent(inout) :: self

   integer :: i

   ! PGI internal compiler error in NVHPC 20.7 and 20.9 with
   ! write(self%unit, '(/, a)', advance='no') repeat(self%indentation, self%depth)
   ! causes: NVFORTRAN-F-0000-Internal compiler error. Errors in Lowering      16
   if (allocated(self%indentation) .and. self%depth > 0) then
      self%output = self%output // new_line('a') // repeat(self%indentation, self%depth)
   end if

end subroutine indent


!> Transform a TOML raw value to a JSON compatible escaped string
subroutine escape_string(raw, escaped)

   !> Raw value of TOML value
   character(len=*), intent(in) :: raw

   !> JSON compatible escaped string
   character(len=:), allocatable, intent(out) :: escaped

   integer :: i

   escaped = ''
   do i = 1, len(raw)
      select case(raw(i:i))
      case default; escaped = escaped // raw(i:i)
      case('\'); escaped = escaped // '\\'
      case('"'); escaped = escaped // '\"'
      case(TOML_NEWLINE); escaped = escaped // '\n'
      case(TOML_FORMFEED); escaped = escaped // '\f'
      case(TOML_CARRIAGE_RETURN); escaped = escaped // '\r'
      case(TOML_TABULATOR); escaped = escaped // '\t'
      case(TOML_BACKSPACE); escaped = escaped // '\b'
      end select
   end do

end subroutine escape_string


end module jonquil_ser
