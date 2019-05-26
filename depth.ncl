;*************************************************
; NCL  script
;*************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"


begin
;************************************************
; variable and file handling
;************************************************

; Make a list of all files we are interested in
   DATADir = "./"
  FILES = systemfunc (" ls -1 " + DATADir + "wrfout_d02_2* ")
  numFILES = dimsizes(FILES)
  print("numFILES = " + numFILES)
  print(FILES)
  print (" ")



  wks  = gsn_open_wks("png","depth")               ; specifies plot



; Now set this color map.
  gsn_define_colormap(wks,"MPL_s3pcpn_l")

; Interval to loop through the data
  timeINT = 13

ifil = 0
a = addfile(FILES(ifil)+".nc","r")


;                START  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


ip_lats = (/ 37.1/)
ip_lons = (/ 22.5/) 
ip = 0
loc = wrf_user_latlon_to_ij(a, ip_lats(ip), ip_lons(ip))
x_start=loc(1)
 y_start=loc(0)
delete(loc)


;		END  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ip_lats = (/39.2/)
ip_lons = (/ 25.15/) 
ip = 0
loc = wrf_user_latlon_to_ij(a, ip_lats(ip), ip_lons(ip))
x_end=loc(1)
 y_end=loc(0)
delete(loc)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



lat2d  = a->XLAT(0,y_start:y_end,x_start:x_end)     
  lon2d  = a->XLONG(0,y_start:y_end,x_start:x_end)   
Times = a->Times

Time_1 = wrf_times_c( Times, 1 )
  
   Time_1@units = "hours since 1901-01-01 00:00:00"



 ;
 ; Convert to UTC time.
 ;
   utc_date = cd_calendar(Time_1, 0)


;
 ; Store return information into more meaningful variables.
 ;
   inyear   = tointeger(utc_date(:,0))    ; Convert to integer for
   inmonth  = tointeger(utc_date(:,1))    ; use sprinti 
   inday    = tointeger(utc_date(:,2))
   inhour   = tointeger(utc_date(:,3))
   inminute = tointeger(utc_date(:,4))
   insecond = utc_date(:,5)
 ;
 ; Write out strings in the format "hhZ dd mmm yyyy".
 ;

 indow = day_of_week(inyear,inmonth,inday)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FirstTime = True
do ifil = 0, numFILES-1      ; BIG FILES LOOP
   a = addfile(FILES(ifil)+".nc","r")
   print("Working on FILE: " +FILES(ifil) )
 ;i = NhlNewColor(wks,0.8,0.8,0.8)                 ; add gray to colormap 
   ; What times and how many time steps are in this data set?
     times  = wrf_user_list_times(a)  ; get times in the file
     ntimes = dimsizes(times)         ; number of times in the file



Times = a->Times

Time_1 = wrf_times_c( Times, 1 )      ; "hours since 1901-01-01 00:00:00"    (double)

 month_abbr = (/"","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep", \
                    "Oct","Nov","Dec"/)

 day_abbr = (/"Sun","Mon","Tue","Wed","Thu","Fri","Sat"/)

  
   Time_1@units = "hours since 1901-01-01 00:00:00"



 ;
 ; Convert to UTC time.
 ;
   utc_date = cd_calendar(Time_1, 0)


;
 ; Store return information into more meaningful variables.
 ;
   year   = tointeger(utc_date(:,0))    ; Convert to integer for
   month  = tointeger(utc_date(:,1))    ; use sprinti 
   day    = tointeger(utc_date(:,2))
   hour   = tointeger(utc_date(:,3))
   minute = tointeger(utc_date(:,4))
   second = utc_date(:,5)
 ;
 ; Write out strings in the format "hhZ dd mmm yyyy".
 ;

 dow = day_of_week(year,month,day)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  do it = 0,ntimes-1,timeINT        ; TIME LOOP

    print("Working on time: " + times(it) )

   

pressure = 850

    tc = wrf_user_getvar(a,"tc",it)        ; T in C
    u  = wrf_user_getvar(a,"ua",it)        ; u averaged to mass points
    v  = wrf_user_getvar(a,"va",it)        ; v averaged to mass points
    p  = wrf_user_getvar(a, "pressure",it) ; pressure is our vertical coordinate
    z  = wrf_user_getvar(a, "z",it)        ; grid point height
    rh = wrf_user_getvar(a,"rh",it)        ; relative humidity



      tc_plane1 = wrf_user_getvar(a,"SNOWH",it)
      tc_plane=tc_plane1(y_start:y_end,x_start:x_end)
      z_plane  = wrf_user_intrp3d( z,p,"h",pressure,0.,False)
      rh_plane = wrf_user_intrp3d(rh,p,"h",pressure,0.,False)
      u_plane  = wrf_user_intrp3d( u,p,"h",pressure,0.,False)
      v_plane  = wrf_user_intrp3d( v,p,"h",pressure,0.,False)

