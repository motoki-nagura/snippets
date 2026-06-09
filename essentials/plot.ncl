;================================================;
;  
;================================================;

 external EX01 "/work/code/sub/ncl_WRAPIT/eff_DOF_COR.so"
; external EX02 "/work/code/sub/ncl_WRAPIT/sig_cor.so"

begin

;=================================================;
; open file and read in data
;=================================================;
  f1   = addfile("XXX.nc","r")
  data = f1->data

  printVarSummary(data10)


;=================================================;
;  Name dimensions and assign coordinate variables
;=================================================;
  data!0    = "time"
  data!1    = "lat"
  data!2    = "lon"

  data1 = data(lon|:,lat|:,time|:)

  data1&lon  = lon
  data1&lat  = lat
  data1&time = time

  data1@long_name = ""

  copy_VarCoords(var_from,var_to)


;=================================================;
;   replace values larger/smaller than thres with rmiss 
;=================================================;

; Assume x is a multi-dimensional array with a _FillValue attribute 
; (x@_FillValue) set. Assume that all values less than 100 are to be "masked":

    x = mask(x, x.lt.100, False) 

;
; lengthy way
;

  thres = 1.
  rmiss = -1e10
  x = input_array

  if (any(x.lt.thres)) then
       x1D          = ndtooned (x)                ; convert to 1D array
       i_thres      = ind(x1D.lt.thres)           ; all indices x1D < thres
       x1D(i_thres) = rmiss                       ; set all  array syntax
       x            = onedtond(x1D, dimsizes(x))  ; return to the original array
       delete (x1D)                               ; x1D no longer needed
       delete (i_thres)                           ; i_thres no longer needed
   end if

  input_array := x
  input_array@_FillValue = rmiss
  delete (x)


;=================================================;
;   get year/month/day etc from timestamp
;=================================================;

  utc_date = cd_calendar(time, 0)

  year   = tointeger(utc_date(:,0))
  month  = tointeger(utc_date(:,1))
  day    = tointeger(utc_date(:,2))
  hour   = tointeger(utc_date(:,3))
  minute = tointeger(utc_date(:,4))
  second = utc_date(:,5)


;=================================================;
;   statistical analysis
;=================================================;

  effdof = EX01::eff_dof_cor (dimsizes(var1),var1,var2,var1@_FillValue)
;  sig_cor = EX02::sig_cor (0.95, edof)

  ;  neutral regression
  varix = variance(var1)
  variy = variance(var2)
  cova  = escovc(var1,var2)
  nreg = (cova/abs(cova)) * sqrt( variy /varix )

  ;  confidence interval for correlation coefficient

  alpha = 0.99
  alpha1 = (1.-alpha)/2.
  t = cdft_t(alpha1, effdof-2)
  sig_cor = sqrt( t^2 / ((effdof-2.) + t^2))

  ;  confidence interval for normal regression coefficient
  b = regCoef(x,y)
  berr = regr_err (x,y,b,b@yintercept,edof,0.95)

  ;  confidence interval for neutral regression

  corr = escorc (var1, var2)
  conf_nreg = nreg * ( 2e0 *sqrt( (1e0-corr^2) /effdof ) )

;=================================================;
;   write out to a netcdf file
;=================================================;

  system("/bin/rm -f out.nc")    ; remove any pre-existing file

  ncdf = addfile("out.nc" ,"c")  ; open output netCDF file

  ncdf->var = data


;=================================================;
;   write out to a text file
;=================================================;

  tmp := (/"line 1","line 2","line 3"/)

  asciiwrite( "out.txt", tmp )


;=================================================
;   time labels
;=================================================

  y0 = 1979
  y1 = 2025

  time_labels1 = new(y1-y0+1, double)
  time_labels2 = new(y1-y0+1, string)

  do iy = 0, y1-y0
    time_labels1(iy) = cd_inv_calendar(y0+iy,1,1,0,0,0,time@units,0)
    time_labels2(iy) = tostring(y0+iy)
  end do


;=================================================;
;   plot settings
;=================================================;
  wks  = gsn_open_wks("pdf","fig")

  ; --- general settings ---
  res                 = True
  res @gsnDraw        = False
  res @gsnFrame       = False

  ; --- width and height ---
  res @vpWidthF  = 0.60
  res @vpHeightF = 0.60

  ; --- font heights ---
  res @tiMainFontHeightF    = 2.0e-2
  res @tiXAxisFontHeightF   = 2.0e-2
  res @tiYAxisFontHeightF   = 2.0e-2
  res @tmXBLabelFontHeightF = 2.0e-2
  res @tmYLLabelFontHeightF = 2.0e-2

  ; --- axis range ---
  res @trXMinF = -5.
  res @trXMaxF =  5.

  res @trYMinF = 0.
  res @trYMaxF = 100.

