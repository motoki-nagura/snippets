#!/bin/bash

var="temp"

#----------------------------------  with 2D lon & lat

    cat > tmp.gs << EOF 
'reinit'

'xdfopen ./example.ctl'


'set x 1 360'
'set y 1 180'
'set z 1 50'
'set t 1 12'

'define var =  ave(${var},t+${ns},t=${ne},1yr)'
'modify var seasonal'

'set sdfwrite -flt ./example_${var}.nc'
'sdfwrite var'


'set sdfwrite -flt ./${var}_lon.nc'
'set z 1'
'set t 1'

'define lon1 = lon'
'sdfwrite lon1'


'set sdfwrite -flt ./${var}_lat.nc'
'set z 1'
'set t 1'

'define lat1 = lat'
'sdfwrite lat1'


'quit'

EOF

    grads -pcb tmp.gs
    \rm tmp.gs

    ncks -h -A ${var}_lon.nc ${var}.nc 
    ncks -h -A ${var}_lat.nc ${var}.nc 
    \rm ${var}_lon.nc ${var}_lat.nc


#---------------------------------- with 1D lon & lat

    cat > tmp.gs << EOF 
'reinit'

'xdfopen ./example.ctl'


'set x 1 360'
'set y 1 180'
'set z 1 50'
'set t 1 12'

'define var =  ave(${var},t+${ns},t=${ne},1yr)'
'modify var seasonal'

'set sdfwrite -flt ./${var}.nc'
'sdfwrite var'

'quit'

EOF

    grads -pcb tmp.gs
    \rm tmp.gs

#----------------------------------

exit
