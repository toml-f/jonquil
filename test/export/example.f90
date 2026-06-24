program tester
  use jonquil_version, only : get_jonquil_version
  implicit none
  character(len=:), allocatable :: version
  call get_jonquil_version(string=version)
  print *, version
end program tester