spd     = (u_plane*u_plane + v_plane*v_plane)^(0.5) ; m/sec
lat = wrf_user_getvar(a,"XLAT",it)
lon= wrf_user_getvar(a,"XLONG",it)

landmask=wrf_user_getvar(a,"LANDMASK",it)

 
    tc_plane@description = "Snow Depth"
    tc_plane@units = "cm"
    landmask@units = ""
    landmask@description = ""
      u_plane@units = ""
     v_plane@units = ""
  u_plane@description = ""
 v_plane@description = ""
       ; Wind Vectors and Speed
       
         
lat = wrf_user_getvar(a,"XLAT",it)
lon= wrf_user_getvar(a,"XLONG",it)

   minlat=min(lat2d)
     maxlat=max(lat2d)
     minlon=min(lon2d)
     maxlon=max(lon2d)
     

slp = wrf_user_getvar(a,"slp",it)  ; slp
      wrf_smooth_2d( slp, 4 )            ; smooth slp

     slp@units = ""
    slp@description = ""

  nscan = 2000             ; usually *much* fewer
  eps   = 0.001            ; variable depended
  gtype = False            ; "gendat" does not generate cyclic fields
  guess = 0                ; use zonal means
  relc  = 0.6              ; standard relaxation coef
  opt   = 0


    tc_plane=tc_plane*100
   ;wrf_smooth_2d( tc_plane, 2 )


;;;;;;line_Countours every 5C

 resZ                 = True                    ; plot mods desired
 resZ@gsnDraw         = False                   ; don't draw yet
 resZ@gsnFrame        = False                   ; don't advance frame yet
 resZ@cnFillOn        = True  

  resZ@cnFillColors(0)    = -1
  resZ@lbTitleString            = ""
  resZ@lbTitleDirection         = "Down"
  resZ@lbTitleJust              = "CenterRight"
  resZ@lbTitlePosition          = "Right"
  resZ@lbTitleOffsetF           = 0.07
;resC@InitTime  = False
;resC@ValidTime  = True
  resZ@lbOrientation            = "Vertical"
  resZ@pmLabelBarSide           = "Right"
  resZ@pmLabelBarHeightF        = 0.57
  resZ@pmLabelBarWidthF         = 0.03
  resZ@pmLabelBarOrthogonalPosF = 0.02
  resZ@lbBoxMinorExtentF        = 0.2      

resZ@gsnSpreadColors  = True  
resZ@cnLinesOn        = False
 ;resZ@gsnContourZeroLineThicknessF = 3.5
;resZ@cnMonoLineColor = False
 resZ@cnLevelSelectionMode = "ManualLevels"  ; manual levels
  resZ@cnMinLevelValF       	= 1            ; min lev
  resZ@cnMaxLevelValF	        =  100            ; max lev
  resZ@cnLevelSpacingF           = 1               ; spacing
 ;resZ@gsnContourNegLineDashPattern = 1       ; sets negative contours to dash pattern 1  
 ;resZ@gsnContourLineThicknessesScale = 6.5
  resZ@gsnMaximize      = True
  resZ@sfYArray = lat2d
  resZ@sfXArray = lon2d  
 ; resZ@cnLineLabelInterval        = 1 
  ;resZ@cnLineLabelsOn             = True  
   ;resZ@gsnContourNegLineDashPattern = 2
  ;resZ@gsnContourPosLineDashPattern = 3          ; turn on line labels
  ;resZ@cnLineLabelPlacementMode = "random"
  ;resZ@cnLineLabelBackgroundColor = "white"       ; white bckgrnd around label

  resZ@cnInfoLabelOn    = False  


  plot = gsn_csm_contour(wks,tc_plane,resZ)   ; contour the variabl




;;;;SLP

    
  resL                  = True                      ; plot mods desired
  
  resL@cnFillOn         = False                  ; turn on color

 resL@cnFillOpacityF = 0.9
resL@cnLowLabelsOn = True
  resL@cnLineLabelsOn   = True                     ; no contour line labels
  resL@cnInfoLabelOn    = False                     ; no info label
  resL@gsnDraw          = False                     ; don't draw yet
  resL@gsnFrame         = False                     ; don't advance yet
  resL@cnLinesOn        = True              ; no contour lines
  ;resL@cnHighLabelsOn = True
  ;resL@cnLowLabelsOn = True
  resL@gsnContourLineThicknessesScale = 3.4
  resL@gsnMaximize      = True
  resL@sfYArray = lat2d
  resL@sfXArray = lon2d  
  resL@cnLineLabelBackgroundColor = -1
  resL@cnLevelSelectionMode 	= "ManualLevels"  ; manually set cont levels
  resL@cnMinLevelValF       	= 985             ; min lev
  resL@cnMaxLevelValF	        = 1074            ; max lev
  resL@cnLevelSpacingF           = 1              ; spacing
  resL@cnLineColor       = "Black"
  resL@cnLowLabelFontHeightF = 0.075 
  resL@cnLowLabelBackgroundColor = -1
