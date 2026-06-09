#================================================
#  Sample Script for Pyngl
#================================================

import numpy as np
import Ngl
import Nio


#=================================================
# open file and read in netcdf data
#=================================================
f1 = Nio.open_file("XXX.nc","r")
data = f1.variables["var"]

print('shape = ',np.shape(data))
print(data)    #  show summary information (= printVarSummary)


#=================================================
#   replace values larger/smaller than thres with rmiss 
#=================================================

var = np.array(var)   #  convert to numpy array

rmiss = -1e10
threshold = 0.

i = var < threshold

var[i] = rmiss

#=================================================
#   write out to a text file
#=================================================
#
#  tmp := (/"line 1","line 2","line 3"/)
#
#  asciiwrite( "out.txt", tmp )

#=================================================
#   work station 
#=================================================

wkres = Ngl.Resources()
wkres.wkColorMap = "default"

wks_type = "pdf"

wks = Ngl.open_wks(wks_type,"fig",wkres)

#=================================================
#   basic plot settings
#=================================================
#   --- general settings ---
res = Ngl.Resources()
res.nglDraw  = False
res.nglFrame = False

#   --- width, height and position ---
res.vpXF      = 0.1    # Change the size and location of the
res.vpYF      = 0.9    # plot on the viewport.
res.vpWidthF  = 0.7
res.vpHeightF = 0.7

#   --- font heights ---
res.tiMainFontHeightF    = 2.4e-2
res.tiXAxisFontHeightF   = 2.4e-2
res.tiYAxisFontHeightF   = 2.4e-2
res.xyLineLabelFontHeightF = 0.02

#   --- axis range ---
res.trXMinF   = -5.
res.trXMaxF   =  5.
res.trYMinF   =  0.
res.trYMaxF   = 100.

res.mpLimitMode = "LatLon"
res.mpMinLonF   = 30.
res.mpMaxLonF   = 110.
res.mpMinLatF   = -30.
res.mpMaxLatF   = 30.
#;;   res @gsnAddCyclic = False
res.mpCenterLonF = 90.

res.nglYAxisType = "LinearAxis"
res.trYReverse = True

#  --- axis ticks ---
res.tmXBMode    = "Explicit"
res.tmXBValues  = np.arrange(50.,70.,5.)
#res.tmXBLabels  = str(np.arange(50,70,4))+"~S~o~N~E"

res.tmXBMinorOn       = True
res.tmXBMinorPerMajor = 4
res.tmXBMinorValues   = np.arrange(50,70,1)

res.tmYLMajorLengthF  = 0.015  #  length of tick marks
res.tmXBMajorOutwardLengthF = 1e-2

res.tmYLMode         = "Manual"
res.tmYLTickStartF   = -2.0
res.tmYLTickEndF     =  3.0
res.tmYLTickSpacingF =  1.0

res.tmYLPrecision    = 1

#  res @tmYLFormat = "#+^se"   ; don't use "e" symbol, always show +/-

#  --- titles ---
res.tiMainString  = "Main Title"
res.tiXAxisString = "X Axis"
res.tiYAxisString = "Y Axis"

res.tiMainFont    = "Helvetica" # Font for title
res.tiXAxisFont   = "Helvetica" # Font for X axis label
res.tiYAxisFont   = "Helvetica" # Font for Y axis label

#=================================================
#   contour plot
#=================================================

#  ; --- label bar ---
resllbLabelBarOn     = False   # turn off individual cb's

res.lbOrientation        = "Vertical"
#  res @pmLabelBarWidthF   = 0.05
#  res @pmLabelBarOrthogonalPosF = 0.015

res.lbLabelFontHeightF = 2.0e-2

res.lbTitleOn          = True
res.lbTitleString      = "label bar title"
res.lbTitleFontHeightF = 2.0e-2
res.lbTitlePosition    = "Top"

