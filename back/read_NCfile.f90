
  integer,parameter :: imax, jmax, lmax
  real*4, intent(OUT) :: data(imax,jmax,lmax), x(imax), y(jmax)
  real*8, intent(OUT) :: t(lmax)

!----------------------------------------------------------

  integer :: ncid, vid(4), GetDim_ID(4)
  integer :: imax, jmax, lmax

  real :: offset, scale, missing


!==============================================================================
!==============================================================================


  ! Open file
  call check( NF90_Open( 'XXX.nc', NF90_NoWrite, ncid) )

     ! Dimension
     call check( NF90_Inq_DimID (ncid, "lon",  GetDim_ID(1)) )
     call check( NF90_Inq_DimID (ncid, "lat",  GetDim_ID(2)) )
     call check( NF90_Inq_DimID (ncid, "lev",  GetDim_ID(3)) )
     call check( NF90_Inq_DimID (ncid, "time", GetDim_ID(4)) )

     call check( NF90_Inquire_Dimension (ncid, GetDim_ID(1), len=imax) )
     call check( NF90_Inquire_Dimension (ncid, GetDim_ID(2), len=jmax) )
     call check( NF90_Inquire_Dimension (ncid, GetDim_ID(3), len=kmax) )
     call check( NF90_Inquire_Dimension (ncid, GetDim_ID(4), len=lmax) )

     ! Read variables
     call check( NF90_Inq_VarID (ncid, "lon",  vid(1)) )
     call check( NF90_Inq_VarID (ncid, "lat",  vid(2)) )
     call check( NF90_Inq_VarID (ncid, "time", vid(3)) )
     call check( NF90_Inq_VarID (ncid, "data", vid(4)) )

     call check( NF90_Get_Var (ncid, vid(1), x) )
     call check( NF90_Get_Var (ncid, vid(2), y) )
     call check( NF90_Get_Var (ncid, vid(3), t) )
     call check( NF90_Get_Var (ncid, vid(4), DATA) )  

     call check( NF90_Get_Att (ncid, vid(4), "add_offset",    offset) )
     call check( NF90_Get_Att (ncid, vid(4), "scale_factor",  scale) )
     call check( NF90_Get_Att (ncid, vid(4), "_FillValue", missing) )

  ! Close file
  call check( NF90_Close (ncid) )