;;   res @mpMinLonF = 30.
;;   res @mpMaxLonF = 110.
;;   res @mpMinLatF = -30.
;;   res @mpMaxLatF = 30.
;;   res @gsnAddCyclic = False
;;   res @mpCenterLonF = 90.

;;  res @gsnYAxisIrregular2Linear = True
;;  res @trYReverse = True

  ; --- axis ticks ---
  res @tmXBMode    = "Explicit"
  res @tmXBValues  = ispan(50,70,4)
  res @tmXBLabels  = tostring(ispan(50,70,4))+"~S~o~N~E"

  res @tmXBMinorOn       = True
  res @tmXBMinorValues   = ispan(50,70,1)
  res @tmXBMinorPerMajor = 4

  res @tmXBMajorLengthF        = 1e-2  ;  length of tick marks
  res @tmXBMajorOutwardLengthF = 1e-2

  res @tmYLMode         = "Manual"
  res @tmYLTickStartF   = 0.
  res @tmYLTickEndF     = 200.
  res @tmYLTickSpacingF = 50.

  res @tmYLPrecision    = 1

;  res @tmYLFormat = "^se"   ; in the format of "x10^i"

  ; --- titles ---
  res @tiMainString  = "This is the main title"
  res @tiXAxisString = "This is the X Axis title"
  res @tiYAxisString = "This is the Y Axis title"

;=================================================;
;   contour plot
;=================================================;

  ; --- label bar ---
;  res @lbLabelBarOn     = False   ; turn off individual cb's

  res @lbOrientation      = "Vertical"
  res @pmLabelBarWidthF   = 0.05
  res @pmLabelBarOrthogonalPosF = 0.015

  res @lbLabelFontHeightF = 2.0e-2

  res @lbTitleOn          = True
  res @lbTitleString      = "label bar title"
  res @lbTitleFontHeightF = 2.0e-2
  res @lbTitlePosition    = "Top"

  ; --- contour levels ---
  res @cnLevelSelectionMode  = "ManualLevels"
  res @cnMinLevelValF        = -20.
  res @cnMaxLevelValF        =  20.
  res @cnLevelSpacingF       =   2.

  res @cnInfoLabelOn        = False
  res @cnFillOn             = True
  res @cnLinesOn            = False
  res @cnLineLabelsOn       = False
;  res @cnFillMode           = "RasterFill"

;  res @cnLevelSelectionMode = "ExplicitLevels"    			; set explicit contour levels
;  res @cnLevels    = (/ -10.,-8.,-6.,-4.,-2.,-1.,1.,2.,4.,6.,8.,10./)	; set levels
;  res @cnFillColors = (/ 13,23,30,36,41,45,-1,59,63,68,74,81,91/)	; set the colors to be used

  ; --- color table ---
  gsn_define_colormap(wks,"BlWhRe")
  res @cnMissingValFillColor = "gray50"

  ; --- legends ---

  res @pmLegendDisplayMode    = "Always"       ; turn on legend

  res @pmLegendSide           = "Top"          ; Change location of 
  res @pmLegendParallelPosF   = .45            ; move units right
  res @pmLegendOrthogonalPosF = -0.4           ; move units down

  res @pmLegendWidthF         = 0.15           ; Change width and
  res @pmLegendHeightF        = 0.18           ; height of legend.
  res @lgLabelFontHeightF     = .03            ; change font height
;  res @lgTitleOn              = True           ; turn on legend title
;  res @lgTitleString          = "Example"      ; create legend title
;  res @lgTitleFontHeightF     = .025           ; font of legend title
  res @lgPerimOn              = False
  res @xyExplicitLegendLabels = (/"U","V"/)    ; explicit labels
  res @lgItemOrder            = (/2,1,0/)
  
;=================================================;
;   line contour plot
;=================================================;
  res2  = True
  res2 @gsnDraw  = False
  res2 @gsnFrame = False

  res2 @cnInfoLabelOn = False

  ;  contour levels
  res2 @cnLevelSelectionMode = "ManualLevels"
  res2 @cnMinLevelValF       = -5
  res2 @cnMaxLevelValF       =  5
  res2 @cnLevelSpacingF      =  1.

  res2 @gsnContourNegLineDashPattern = 1
  res2 @gsnContourZeroLineThicknessF = 2
  res2 @gsnContourLineThicknessesScale = 2.0

  res2 @cnLabelMasking             = True
  res2 @cnLineLabelBackgroundColor = -1
  res2 @cnLineLabelFontHeightF     = 1.5e-2 
  res2 @cnLineLabelDensityF        = 1.0
  res2 @cnLineLabelInterval        = 1
 
;  res2 @cnMonoLevelFlag = True
;  res2 @cnLevelFlags    = "LineOnly"

