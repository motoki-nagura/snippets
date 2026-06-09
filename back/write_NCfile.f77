
  character(len=*),parameter :: txt11="longitude",txt12="degrees_east",txt13="X"
  character(len=*),parameter :: txt21="latitude",txt22="degrees_north",txt23="Y"
  character(len=*),parameter :: txt31="depth",txt32="m",txt33="Z",txt34="down"
  character(len=*),parameter :: txt41="days since 1900-1-1 00:00:0.0"

  integer st,ncid,x_dimid,y_dimid,z_dimid,t_dimid,dimids(4)
  integer varid1,varid2,varid3,varid4,varid

  st= NF_CREATE (filename,NF_NOCLOBBER,ncid) ; call he(st)

    st= NF_DEF_DIM (ncid,"lon", imax,x_dimid); call he(st)
    st= NF_DEF_DIM (ncid,"lat", jmax,y_dimid); call he(st)
    st= NF_DEF_DIM (ncid,"lev", kmax,z_dimid); call he(st)
    st= NF_DEF_DIM (ncid,"time",lmax,t_dimid); call he(st)
    dimids=(/x_dimid,y_dimid,z_dimid,t_dimid/)

    st= NF_DEF_VAR (ncid,"lon",  NF_DOUBLE, 1, x_dimid, varid1); call he(st)
    st= NF_DEF_VAR (ncid,"lat",  NF_DOUBLE, 1, y_dimid, varid2); call he(st)
    st= NF_DEF_VAR (ncid,"lev",  NF_DOUBLE, 1, z_dimid, varid3); call he(st)
    st= NF_DEF_VAR (ncid,"time", NF_INT,    1, t_dimid, varid4); call he(st)
    st= NF_DEF_VAR (ncid,"var",  NF_FLOAT,  4, dimids,  varid5); call he(st)

    st= NF_PUT_ATT_TEXT (ncid,varid1,"long_name",len_trim(txt11),txt11); call he(st)
    st= NF_PUT_ATT_TEXT (ncid,varid1,"units",    len_trim(txt12),txt12); call he(st)
    st= NF_PUT_ATT_TEXT (ncid,varid1,"axis",     len_trim(txt13),txt13); call he(st)

    st= NF_PUT_ATT_TEXT (ncid,varid2,"long_name",len_trim(txt21),txt21); call he(st)
    st= NF_PUT_ATT_TEXT (ncid,varid2,"units",    len_trim(txt22),txt22); call he(st)
    st= NF_PUT_ATT_TEXT (ncid,varid2,"axis",     len_trim(txt23),txt23); call he(st)

    st= NF_PUT_ATT_TEXT (ncid,varid3,"long_name",len_trim(txt31),txt31); call he(st)
    st= NF_PUT_ATT_TEXT (ncid,varid3,"units",    len_trim(txt32),txt32); call he(st)
    st= NF_PUT_ATT_TEXT (ncid,varid3,"axis",     len_trim(txt33),txt33); call he(st)
    st= NF_PUT_ATT_TEXT (ncid,varid3,"positive", len_trim(txt34),txt34); call he(st)

    st= NF_PUT_ATT_TEXT (ncid,varid4,"units",    len_trim(txt41),txt41); call he(st)

    st= NF_PUT_ATT_REAL (ncid,varid5,"_FillValue",NF_FLOAT,1,-1e10)

  st= NF_ENDDEF(ncid); call he(st)

    st= NF_PUT_VAR_DOUBLE (ncid,varid1,lon) ; call he(st)
    st= NF_PUT_VAR_DOUBLE (ncid,varid2,lat) ; call he(st)
    st= NF_PUT_VAR_DOUBLE (ncid,varid3,lev) ; call he(st)
    st= NF_PUT_VAR_INT    (ncid,varid4,time); call he(st)
    st= NF_PUT_VAR_REAL   (ncid,varid5,var) ; call he(st)

  st= NF_CLOSE(ncid); call he(st)
