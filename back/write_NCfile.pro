
; DATA
n1 = 10
n2 = 20
data = FINDGEN(n1,n2)

; OPEN FILE
id = NCDF_Create('tmp.nc', /clobber)

; DEFINE DIMENSION
xid = NCDF_DimDef(id, 'x', n1)
yid = NCDF_DimDef(id, 'y', n2)

; DEFINE VARIABLE
did = NCDF_VarDef(id, 'data', [xid,yid], /float)

; WRITE MEMO
NCDF_AttPut, id, did, 'name', 'Data' 
NCDF_AttPut, id, did, 'units', 'arbitrary'

NCDF_AttPut, id, /Global, 'Title', 'Output from test program'

; END OF WRITING HEADER
NCDF_Control, id, /EnDef 

; WRITE DATA
NCDF_VarPut, id, did, data

; CLOSE FILE
NCDF_Close, id

END
