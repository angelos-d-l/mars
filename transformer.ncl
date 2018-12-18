begin
; Make a list of all files we are interested in
 DATADir = "./"
 FILES = systemfunc (" ls -1 " + DATADir + "icon_* ")
 numFILES = dimsizes(FILES)
 print("numFILES = " + numFILES)
 print(FILES)
 print (" ")
 a = addfile(FILES(0),"r")

p = a->PRES_P0_2L150_GLL0
str = p@initial_time
st_spl = str_split(str, "/")
mm = st_spl(0)
dd = st_spl(1)
st_spl2 = str_split(st_spl(2)," ")
yyyy = st_spl2(0)
st_spl3 = str_sub_str(st_spl2(1),"(","")
st_spl4 = str_sub_str(st_spl3,")","")
st_spl5 = str_split(st_spl4,":")
hh = st_spl5(0)

CASE             = "X3D"
WPS_IM_root_name = "ICON"+CASE
earth_radius     = 6371.229

FIELD_P          = "PRESSURE"
UNITS_P          = "Pa"
DESC_P           = "3-d pressure"

FIELD_HHL          = "GHT"
UNITS_HHL          = "m"
DESC_HHL           = "3-d geopotential height"

FIELD_TT          = "TT"
UNITS_TT          = "K"
DESC_TT           = "3-d air temperature"

FIELD_HUM          = "SPECHUMD"
UNITS_HUM          = "kg kg-1"
DESC_HUM           = "3-d specific humidity"

FIELD_UU          = "UU"
UNITS_UU          = "m s-1"
DESC_UU          = "3-d wind u-component"

FIELD_VV          = "VV"
UNITS_VV          = "m s-1"
DESC_VV          = "3-d wind v-component"

FIELD_TT2m          = "TT"
UNITS_TT2m          = "K"
DESC_TT2m           = "2-meter air temperature"

FIELD_UU2m          = "UU"
UNITS_UU2m           = "m s-1"
DESC_UU2m           = "2-meter wind u-component"

FIELD_VV2m          = "VV"
UNITS_VV2m          = "m s-1"
DESC_VV2m          = "2-meter wind v-component"

FIELD_PS          = "PSFC"
UNITS_PS          = "Pa"
DESC_PS          = "Surface pressure"

FIELD_PMSL          = "PMSL"
UNITS_PMSL          = "Pa"
DESC_PMSL          = "Mean sea-level pressure"

FIELD_RH          = "RH"
UNITS_RH          = "%"
DESC_RH          = "2-meter relative humidity"



FIELD_SKIN          = "SKINTEMP"
UNITS_SKIN          = "K"
DESC_SKIN          = "Skin temperature"


FIELD_SHGT          = "SOILHGT"
UNITS_SHGT          = "m"
DESC_SHGT          = "Soil height"

FIELD_LND          = "LANDSEA"
UNITS_LND          = "fraction"
DESC_LND          = "Land-sea mask (0=water, 1=land)"

FIELD_SMOIST          = "SM"
UNITS_SMOIST          = "kg m-3"
DESC_SMOIST          = "Soil moisture"

FIELD_ST          = "SOILT"
UNITS_ST          = "K"
DESC_ST          = "Soil temperature"

FIELD_SNOW          = "SNOW"
UNITS_SNOW          = "kg m-2"
DESC_SNOW          = "Water equivalent snow depth"

FIELD_SNOWH          = "SNOWH"
UNITS_SNOWH          = "m"
DESC_SNOWH          = "Physical Snow Depth"

hhl = addfile("./hhl.nc", "r")
hgt = hhl->HGT

hsurf = addfile("./hsurf.nc", "r")
soilhgt = hsurf->HSURF

lnd = addfile("./land.grib2", "r")
land = lnd->LAND_P0_L1_GLL0


