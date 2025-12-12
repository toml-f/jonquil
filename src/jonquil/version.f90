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

!> Version information for the Jonquil library.
module jonquil_version
   implicit none
   private

   public :: get_jonquil_version
   public :: jonquil_version_string, jonquil_version_compact


   !> String representation of the jonquil version
   character(len=*), parameter :: jonquil_version_string = "0.3.0"

   !> Major version number of the above jonquil version
   integer, parameter :: jonquil_major = 0

   !> Minor version number of the above jonquil version
   integer, parameter :: jonquil_minor = 3

   !> Patch version number of the above jonquil version
   integer, parameter :: jonquil_patch = 0

   !> Compact numeric representation of the jonquil version
   integer, parameter :: jonquil_version_compact = &
      & jonquil_major*10000 + jonquil_minor*100 + jonquil_patch


contains


!> Getter function to retrieve jonquil version
subroutine get_jonquil_version(major, minor, patch, string)

   !> Major version number of the jonquil version
   integer, intent(out), optional :: major

   !> Minor version number of the jonquil version
   integer, intent(out), optional :: minor

   !> Patch version number of the jonquil version
   integer, intent(out), optional :: patch

   !> String representation of the jonquil version
   character(len=:), allocatable, intent(out), optional :: string

   if (present(major)) then
      major = jonquil_major
   end if
   if (present(minor)) then
      minor = jonquil_minor
   end if
   if (present(patch)) then
      patch = jonquil_patch
   end if
   if (present(string)) then
      string = jonquil_version_string
   end if

end subroutine get_jonquil_version


end module jonquil_version
