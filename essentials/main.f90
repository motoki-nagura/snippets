module my_arrays

  use, intrinsic :: iso_fortran_env  !  for real64
  implicit none

  integer :: nx,ny,nz,nt
  real ( kind = 4 ), allocatable, dimension(:)       :: lon,lat,lev,time
  real ( kind = 4 ), allocatable, dimension(:,:,:,:) :: var
  real ( kind = 4 )  :: missing
  character :: char_time_units*50

  integer,parameter :: in_unit=21, out_unit=41

end module my_arrays


program main
!===========================================================================
!                               FORTRAN MAIN PROGRAM
!===========================================================================
  use my_arrays
  use netcdf
  implicit none

  namelist /namelist_example/ character1, double1, integer1
  character*120 :: character1
  real*8        :: double1
  integer       :: integer1

  type my_arrays
    integer i
    real*4 :: var
  end type arrays

  type ( my_arrays ) :: my_array1

  real finish


  real*8, parameter :: pi = 4d0 *datan(1d0)

  real*4, parameter :: Erad  = 6371e3    ! Earth's radius [m]
  real*4, parameter :: Omega = 7.292e-5  ! Earth's rotational speed [s^-1], mom3 manual

  real*8, parameter :: deg2rad = 2d0 *pi /360d0          !  1 deg in radian
  real*8, parameter :: deg2met = 2d0 *pi *Erad /360d0    !  1 deg in meter

  real(real32), parameter :: nan32 =  transfer(-4194304_int32, 1._real32)
  real(real64), parameter :: nan64 =  transfer(-2251799813685248_int64, 1._real64)

  read(unit=31, nml=namelist_example )
!-----------------------------------------------------------------------------
!-----------------------------------------------------------------------------
  call get_data

  write(*,*)
  write(*,*) 'lon  = ',MinVal(lon), MaxVal(lon)
  write(*,*) 'lat  = ',MinVal(lat), MaxVal(lat)
  write(*,*) 'lev  = ',MinVal(lev), MaxVal(lev)
  write(*,*) 'time = ',MinVal(time),MaxVal(time)
  write(*,*) 'var  = ',MinVal(var), MaxVal(var)
  write(*,*) 'missing = ',missing
  write(*,*)

!-----------------------------------------------------------------------------
!-----------------------------------------------------------------------------

  call write_out

!-----------------------------------------------------------------------------
!-----------------------------------------------------------------------------
  call cpu_time(finish)
    write (*,*)
    print '("Time = ",f6.3," minutes.")', finish/60.
  stop " : STOPPED"
end program main


!==============================================================================
!==============================================================================


subroutine get_data   !{{{
  use my_arrays
  use netcdf
  implicit none

  integer :: ncid, GetDim_ID(4), vid(5)
  character  :: file_name*150

  read(in_unit,'(a)') file_name
  write(*,*) "get_data: "//trim(file_name)

  ! Open file
  call check( NF90_Open (file_name,NF90_nowrite,ncid) )

     ! Dimension
     call check( NF90_Inq_DimID (ncid, "lon",  GetDim_ID(1)) )
     call check( NF90_Inq_DimID (ncid, "lat",  GetDim_ID(2)) )
     call check( NF90_Inq_DimID (ncid, "lev",  GetDim_ID(3)) )
     call check( NF90_Inq_DimID (ncid, "time", GetDim_ID(4)) )

     call check( NF90_Inquire_Dimension (ncid, GetDim_ID(1), len=nx) )
     call check( NF90_Inquire_Dimension (ncid, GetDim_ID(2), len=ny) )
     call check( NF90_Inquire_Dimension (ncid, GetDim_ID(3), len=nz) )
     call check( NF90_Inquire_Dimension (ncid, GetDim_ID(4), len=nt) )

     ! allocate
     allocate ( lon(nx), lat(ny), lev(nz), time(nt) )
     allocate ( var(nx,ny,nz,nt) )

     ! Read variables
     call check( NF90_Inq_VarID (ncid, "lon",  vid(1)) )
     call check( NF90_Inq_VarID (ncid, "lat",  vid(2)) )
     call check( NF90_Inq_VarID (ncid, "lev",  vid(3)) )
     call check( NF90_Inq_VarID (ncid, "time", vid(4)) )
     call check( NF90_Inq_VarID (ncid, "var",  vid(5)) )

     call check( NF90_Get_Var (ncid, vid(1), lon) )
     call check( NF90_Get_Var (ncid, vid(2), lat) )
     call check( NF90_Get_Var (ncid, vid(3), lev) )
     call check( NF90_Get_Var (ncid, vid(4), time) )
     call check( NF90_Get_Var (ncid, vid(5), var) )

     call check( NF90_Get_Att (ncid, vid(4), "units", char_time_units) )

     call check( NF90_Get_Att (ncid, vid(5), "add_offset",   offset) )
     call check( NF90_Get_Att (ncid, vid(5), "scale_factor", scale) )
     call check( NF90_Get_Att (ncid, vid(5), "_FillValue",   missing) )

  ! Close file
  call check( NF90_Close (ncid) )

return
end subroutine get_data !}}}


