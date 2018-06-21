University of Wisconsin-Madison Dynamical Downscaling Product

Six global climate models (GCMs) from the Coupled Model Intercomparison Project Phase Five (CMIP5) were
dynamically downscaled to 25-km grid spacing according to the representative concentration pathway 8.5 (RCP8.5) 
scenario using the International Centre for Theoretical Physics (ICTP) Regional Climate Model Version Four (RegCM4). 
These GCMs include the Centre National de Recherches Meteorologiques Coupled Global Climate Model Version Five (CNRM-CM5), 
the Model for Interdisciplinary Research on Climate Version Five (MIROC5), the Institut Pierre Simon Laplace Coupled Model 
Version Five-Medium Resolution (IPSL-CM5-MR), the Meteorological Research Institute Coupled Global Climate Model Version 
Three (MRI-CGCM3), the Centre for Australian Weather and Climate Research, Australia GCM (ACCESS1-0), and the National 
Oceanic and Atmospheric Administration Geophysical Fluid Dynamics Laboratory model (GFDL-ESM2M).

The downscaling was funded by grants and contracts from the National Oceanic and Atmospheric Administration (NOAA)/Climate 
Change Data and Detection, NOAA Great Lakes Environmental Research Laboratory [Environmental Protection Agency (EPA) grant], 
Michigan Department of Natural Resources (EPA grant), Northeast Climate Science Center (CSC), and National Science Foundation (NSF).

We acknowledge the World Climate Research Programme's Working Group on Coupled Modelling, which is responsible for CMIP, 
and we thank the climate modeling groups for producing and makign available their model output. For CMIP, the U.S. Department 
of Energy's Program for Climate Model Diagnosis and Intercomparison provides coordinating support and led development of 
software infrastructure in partnership with the Global Organization for Earth System Science Portals. 

Computational resources were provided through the National Center for Atmospheric Research (NCAR) and the Teragrid from the 
University of Texas at Austin and the University of Illinois at Urbana-Champaign.

The dynamical downscaling of climate projections was performed by Drs. Val Bennington, Yafang Zhong, and Michael Notaro.

Data contact
Michael Notaro
Associate Director / Senior Scientist
Nelson Institute Center for Climatic Research
University of Wisconsin-Madison
608-261-1503
mnotaro@wisc.edu

Relevant Publications
* When preparing papers based on this data, please cite Notaro et al. 2015a, 2016.
Notaro, M., Y. Zhong, S. Vavrus, M. Schummer, L. Van Den Elsen, J. Coluccy, and C. Hoving, 2016: Projected 
    influences of changes in weather severity on autumn-winter distributions of dabbling ducks in the Mississippi and 
    Atlantic Flyways during the twenty-first century. Plos One, 11(12), e0167506.
Notaro, M., V. Bennington, and S. Vavrus, 2015a: Dynamically downscaled projections of lake-effect snow in the
    Great Lakes Basin. Journal of Climate, 28, 1661-1684.
Notaro, M., V. Bennington, and B. Lofgren, 2015b: Dynamical downscaling-based projections of Great Lakes’ water 
    levels. J. Climate, 28, 9721-9745.
Bennington, V., M. Notaro, and K.D. Holman, 2014: Improving climate sensitivity of deep lakes within a regional 
    climate model and its impact on simulated climate. Journal of Climate, 27, 2886-2911.
Notaro, M., A. Zarrin, S. Vavrus, and V. Bennington, 2013a: Simulation of heavy lake-effect snowstorms across the 
    Great Lakes Basin by RegCM4: Synoptic climatology and variability. Monthly Weather Review, 141, 1990-2014.
Notaro, M., K. Holman, A. Zarrin, E. Fluck, S. Vavrus, and V. Bennington, 2013b: Influence of the Laurentian Great 
    Lakes on regional climate. Journal of Climate, 26, 789-804.
Vavrus, S., M. Notaro, and A. Zarrin, 2013: The role of ice cover in heavy lake-effect snowstorms across the Great 
    Lakes Basin as simulated by RegCM4. Monthly Weather Review, 141, 148-165.

