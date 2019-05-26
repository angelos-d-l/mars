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

; Set some Basic Plot options
  res = True
 


  wks  = gsn_open_wks("png","w")               ; specifies plot



; Now set this color map.
  gsn_define_colormap(wks,"MPL_sstanom")

; Interval to loop through the data
  timeINT = 13


;;;;;;;;;;;;;;
;;;;;;;;;;;;;;Calculate init time
;;;;;;;;;;;;;;
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

    u   = wrf_user_getvar(a,"U10",it)  ; u at 10 m, mass point
    v   = wrf_user_getvar(a,"V10",it)  ; v at 10 m, mass point
    spd = (u*u + v*v)^(0.5)             ; speed in m/sec
lat = wrf_user_getvar(a,"XLAT",it)
lon= wrf_user_getvar(a,"XLONG",it)

landmask=wrf_user_getvar(a,"HGT",it)

  u2=u*1.94386
  v2=v*1.94386
 wup=wrf_user_getvar(a,"WUP_MAX",it)
 wdn=wrf_user_getvar(a,"WDN_MAX",it)
  mcape = wup+wdn
    mcape@description = "Max vertical velocity"
    mcape@units = "m/s"
    landmask@units = ""
    landmask@description = ""
     u@units = ""
     v@units = ""
 u@description = ""
 v@description = ""
       ; Wind Vectors and Speed
       
     lat = wrf_user_getvar(a,"XLAT",it)
     lon= wrf_user_getvar(a,"XLONG",it)


     minlat=min(lat2d)
     maxlat=max(lat2d)
     minlon=min(lon2d)
     maxlon=max(lon2d)
     



  
  ;;;;;;;CONTOURS
  resC                  = True                      ; plot mods desired  
  resC@cnFillOn         = True                      ; turn on color

;---This resource not needed in V6.1.0
  resC@gsnSpreadColors  = True                      ; use full colormap

  resC@cnLineLabelsOn   = False                     ; no contour line labels
  resC@cnInfoLabelOn    = False                     ; no info label
  resC@gsnDraw          = False                     ; don't draw yet
  resC@gsnFrame         = False                     ; don't advance yet
  ;resC@cnLinesOn        = False                ; no contour lines
  
  resC@cnLinesOn = False 
  resC@cnLineColor = "Black"
             
  resC@sfYArray = lat2d
  resC@sfXArray = lon2d  


  resC@lbTitleString            = ""
  resC@lbTitleDirection         = "Down"
  resC@lbTitleJust              = "CenterRight"
  resC@lbTitlePosition          = "Right"
  resC@lbTitleOffsetF           = 0.05
;resC@InitTime  = False
;resC@ValidTime  = True
  resC@lbOrientation            = "Vertical"
  resC@pmLabelBarSide           = "Right"
   resC@pmLabelBarHeightF        = 0.57
  resC@pmLabelBarWidthF         = 0.03
  resC@pmLabelBarOrthogonalPosF = 0.02
  resC@lbBoxMinorExtentF        = 0.2   

  resC@gsnMaximize      = True

  ;resC@cnFillColors(0:1)    = -1 
  resC@cnLevelSelectionMode 	= "ExplicitLevels"  ; manually set cont levels
  resC@cnMinLevelValF       	= 0            ; min lev
  resC@cnMaxLevelValF	        = 70            ; max lev
  resC@cnLevelSpacingF           = 5               ; spacing
  resC@cnFillColors         = (/    2,  10,18 ,26 ,34 ,42 ,50   ,-1   ,-1 ,-1  ,\
                   74,82,90,98,106,110,114,118,122,126,129/)
 
  resC@cnLevels             = (/ -10,-8,-6,-4,-2,-1,-0.5,-0.25, 0.,0.25, \
                                        0.5,1,2,4,6,8,10,15,20,25/)

  plot = gsn_csm_contour(wks,mcape(y_start:y_end,x_start:x_end),resC)   ; contour the variabl







 