!==============================================================================
!==============================================================================


subroutine write_out !{{{
  use my_arrays
  use netcdf
  implicit none

  integer :: dimids(4), x_dimid,y_dimid,z_dimid,t_dimid
  integer :: ncid, vid(5)
  character :: file_name*150

  read(out_unit,'(a)') file_name
  write(*,*) "write_out : "//trim(file_name)

  call check( NF90_Create( path=trim(file_name), &
                          cmode=or(nf90_clobber,nf90_netcdf4), &
                           ncid=ncid) )
     
    call check( NF90_Def_Dim (ncid, "lon",  nx, x_dimid) )
    call check( NF90_Def_Dim (ncid, "lat",  ny, y_dimid) )
    call check( NF90_Def_Dim (ncid, "lev",  nz, z_dimid) )
    call check( NF90_Def_Dim (ncid, "time", NF90_UNLIMITED, t_dimid) )

    dimids =  (/ x_dimid, y_dimid, z_dimid, t_dimid /)
  
    call check( NF90_Def_Var (ncid, "lon",  NF90_REAL, x_dimid, vid(1)) )
    call check( NF90_Def_Var (ncid, "lat",  NF90_REAL, y_dimid, vid(2)) )
    call check( NF90_Def_Var (ncid, "lev",  NF90_REAL, z_dimid, vid(3)) )
    call check( NF90_Def_Var (ncid, "time", NF90_REAL, t_dimid, vid(4)) )
    call check( NF90_Def_Var (ncid, "var",  NF90_REAL, dimids,  vid(5)) )

    call check( NF90_Put_Att (ncid, vid(1), "long_name", "longitude") )
    call check( NF90_Put_Att (ncid, vid(1), "units",     "degrees_east") )
    call check( NF90_Put_Att (ncid, vid(1), "axis",      "X") )
  
    call check( NF90_Put_Att (ncid, vid(2), "long_name", "latitude") )
    call check( NF90_Put_Att (ncid, vid(2), "units",     "degrees_north") )
    call check( NF90_Put_Att (ncid, vid(2), "axis",      "Y") )
  
    call check( NF90_Put_Att (ncid, vid(3), "long_name", "depth") )
    call check( NF90_Put_Att (ncid, vid(3), "units",     "m") )
    call check( NF90_Put_Att (ncid, vid(3), "axis",      "Z") )
    call check( NF90_Put_Att (ncid, vid(3), "positive",  "down") )
  
    call check( NF90_Put_Att (ncid, vid(4), "units",     "DAYS SINCE 1900-1-1 00:00:0.0") )
  
    call check( NF90_Put_Att (ncid, vid(5), "_FillValue", missing) )
 
  call check( NF90_enddef(ncid) )
     
    call check( NF90_Put_Var (ncid, vid(1), lon) )
    call check( NF90_Put_Var (ncid, vid(2), lat) )
    call check( NF90_Put_Var (ncid, vid(3), lev) )
    call check( NF90_Put_Var (ncid, vid(4), time) )
    call check( NF90_Put_Var (ncid, vid(5), var) )
 
  call check( NF90_Close(ncid) )

return
end subroutine write_out !}}}


!==============================================================================
!==============================================================================