Data Specifications
The complete downscaling dataset is roughly 30 TB in size, stored on University of Wisconsin-Madison servers.  
Here, we extracted a sub-region over the Northeast Climate Science Center domain for select surface variables alone.
Only 20-year time chunks for 1980-1999, 2040-2059, and 2080-2099 are provided here.
Contact Michael Notaro if you wish to access additional variables and/or regions.

For the sample netcdf data file, REGCM4_CNRM_tas.1980to1989.nc, CNRM was dynamically downscaled using RegCM4 for
January 1980 to December 1989, and the file contains hourly near-surface air temperatures for that period.

Variables:
evspsbl = total evapotranspiration flux kg/m2/s
hfss = surface upward sensible heat flux W/m2
mrso = moisture content of each of the two soil layers kg/m2
pr = total precipitation flux kg/m2/s
ps = surface air pressure hPa
qas = near surface air specific humidity kg/kg
rsds = surface downward shortwave flux in the air W/m2
rsns = net downward shortwave energy flux in the air W/m2
snv = liquid water equivalent of snow thickness kg/m2
sund = duration of sunshine s
tas = near surface air temperature K
uas = anemometric zonal wind component (westerly) m/s
vas = anemometric meridional wind component (southerly) m/s

Each file also contains:
iy = y-coordinate in Cartesian system m
jx = x-coordinate in Cartesian system m
mask = land binary mask unitless
time = time
topo = surface model elevation m
xlat = latitude on cross points in degrees north
xlon = longitude on cross points in degrees east

Sample ncdump of file content