;=================================================;
;   vector plots
;=================================================;

  res @gsnScalarContour     = True

  res @vcRefMagnitudeF           = 4.0
  res @vcRefLengthF              = 0.045
  res @vcRefAnnoOrthogonalPosF   = -1.0
  res @vcRefAnnoArrowLineColor   = "black"
  res @vcRefAnnoArrowUseVecColor = False

  res @vcGlyphStyle            = "CurlyVector"
;  res @vcLineArrowColor        = "white"
  res @vcLineArrowThicknessF   = 2.0
  res @vcVectorDrawOrder       = "PostDraw"

  res@vcLineArrowHeadMinSizeF = 0.01
  res@vcLineArrowHeadMaxSizeF = 0.01

  res @vcRefAnnoString1 = "xxx"

;=================================================;
;  line plot
;=================================================;

  ; --- general settings ---
  res  = True
  res @gsnDraw  = False
  res @gsnFrame = False

  ; --- width and height ---
  res @vpWidthF  = 0.60
  res @vpHeightF = 0.60

  ; --- font heights ---
  res @tiMainFontHeightF    = 2.0e-2
  res @tiXAxisFontHeightF   = 2.0e-2
  res @tiYAxisFontHeightF   = 2.0e-2
  res @tmXBLabelFontHeightF = 2.0e-2
  res @tmYLLabelFontHeightF = 2.0e-2

  ; --- axis range ---
  res @trXMinF = -5.
  res @trXMaxF =  5.

  res @trYMinF = 0.
  res @trYMaxF = 100.

  res @gsnYAxisIrregular2Linear = True
  res @trYReverse = True

  ; --- line pattern ---
  res @xyDashPattern = 0

  new_indexes = NhlNewDashPattern(wks,"$$____$$____$$____$$____$$____")
  ; res_line @xyDashPattern = new_indexes

  res @xyLineThicknesses = (/2.0,2.0,2.0/)
  res @xyLineColors      = (/"black","blue","red"/)
 
  res @xyMarkLineMode = "MarkLines"    ; Markers *and* lines
  res @xyMarkers      = (/6,11,16/)    ; 3 different markers
  res @xyMarkerColors = (/"blue","red","green"/)  ; 3 different colors

;=================================================;
;  make plots
;=================================================;
  plots = new(3, graphic)

  plots(0) = gsn_csm_contour (wks,data1,res)
  ;    contours

  plots(0) = gsn_csm_contour_map_ce (wks,data1,res)
  ;    contours on a world map

  plots(1) = gsn_csm_vector_map(wks,uvel,vvel,res)
  ;    vectors on a world map

  plots(1) = gsn_csm_vector_scalar_map_ce(wks,uvel,vvel,sst,res)
  ;    vectors and contours on a world map

  plots(0) = gsn_csm_xy (wks, time, data1, res)
  ;    xy plots

  overlay(plots(0), plot0)
  ;    overlay

;=================================================;
;   panels
;=================================================;
  resP = True

  ; --- spaces between panels ---
  resP @gsnPanelXWhiteSpacePercent = 8.0
  resP @gsnPanelYWhiteSpacePercent = 8.0

  resP @gsnPanelTop    = 1.0
  resP @gsnPanelBottom = 0.0
  resP @gsnPanelRight  = 1.0
  resP @gsnPanelLeft   = 0.0

  ; --- labels ---
  resP @gsnPanelFigureStrings= "("+(/"a","b"/)+")"
  resP @gsnPanelFigureStringsFontHeightF = 0.02
  resP @amJust   = "TopLeft"

  ; --- color scale ---
  resP @gsnPanelLabelBar = True
  resP @lbOrientation    = "vertical"

  resP @lbTitleOn        =  True
  resP @lbTitleString    = "N m~S~-2~N~"
  resP @lbTitlePosition  = "Top"
  resP @lbTitleFontHeightF = 1.5e-2
  resP @lbTitleDirection = "Across"

  resP @lbJustification = "topleft"
  resP @lbLeftMarginF   = 0.0
  resP @lbTopMarginF    = 0.1
  resP @lbBoxMinorExtentF = 0.2

  resP @lbLabelStride = 5
  resP @lbLabelFontHeightF = 2e-2

;=================================================;
;  calculations
;=================================================;

  char = sprintf("%6.2f", results)  ; number to character

;=================================================
;   texts
;==================================================
  txres = True
  txres@txFontHeightF = 0.03

  sigma_theta = "~F33~s~B~q~N~~F21~"

  ubar = "u~H-16~~V25~_~V-25~"
  vbar = "v~H-16~~V25~_~V-25~"

  gsn_text_ndc(wks,txt,0.7,0.1,txres)

;=================================================
;   draw maps
;==================================================
  gsn_panel(wks,plots,(/2,1/),resP)

  end

