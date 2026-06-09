y0 = -30  &  y1 = 30
x0 =  30  &  x1 = 120

map_set, 0, 0, /isotropic, /continents, /mercator,$
         limit=[y0,x0,y1,x1]
map_continents, /fill_continents,color=0