ncdump -h REGCM4_CNRM_tas_1980to1989.nc
netcdf REGCM4_CNRM_tas_1980to1989 {
dimensions:
	time = UNLIMITED ; // (87672 currently)
	iy = 86 ;
	jx = 111 ;
	m2 = 1 ;
	time_bounds = 2 ;
variables:
	float iy(iy) ;
		iy:long_name = "y-coordinate in Cartesian system" ;
		iy:standard_name = "projection_y_coordinate" ;
		iy:units = "m" ;
		iy:axis = "Y" ;
		iy:_CoordinateAxisType = "GeoY" ;
	float jx(jx) ;
		jx:long_name = "x-coordinate in Cartesian system" ;
		jx:standard_name = "projection_x_coordinate" ;
		jx:units = "m" ;
		jx:axis = "X" ;
		jx:_CoordinateAxisType = "GeoX" ;
	float mask(iy, jx) ;
		mask:long_name = "Land Mask" ;
		mask:standard_name = "land_binary_mask" ;
		mask:units = "1" ;
		mask:coordinates = "xlat xlon" ;
		mask:grid_mapping = "rcm_map" ;
	char rcm_map ;
		rcm_map:grid_mapping_name = "lambert_conformal_conic" ;
		rcm_map:standard_parallel = 36., 52. ;
		rcm_map:longitude_of_central_meridian = -97. ;
		rcm_map:latitude_of_projection_origin = 45. ;
		rcm_map:_CoordinateTransformType = "Projection" ;
		rcm_map:_CoordinateAxisTypes = "GeoX GeoY" ;
	float tas(time, m2, iy, jx) ;
		tas:long_name = "Near surface air temperature" ;
		tas:standard_name = "air_temperature" ;
		tas:units = "K" ;
		tas:coordinates = "xlat xlon" ;
		tas:grid_mapping = "rcm_map" ;
		tas:cell_methods = "time: point" ;
	float time(time) ;
		time:long_name = "time" ;
		time:standard_name = "time" ;
		time:units = "hours since 1949-12-01 00:00:00 UTC" ;
		time:calendar = "gregorian" ;
		time:bounds = "time_bnds" ;
	float time_bnds(time, time_bounds) ;
		time_bnds:units = "hours since 1949-12-01 00:00:00 UTC" ;
		time_bnds:calendar = "gregorian" ;
	float topo(iy, jx) ;
		topo:long_name = "Surface Model Elevation" ;
		topo:standard_name = "surface_altitude" ;
		topo:units = "m" ;
		topo:coordinates = "xlat xlon" ;
		topo:grid_mapping = "rcm_map" ;
	float xlat(iy, jx) ;
		xlat:long_name = "Latitude on Cross Points" ;
		xlat:standard_name = "latitude" ;
		xlat:units = "degrees_north" ;
		xlat:grid_mapping = "rcm_map" ;
	float xlon(iy, jx) ;
		xlon:long_name = "Longitude on Cross Points" ;
		xlon:standard_name = "longitude" ;
		xlon:units = "degrees_east" ;
		xlon:grid_mapping = "rcm_map" ;

// global attributes:
		:title = "ICTP Regional Climatic model V4" ;
		:institution = "ICTP" ;
		:source = "RegCM Model output file" ;
		:Conventions = "CF-1.4" ;
		:references = "http://gforge.ictp.it/gf/project/regcm" ;
		:model_revision = "tag 4.3.5.6" ;
		:history = "Mon Jan 22 14:40:31 2018: ncrcat -c -v tas,mask,rcm_map,time_bnds,topo,xlat,xlon REGCM4_CNRM_SRF.1980010100.nc REGCM4_CNRM_SRF.1980020100.nc REGCM4_CNRM_SRF.1980030100.nc REGCM4_CNRM_SRF.1980040100.nc REGCM4_CNRM_SRF.1980050100.nc REGCM4_CNRM_SRF.1980060100.nc REGCM4_CNRM_SRF.1980070100.nc REGCM4_CNRM_SRF.1980080100.nc REGCM4_CNRM_SRF.1980090100.nc REGCM4_CNRM_SRF.1980100100.nc REGCM4_CNRM_SRF.1980110100.nc REGCM4_CNRM_SRF.1980120100.nc REGCM4_CNRM_SRF.1981010100.nc REGCM4_CNRM_SRF.1981020100.nc REGCM4_CNRM_SRF.1981030100.nc REGCM4_CNRM_SRF.1981040100.nc REGCM4_CNRM_SRF.1981050100.nc REGCM4_CNRM_SRF.1981060100.nc REGCM4_CNRM_SRF.1981070100.nc REGCM4_CNRM_SRF.1981080100.nc REGCM4_CNRM_SRF.1981090100.nc REGCM4_CNRM_SRF.1981100100.nc REGCM4_CNRM_SRF.1981110100.nc REGCM4_CNRM_SRF.1981120100.nc REGCM4_CNRM_SRF.1982010100.nc REGCM4_CNRM_SRF.1982020100.nc REGCM4_CNRM_SRF.1982030100.nc REGCM4_CNRM_SRF.1982040100.nc REGCM4_CNRM_SRF.1982050100.nc REGCM4_CNRM_SRF.1982060100.nc REGCM4_CNRM_SRF.1982070100.nc REGCM4_CNRM_SRF.1982080100.nc REGCM4_CNRM_SRF.1982090100.nc REGCM4_CNRM_SRF.1982100100.nc REGCM4_CNRM_SRF.1982110100.nc REGCM4_CNRM_SRF.1982120100.nc REGCM4_CNRM_SRF.1983010100.nc REGCM4_CNRM_SRF.1983020100.nc REGCM4_CNRM_SRF.1983030100.nc REGCM4_CNRM_SRF.1983040100.nc REGCM4_CNRM_SRF.1983050100.nc REGCM4_CNRM_SRF.1983060100.nc REGCM4_CNRM_SRF.1983070100.nc REGCM4_CNRM_SRF.1983080100.nc REGCM4_CNRM_SRF.1983090100.nc REGCM4_CNRM_SRF.1983100100.nc REGCM4_CNRM_SRF.1983110100.nc REGCM4_CNRM_SRF.1983120100.nc REGCM4_CNRM_SRF.1984010100.nc REGCM4_CNRM_SRF.1984020100.nc REGCM4_CNRM_SRF.1984030100.nc REGCM4_CNRM_SRF.1984040100.nc REGCM4_CNRM_SRF.1984050100.nc REGCM4_CNRM_SRF.1984060100.nc REGCM4_CNRM_SRF.1984070100.nc REGCM4_CNRM_SRF.1984080100.nc REGCM4_CNRM_SRF.1984090100.nc REGCM4_CNRM_SRF.1984100100.nc REGCM4_CNRM_SRF.1984110100.nc REGCM4_CNRM_SRF.1984120100.nc REGCM4_CNRM_SRF.1985010100.nc REGCM4_CNRM_SRF.1985020100.nc REGCM4_CNRM_SRF.1985030100.nc REGCM4_CNRM_SRF.1985040100.nc REGCM4_CNRM_SRF.1985050100.nc REGCM4_CNRM_SRF.1985060100.nc REGCM4_CNRM_SRF.1985070100.nc REGCM4_CNRM_SRF.1985080100.nc REGCM4_CNRM_SRF.1985090100.nc REGCM4_CNRM_SRF.1985100100.nc REGCM4_CNRM_SRF.1985110100.nc REGCM4_CNRM_SRF.1985120100.nc REGCM4_CNRM_SRF.1986010100.nc REGCM4_CNRM_SRF.1986020100.nc REGCM4_CNRM_SRF.1986030100.nc REGCM4_CNRM_SRF.1986040100.nc REGCM4_CNRM_SRF.1986050100.nc REGCM4_CNRM_SRF.1986060100.nc REGCM4_CNRM_SRF.1986070100.nc REGCM4_CNRM_SRF.1986080100.nc REGCM4_CNRM_SRF.1986090100.nc REGCM4_CNRM_SRF.1986100100.nc REGCM4_CNRM_SRF.1986110100.nc REGCM4_CNRM_SRF.1986120100.nc REGCM4_CNRM_SRF.1987010100.nc REGCM4_CNRM_SRF.1987020100.nc REGCM4_CNRM_SRF.1987030100.nc REGCM4_CNRM_SRF.1987040100.nc REGCM4_CNRM_SRF.1987050100.nc REGCM4_CNRM_SRF.1987060100.nc REGCM4_CNRM_SRF.1987070100.nc REGCM4_CNRM_SRF.1987080100.nc REGCM4_CNRM_SRF.1987090100.nc REGCM4_CNRM_SRF.1987100100.nc REGCM4_CNRM_SRF.1987110100.nc REGCM4_CNRM_SRF.1987120100.nc REGCM4_CNRM_SRF.1988010100.nc REGCM4_CNRM_SRF.1988020100.nc REGCM4_CNRM_SRF.1988030100.nc REGCM4_CNRM_SRF.1988040100.nc REGCM4_CNRM_SRF.1988050100.nc REGCM4_CNRM_SRF.1988060100.nc REGCM4_CNRM_SRF.1988070100.nc REGCM4_CNRM_SRF.1988080100.nc REGCM4_CNRM_SRF.1988090100.nc REGCM4_CNRM_SRF.1988100100.nc REGCM4_CNRM_SRF.1988110100.nc REGCM4_CNRM_SRF.1988120100.nc REGCM4_CNRM_SRF.1989010100.nc REGCM4_CNRM_SRF.1989020100.nc REGCM4_CNRM_SRF.1989030100.nc REGCM4_CNRM_SRF.1989040100.nc REGCM4_CNRM_SRF.1989050100.nc REGCM4_CNRM_SRF.1989060100.nc REGCM4_CNRM_SRF.1989070100.nc REGCM4_CNRM_SRF.1989080100.nc REGCM4_CNRM_SRF.1989090100.nc REGCM4_CNRM_SRF.1989100100.nc REGCM4_CNRM_SRF.1989110100.nc REGCM4_CNRM_SRF.1989120100.nc REGCM4_CNRM_tas_1980to1989.nc\n",
			"Thu Jan 18 16:01:34 2018: ncks -v jx,iy,xlon,xlat,mask,topo,ps,pr,evspsbl,hfss,rsns,rsds,sund,snv,uas,vas,tas,qas,mrso,time,time_bnds,rcm_map -d iy,25,110 -d jx,100,210 /data2/val/CNRM/historical/output/CNRM_SRF.1980010100.nc /data/notaro/processing/cnrm/RCM_CNRM_SRF.1980010100.nc\n",
			"2013-09-15 01:49:25 : Created by RegCM RegCM Model program" ;
		:experiment = "CNRM" ;
		:projection = "LAMCON" ;
		:grid_size_in_meters = 25000. ;
		:latitude_of_projection_origin = 45. ;
		:longitude_of_projection_origin = -97. ;
		:standard_parallel = 36., 52. ;
		:grid_factor = 0.696943758331507 ;
		:boundary_nspgx = 15 ;
		:boundary_nspgd = 15 ;
		:boundary_high_nudge = 3. ;
		:boundary_medium_nudge = 2. ;
		:boundary_low_nudge = 1. ;
		:model_is_restarted = "Yes" ;
		:model_simulation_initial_start = "1970-06-01 00:00:00 UTC" ;
		:model_simulation_start = "1979-03-01 00:00:00 UTC" ;
		:model_simulation_end = "1981-09-01 00:00:00 UTC" ;
		:atmosphere_time_step_in_seconds = 120. ;
		:surface_interaction_time_step_in_seconds = 120. ;
		:radiation_scheme_time_step_in_minuts = 30. ;
		:absorption_emission_time_step_in_hours = 18. ;
		:lateral_boundary_condition_scheme = 1 ;
		:boundary_layer_scheme = 1 ;
		:cumulus_convection_scheme = 2 ;
		:grell_scheme_closure = 2 ;
		:moisture_scheme = 1 ;
		:ocean_flux_scheme = 2 ;
		:zeng_ocean_roughness_formula = 1 ;
		:pressure_gradient_scheme = 0 ;
		:surface_emissivity_factor_computed = 0 ;
		:lake_model_activated = 1 ;
		:chemical_aerosol_scheme_activated = 0 ;
		:ipcc_scenario_code = "A1B" ;
		:diurnal_cycle_sst_scheme = 0 ;
		:simple_sea_ice_scheme = 0 ;
		:seasonal_desert_albedo = 1 ;
		:convective_lwp_as_large_scale = 1 ;
		:rrtm_radiation_scheme_activated = 0 ;
		:climatic_ozone_input_dataset = 0 ;
		:static_solar_constant_used = 1 ;
		:subex_bottom_level_with_no_clouds = 1 ;
		:subex_maximum_cloud_fraction_cover = 0.8 ;
		:subex_auto_conversion_rate_for_land = 0.00025 ;
		:subex_auto_conversion_rate_for_ocean = 0.00025 ;
		:subex_gultepe_factor_when_rain_for_land = 0.4 ;
		:subex_gultepe_factor_when_rain_for_ocean = 0.4 ;
		:subex_rh_with_fcc_one = 1.01 ;
		:subex_rh_threshold_for_land = 0.8 ;
		:subex_rh_threshold_for_ocean = 0.9 ;
		:subex_limit_temperature = 238. ;
		:subex_raindrop_evaporation_rate = 0.0008 ;
		:subex_raindrop_accretion_rate = 3. ;
		:subex_cloud_fraction_maximum = 0.75 ;
		:subex_cloud_fraction_max_for_convection = 0.25 ;
		:subex_cloud_liqwat_max_for_convection = 5.e-05 ;
		:grell_min_shear_on_precip = 0.25 ;
		:grell_max_shear_on_precip = 0.5 ;
		:grell_min_precip_efficiency = 0.25 ;
		:grell_max_precip_efficiency = 0.5 ;
		:grell_min_precip_efficiency_o = 0.25 ;
		:grell_max_precip_efficiency_o = 0.5 ;
		:grell_min_precip_efficiency_x = 0.25 ;
		:grell_max_precip_efficiency_x = 0.5 ;
		:grell_min_shear_on_precip_on_ocean = 0.25 ;
		:grell_max_shear_on_precip_on_ocean = 0.5 ;
		:grell_min_precip_efficiency_on_ocean = 0.25 ;
		:grell_max_precip_efficiency_on_ocean = 0.5 ;
		:grell_min_precip_efficiency_o_on_ocean = 0.25 ;
		:grell_max_precip_efficiency_o_on_ocean = 0.5 ;
		:grell_min_precip_efficiency_x_on_ocean = 0.25 ;
		:grell_max_precip_efficiency_x_on_ocean = 0.5 ;
		:grell_max_depth_of_stable_layer = 150. ;
		:grell_min_depth_of_cloud = 150. ;
		:grell_min_convective_heating = -250. ;
		:grell_max_convective_heating = 500. ;
		:grell_max_cloud_base_height = 0.4 ;
		:grell_FC_ABE_removal_timescale = 30. ;
		:holtslag_critical_ocean_richardson = 0.25 ;
		:holtslag_critical_land_richardson = 0.25 ;
		:NCO = "4.0.9" ;
		:nco_openmp_thread_number = 1 ;
