
  use netcdf

  integer :: ncid, vid(5), dimids(4)
  integer :: x_dimid, y_dimid, z_dimid, t_dimid
  


  ! Create the netCDF file.
  call check( NF90_Create( "XXX.nc", NF90_Clobber, ncid) )
     
  ! Define the dimensions.
    call check( NF90_Def_Dim (ncid, "lon",  nx, x_dimid) )
    call check( NF90_Def_Dim (ncid, "lat",  ny, y_dimid) )
    call check( NF90_Def_Dim (ncid, "lev",  nz, z_dimid) )
    call check( NF90_Def_Dim (ncid, "time", nt, t_dimid) )

    dimids =  (/ x_dimid, y_dimid, z_dimid, t_dimid /)
  
  ! Define the variable.
    call check( NF90_Def_Var (ncid, "lon",  NF90_REAL, x_dimid, vid(1)) )
    call check( NF90_Def_Var (ncid, "lat",  NF90_REAL, y_dimid, vid(2)) )
    call check( NF90_Def_Var (ncid, "lev",  NF90_REAL, z_dimid, vid(3)) )
    call check( NF90_Def_Var (ncid, "time", NF90_REAL, t_dimid, vid(4)) )
    call check( NF90_Def_Var (ncid, "data", NF90_REAL, dimids,  vid(5)) )

  ! Define the attribute
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
  
    call check( NF90_Put_Att (ncid, vid(5), "_FillValue", -1e34) )
  
    call check( NF90_Put_Att (ncid, NF90_GLOBAL, "title", "Data") )

  ! End define mode.
  call check( NF90_enddef(ncid) )
     
  ! Write the pretend data to the file.
    call check( NF90_Put_Var (ncid, vid(1), lon) )
    call check( NF90_Put_Var (ncid, vid(2), lat) )
    call check( NF90_Put_Var (ncid, vid(3), lev) )
    call check( NF90_Put_Var (ncid, vid(4), time) )
    call check( NF90_Put_Var (ncid, vid(5), data) )
  
  ! Close the file.
  call check( NF90_Close(ncid) )
     

