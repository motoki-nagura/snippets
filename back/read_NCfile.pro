

id = NCDF_Open('example.nc')

NCDF_VarGet, id, NCDF_VarID(id,'uwnd'), data
NCDF_AttGet, id, NCDF_VarID(id,'uwnd'), 'scale_factor', scalefactor
NCDF_AttGet, id, NCDF_VarID(id,'uwnd'), 'add_offset', addoffset

data = Float(data)*scalefactor + addoffset

NCDF_Close, id