;  resL@cnHighLabelFontHeightF = 0.018 
 ; resL@cnHighLabelBackgroundColor = -1 
 ; resL@cnHighLabelFontHeightF = 0.018 
 ; resL@cnHighLabelBackgroundColor = -1
  resL@cnLineLabelInterval        = 1 
  plotL = gsn_csm_contour(wks,slp,resL)   ; contour the variabl












;;;;;Map
 resM                             = True
  
  resM@mpOutlineBoundarySets       = "National"   ; turn on country boundaries
  resM@mpGeophysicalLineColor      = "Navy"       ; color of cont. outlines
  resM@mpGeophysicalLineThicknessF = 1.5          ; thickness of outlines
 resM@mpMinLatF          = minlat
 resM@mpMinLonF          = minlon
 resM@mpMaxLatF          = maxlat      
 resM@mpMaxLonF          = maxlon
;resM@vpWidthF        = 0.6          ; Force image to fill screen.
 ;resM@vpHeightF       = 0.5
  resM@gsnMaximize      = True
  resM@gsnDraw             = False                            ; do not draw plot yet
  resM@gsnFrame            = False                            ; do not advance frame yet

  resM@mpFillOn                    = True       ; turn off gray fill

  resM@tmXBLabelFontHeightF = 0.014         ; change maj lat tm spacing
  resM@tmYLLabelFontHeightF = 0.010
  resM@tmXBMajorLengthF     = 0.005          ; change the tickmark length
  resM@mpGridAndLimbOn      = True          ; default is every 15 deg
  resM@mpGridSpacingF       = 30            ; change to match labels

  resM@mpGridAndLimbOn      = True          ; default is every 15 deg
  resM@mpGridLatSpacingF      = 1.0
  resM@mpGridLonSpacingF      = 1.0
  resM@pmTickMarkDisplayMode = "Always"         ; turn on tickmarks
  resM@mpLandFillColor        = "tan4"
  resM@mpOceanFillColor       = "steelblue4"
  resM@mpInlandWaterFillColor = "steelblue4"

  resM@mpGridLineDashPattern  = 2
  resM@mpOutlineOn            = True
  resM@mpPerimOn              = False
  resM@mpDataBaseVersion = "HighRes"            ; choose higher resolution
  resM@mpDataSetName = "Earth..4"                 ; choose most recent boundaries

  plotM = gsn_csm_map_ce(wks,resM)                 ; draw map




;---Change map to a satellite projection
  setvalues plotM
   "mpProjection" : "Mercator"  
    "mpLimitMode"  : "LatLon"
    "mpMinLatF"    : minlat
    "mpMinLonF"    : minlon
    "mpMaxLatF"    : maxlat      
    "mpMaxLonF"    : maxlon
  end setvalues


       ;overlay(plotM, plotL)
       overlay(plotM,plot)
      
       

anno_title = "Antimeteo.gr~C~"
anno_valid =   "valid:" +" "+day_abbr(dow)+","+sprinti("%0.2i ", day)+ \
month_abbr(month)+sprinti("%0.4i", year)+" "+ sprinti("%0.2iZ ", hour) 
 
anno_init =   "init:" +" "+day_abbr(indow)+","+sprinti("%0.2i ", inday)+ \
month_abbr(inmonth)+sprinti("%0.4i", inyear)+" "+ sprinti("%0.2iZ ", inhour)  
   txres               = True         ; additional info
   txres@txFontHeightF = 0.010        ; size of meta data
   txres@txJust        = "CenterRight"
   gsn_text_ndc  (wks,"Athens Storm Prediction System (ASPS)" \
                     ,0.99 , 0.115, txres)
                                       ; note when plotted
txres@txJust        = "CenterLeft"
   gsn_text_ndc  (wks,anno_title ,0.10,0.115, txres)

  
   txres@txFont                = "helvetica-bold"
   txres@txFontHeightF = 0.013    
   txres@txJust        = "CenterLeft"
   gsn_text_ndc  (wks,anno_valid ,0.765,0.9, txres)

  delete(txres)
   

   txres               = True  

   txres@txFont                = "helvetica-bold"
   txres@txFontHeightF = 0.013    
   txres@txJust        = "CenterLeft"
   gsn_text_ndc  (wks,anno_init ,0.10,0.9, txres)

  delete(txres)



      draw(plotM)
      frame(wks)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   end do  ;       end of the time loop
end do  ;       END IF BIG FILE LOOP

system("convert -trim  depth*.png depth.jpg")
  system("rm -f depth*00*.png")
end




