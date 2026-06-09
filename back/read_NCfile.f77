

  st= NF_OPEN(filename,'NF_NOWRITE',ncid) ; call he(st)

    st= NF_INQ_DIMID(ncid,'x',dimid)    ; call he(st)
    st= NF_INQ_DIMLEN(ncid,dimid,xlen)  ; call he(st)

    st= NF_INQ_VARID(ncid,'lon',varid)  ; call he(st)
    st= NF_GET_VAR_REAL(ncid,varid,lon) ; call he(st)

    st= NF_INQ_VARID(ncid,'lat',varid)  ; call he(st)
    st= NF_GET_VAR_REAL(ncid,varid,lat) ; call he(st)

    st= NF_INQ_VARID(ncid,'temp',varid) ; call he(st)
    st= NF_GET_VAR_REAL(ncid,varid,temp) ; call he(st)
    st= NF_GET_ATT_REAL(ncid,varid,'add_offset',offset)  ; call he(st)
    st= NF_GET_ATT_REAL(ncid,varid,'scale_factor',scale) ; call he(st)

  st= NF_CLOSE(ncid) ; call he(st)