#   --- contour levels ---
res.cnLevelSelectionMode = "ManualLevels"
res.cnMinLevelValF       = -20.
res.cnMaxLevelValF       =  20.
res.cnLevelSpacingF      =   2.

res.cnInfoLabelOn  = False
res.cnFillOn       = True
res.cnLinesOn      = False
res.cnLineLabelsOn = False

res.cnFillMode     = "RasterFill"

res.cnLevelSelectionMode = "ExplicitLevels" # Define own levels.
res.cnLevels             = np.arange(985.,1046.,5.)
res.cnFillColors = (/ 13,23,30,36,41,45,-1,59,63,68,74,81,91/)	# set the colors to be used

#  --- set missing value and axis ---
res.sfMissingValueV = temp._FillValue[0]
res.sfXArray        = lon[:]
res.sfYArray        = lat[:]

#   --- color table ---
res.cnFillPalette   = "BlWhRe"
res.cnFillPalette   = "matlab_jet"

res.cnMissingValFillColor = "gray70"

#   --- legends ---
res.pmLegendDisplayMode    = "Always"       # turn on legend

res.pmLegendSide           = "Top"          # Change location of 
res.pmLegendParallelPosF   = .45            # move units right
res.pmLegendOrthogonalPosF = -0.4           # move units down

res.pmLegendWidthF         = 0.15           # Change width and
res.pmLegendHeightF        = 0.18           # height of legend.
res.lgLabelFontHeightF     = .03            # change font height
#;  res @lgTitleOn              = True           ; turn on legend title
#;  res @lgTitleString          = "Example"      ; create legend title
#;  res @lgTitleFontHeightF     = .025           ; font of legend title
res.lgPerimOn              = False
res.xyExplicitLegendLabels = ["U","V"]      # explicit labels
#  res @lgItemOrder            = (/2,1,0/)

#=================================================
#   line contour plot
#=================================================
res2 = Ngl.Resources()
res2.nglDraw  = False
res2.nglFrame = False

res2.cnInfoLabelOn  = False

#    contour levels
res.cnLevelSelectionMode = "ManualLevels"
res.cnMinLevelValF       = -20.
res.cnMaxLevelValF       =  20.
res.cnLevelSpacingF      =   2.

#  res2 @gsnContourNegLineDashPattern = 1
#  res2 @gsnContourZeroLineThicknessF = 2
#  res2 @gsnContourLineThicknessesScale = 2.0
#
#  res2 @cnLabelMasking             = True
#  res2 @cnLineLabelBackgroundColor = -1
#  res2 @cnLineLabelFontHeightF     = 1.5e-2 
res2.cnLineLabelDensityF        = 1.0
res2.cnLineLabelInterval        = 1

#=================================================
#   vector plots
#=================================================
#
#  res @gsnScalarContour     = True
#
res.vcRefMagnitudeF  = 20.0
res.vcRefLengthF     = 0.045
res.vcRefAnnoOrthogonalPosF   = -1.0
res.vcRefAnnoArrowLineColor   = "black"
#  res @vcRefAnnoArrowUseVecColor = False

res.vcGlyphStyle            = "LineArrow"
# res.vcLineArrowColor        = "black"
res.vcLineArrowThicknessF   = 2.0
# res @vcVectorDrawOrder       = "PostDraw"

# res@vcLineArrowHeadMinSizeF = 0.01
# res@vcLineArrowHeadMaxSizeF = 0.01

res.vcRefAnnoString2 = "xxx"

#=================================================
#  line plot
#=================================================

#   --- general settings ---
res = Ngl.Resources()
res.nglDraw  = False
res.nglFrame = False

#   --- width, height and position ---
res.vpXF      = 0.1    # Change the size and location of the
res.vpYF      = 0.9    # plot on the viewport.
res.vpWidthF  = 0.7
res.vpHeightF = 0.7

#   --- font heights ---
res.tiMainFontHeightF    = 2.4e-2
res.tiXAxisFontHeightF   = 2.4e-2
res.tiYAxisFontHeightF   = 2.4e-2
res.xyLineLabelFontHeightF = 0.02