;;;;;;line_Countours every 5C

 resZ                 = True                    ; plot mods desired
 resZ@gsnDraw         = False                   ; don't draw yet
 resZ@gsnFrame        = False                   ; don't advance frame yet
 resZ@cnFillOn        = False  

 resZ@gsnContourZeroLineThicknessF = 2.

 resZ@cnLevelSelectionMode = "ManualLevels"  ; manual levels
 resZ@cnMinLevelValF       = 500
 resZ@cnMaxLevelValF       = 3000
 resZ@cnLevelSpacingF      =  500
 resZ@gsnContourNegLineDashPattern = 1       ; sets negative contours to dash pattern 1  
 resZ@gsnContourLineThicknessesScale = 1.5
  resZ@gsnMaximize      = True
  resZ@sfYArray = lat2d
  resZ@sfXArray = lon2d  
  resZ@cnLineColor = "Red4"
  resZ@cnLineLabelsOn             = False         ; turn on line labels

  resZ@cnLineLabelBackgroundColor = "white"       ; white bckgrnd around label

  resZ@cnInfoLabelOn    = False  
  resZ@gsnContourPosLineDashPattern = 0 
  resZ@gsnContourNegLineDashPattern = 2 
  plotZ = gsn_csm_contour(wks,landmask,resZ)   ; contour the variabl




;;;;;Map




;;;;;Map
 resM                             = True
  
  resM@mpOutlineBoundarySets       = "National"   ; turn on country boundaries
  resM@mpGeophysicalLineColor      = "black"       ; color of cont. outlines
  resM@mpGeophysicalLineThicknessF = 2.5          ; thickness of outlines

;resM@vpWidthF        = 0.6          ; Force image to fill screen.
 ;resM@vpHeightF       = 0.5
  resM@gsnMaximize      = True
  resM@gsnDraw             = False                            ; do not draw plot yet
  resM@gsnFrame            = False                            ; do not advance frame yet

  resM@mpFillOn                    = True       ; turn off gray fill

 resM@mpMinLatF          = minlat
 resM@mpMinLonF          = minlon
 resM@mpMaxLatF          = maxlat      
 resM@mpMaxLonF          = maxlon

  resM@mpGridAndLimbOn      = True          ; default is every 15 deg

   ; resM@gsnAddCyclic          = False       ; regional data: not cyclic 

  ;resM@tfDoNDCOverlay        = True        ; set True for non-native mapping
                                          ; will result in faster plotting
  ;resM@mpProjection          = "LambertConformal"
 ; resM@mpLambertParallel1F   = a@TRUELAT1
  ;resM@mpLambertParallel2F   = a@TRUELAT2
;  resM@mpLambertMeridianF    = a@CEN_LON
 ; resM@mpLimitMode           = "Corners"  
 ; resM@mpLeftCornerLatF      = lat2d(0,0)
  ;resM@mpLeftCornerLonF      = lon2d(0,0)
  ;resM@mpRightCornerLatF     = lat2d(nlat-1,mlon-1)
  ;resM@mpRightCornerLonF     = lon2d(nlat-1,mlon-1)
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



       overlay(plotM,plot)
       overlay(plotM,plotZ)

anno_title = "Antimeteo.gr~C~"
anno_valid =   "valid:" +" "+day_abbr(dow)+","+sprinti("%0.2i ", day)+ \
month_abbr(month)+sprinti("%0.4i", year)+" "+ sprinti("%0.2iZ ", hour) 
 
anno_init =   "init:" +" "+day_abbr(indow)+","+sprinti("%0.2i ", inday)+ \
month_abbr(inmonth)+sprinti("%0.4i", inyear)+" "+ sprinti("%0.2iZ ", inhour)  
   txres               = True         ; additional info
   txres@txFontHeightF = 0.010        ; size of meta data
   txres@txJust        = "CenterRight"
   gsn_text_ndc  (wks,"Athens Storm Prediction System (ASPS)~" \
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


system("convert -trim  w*.png w.jpg")
system("rm -f w*00*.png")
end






