do ifil = 0, numFILES-1      ; BIG FILES LOOP
    a = addfile(FILES(ifil),"r")
    p = a->PRES_P0_2L150_GLL0
    ft = p@forecast_time
    tt = a->TMP_P0_2L150_GLL0
    sp = a->SPFH_P0_2L150_GLL0
    uu = a->UGRD_P0_2L150_GLL0
    vv = a->VGRD_P0_2L150_GLL0
    t2m = a->TMP_P0_L103_GLL0
    rh2m = a->RH_P0_L103_GLL0
    snd = a->SNOD_P0_L1_GLL0
    snw = a->SDWE_P0_L1_GLL0
    u2m = a->UGRD_P0_L103_GLL0
    v2m = a->VGRD_P0_L103_GLL0
    ps = a->PRES_P0_L1_GLL0
    pmsl = a->PRMSL_P0_L101_GLL0
    ;ST = a->SOILTMP_P0_L106_GLL0
    ;SM = a->CISOILM_P0_2L106_GLL0
    SKIN = a->TMP_P0_L1_GLL0

    ch = systemfunc("date --date='"+yyyy+mm+dd+" "+hh+":00:00 "+ft+" minutes' +'%H'")
    cy = systemfunc("date --date='"+yyyy+mm+dd+" "+hh+":00:00 "+ft+" minutes' +'%Y'")
    cd = systemfunc("date --date='"+yyyy+mm+dd+" "+hh+":00:00 "+ft+" minutes' +'%d'")
    cm = systemfunc("date --date='"+yyyy+mm+dd+" "+hh+":00:00 "+ft+" minutes' +'%m'")
    print(cd+"-"+cm+"-"+cy+" at "+ch)
    DATE             = cy+"-"+cm+"-"+cd+"_"+ch+":00"
    output_file_name = WPS_IM_root_name + ":" + DATE
    system("rm " + output_file_name)
    opt                   = True
    opt@projection        = 0                 ; "Equidistant_Lat_Lon"
    opt@date              = DATE
    opt@map_source        = "ICON 0.0625 x 0.0625"
    opt@startloc          = "SWCORNER"	    ; 8 chars exact
    opt@startlon          = 370
    opt@startlat          = 32.6
    opt@deltalon          = 0.0625
    opt@deltalat          = 0.0625
    opt@is_wind_earth_relative = False
    do n=0,dimsizes(p(:,0,0))-1
        opt@level = n
        wrf_wps_write_int(WPS_IM_root_name, FIELD_P, UNITS_P,  DESC_P, p(n,{32.6:44},{370:393.3}), opt)
        wrf_wps_write_int(WPS_IM_root_name, FIELD_HHL, UNITS_HHL, DESC_HHL, hgt(n,{32.6:44},{370:393.3}), opt)
        wrf_wps_write_int(WPS_IM_root_name, FIELD_TT, UNITS_TT,  DESC_TT, tt(n,{32.6:44},{370:393.3}), opt)
        wrf_wps_write_int(WPS_IM_root_name, FIELD_HUM, UNITS_HUM,  DESC_HUM, sp(n,{32.6:44},{370:393.3}), opt)
        wrf_wps_write_int(WPS_IM_root_name, FIELD_UU, UNITS_UU,  DESC_UU, uu(n,{32.6:44},{370:393.3}), opt)
        wrf_wps_write_int(WPS_IM_root_name, FIELD_VV, UNITS_VV,  DESC_VV, vv(n,{32.6:44},{370:393.3}), opt)
    end do
    delete(opt@level)
    opt@level = 200100.000000
    wrf_wps_write_int(WPS_IM_root_name, FIELD_TT2m, UNITS_TT2m,  DESC_TT2m, t2m({32.6:44},{370:393.3}), opt)
    wrf_wps_write_int(WPS_IM_root_name, FIELD_RH, UNITS_RH,  DESC_RH, rh2m({32.6:44},{370:393.3}), opt)
    wrf_wps_write_int(WPS_IM_root_name, FIELD_UU2m, UNITS_UU2m,  DESC_UU2m, u2m({32.6:44},{370:393.3}), opt)
    wrf_wps_write_int(WPS_IM_root_name, FIELD_VV2m, UNITS_VV2m,  DESC_VV2m, v2m({32.6:44},{370:393.3}), opt)
    wrf_wps_write_int(WPS_IM_root_name, FIELD_PS, UNITS_PS,  DESC_PS, ps({32.6:44},{370:393.3}), opt)
    wrf_wps_write_int(WPS_IM_root_name, FIELD_SKIN, UNITS_SKIN,  DESC_SKIN, SKIN({32.6:44},{370:393.3}), opt)
    wrf_wps_write_int(WPS_IM_root_name, FIELD_SHGT, UNITS_SHGT,  DESC_SHGT, soilhgt({32.6:44},{370:393.3}), opt)
    wrf_wps_write_int(WPS_IM_root_name, FIELD_LND, UNITS_LND,  DESC_LND, land({32.6:44},{370:393.3}), opt)
    wrf_wps_write_int(WPS_IM_root_name, FIELD_SNOW, UNITS_SNOW,  DESC_SNOW, snw({32.6:44},{370:393.3}), opt)
    wrf_wps_write_int(WPS_IM_root_name, FIELD_SNOWH, UNITS_SNOWH,  DESC_SNOWH, snd({32.6:44},{370:393.3}), opt)

    ;SM
    ; wrf_wps_write_int(WPS_IM_root_name, FIELD_SMOIST+"000"+"001", UNITS_SMOIST,  DESC_SMOIST, SM(0,{32.6:44},{370:393.3})/0.01, opt)
    ; wrf_wps_write_int(WPS_IM_root_name, FIELD_SMOIST+"001"+"003", UNITS_SMOIST,  DESC_SMOIST, SM(1,{32.6:44},{370:393.3})/0.02, opt)
    ; wrf_wps_write_int(WPS_IM_root_name, FIELD_SMOIST+"003"+"009", UNITS_SMOIST,  DESC_SMOIST, SM(2,{32.6:44},{370:393.3})/0.06, opt)
    ; wrf_wps_write_int(WPS_IM_root_name, FIELD_SMOIST+"009"+"027", UNITS_SMOIST,  DESC_SMOIST, SM(3,{32.6:44},{370:393.3})/0.18, opt)
    ; wrf_wps_write_int(WPS_IM_root_name, FIELD_SMOIST+"027"+"081", UNITS_SMOIST,  DESC_SMOIST, SM(4,{32.6:44},{370:393.3})/0.54, opt)
    ; wrf_wps_write_int(WPS_IM_root_name, FIELD_SMOIST+"081"+"243", UNITS_SMOIST,  DESC_SMOIST, SM(5,{32.6:44},{370:393.3})/1.62, opt)


    ; ;ST
    ; wrf_wps_write_int(WPS_IM_root_name, FIELD_ST+"000", UNITS_ST,  DESC_ST, ST(0,{32.6:44},{370:393.3}), opt)
    ; wrf_wps_write_int(WPS_IM_root_name, FIELD_ST+"006", UNITS_ST,  DESC_ST, ST(1,{32.6:44},{370:393.3}), opt)
    ; wrf_wps_write_int(WPS_IM_root_name, FIELD_ST+"1458", UNITS_ST,  DESC_ST, ST(2,{32.6:44},{370:393.3}), opt)

    delete(opt@level)
    opt@level = 201300.000000
    wrf_wps_write_int(WPS_IM_root_name, FIELD_PMSL, UNITS_PMSL,  DESC_PMSL, pmsl({32.6:44},{370:393.3}), opt)


end do

system("for f in ICONX3D*; do  mv ${f} ${f}:00; done")

end