#   --- axis range ---
res.trXMinF   = -5.
res.trXMaxF   =  5.
res.trYMinF   =  0.
res.trYMaxF   = 100.

#  res @gsnYAxisIrregular2Linear = True
#  res @trYReverse = True

#   --- line pattern ---
res.xyDashPattern    = [16,0]   #   (dash, solid)
res.xyLineThicknessF = 2.0      # default is 1.

#  pattern = "$$___$$___$$___$$___$$___$$___"
#  res.xyDashPattern    = Ngl.new_dash_pattern(wks,pattern)

res.xyLineThicknesses   = [1.,2.,5.]    # Define line thicknesses
                                              # (1.0 is the default).
res.xyLineColors           = [107,24]    # Set the line colors.

res.xyMarkLineModes = ["Lines","Markers","MarkLines"]
res.xyMarkers       = [0,1,3]     # (none, dot, asterisk)
res.xyMarkerColor   = 107         # Marker color
res.xyMarkerSizeF   = 0.03        # Marker size (default is 0.01)

#=================================================
#  make plots
#=================================================

plots = []

plots.append( Ngl.contour(wks,data1,res) )
#      contours

plots.append( Ngl.contour_map(wks,data,res) )
#      contours on a map

plots.append( Ngl.vector(wks,ua,va,res) )
#       vector plot

#  plotss(1) = gsn_csm_vector_scalar_map_ce(wks,uvel,vvel,sst,res)
#  ;    vectors on a world map

plots.append( Ngl.vector_scalar(wks,ua,va,tempa,res) )
#       vector and contour

plots.append( Ngl.xy(wks,x[:],y[:],res) )
#       xy plot

plot  = Ngl.xy(wks,x1[:],y1[:],res)
plot1 = Ngl.xy(wks,x2[:],y2[:],res)
Ngl.overlay(plot,plot1)
#       overlay (do not use .append)

#=================================================
#   panels
#=================================================
resP = Ngl.Resources()

#   --- spaces between panels ---
resP.nglPanelXWhiteSpacePercent = 8.0
resP.nglPanelYWhiteSpacePercent = 8.0

resP.nglPanelTop    = 1.0
resP.nglPanelBottom = 0.0
resP.nglPanelRight  = 1.0
resP.nglPanelLeft   = 0.0

#   --- labels ---
resP.gsnPanelFigureStrings = "("+(/"a","b"/)+")"
resP.gsnPanelFigureStringsFontHeightF = 0.02
#  resP @amJust   = "TopLeft"

#   --- color scale ---
resP.gsnPanelLabelBar = True
#  resP @lbOrientation    = "vertical"

resP.lbTitleOn        =  True
resP.lbTitleString    = "N m~S~-2~N~"
resP.lbTitlePosition  = "Top"
resP.lbTitleFontHeightF = 1.5e-2
resP.lbTitleDirection = "Across"

#  resP @lbJustification = "topleft"
resP.lbLeftMarginF   = 0.0
resP.lbTopMarginF    = 0.1
resP.lbBoxMinorExtentF = 0.2

resP.lbLabelStride = 5
resP.lbLabelFontHeightF = 2e-2

#=================================================
#  calculations
#=================================================
#
#  char = sprintf("%6.2f", results)  ; number to character

#=================================================
#   texts
#=================================================
txres.txFont        = 21                  # Change the default font.
txres.txFontHeightF = 0.03                # Set the font height.

#  sigma_theta = "~F33~s~B~q~N~~F21~"
#
#  ubar = "u~H-16~~V25~_~V-25~"
#  vbar = "v~H-16~~V25~_~V-25~"

Ngl.text(wks,plot,"Function",1.5,2.5,txres) # Label the plot.

#================================================
#   draw maps
#================================================
Ngl.panel(wks,plots,[2,2],resP)
Ngl.draw(plot)

del plots
del res
del data

Ngl.end()

