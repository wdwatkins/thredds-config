Processing steps:
paths set up for the Mac Pro

1. Added a variable for soil levels for mrso variable, and appropriate attributes
for units etc
      - script: add_soil_levels_mrso.sh
2. Added to 'coordinates' attribute for all variables, so time is included and 
soil level if appropriate
     - script: add_time_coord.sh
     
3.  Packed and compressed files - based on min/max values of each variable, converted
files to 16 or 32 bit integers w/ appropriate scales.
  - printRange.sh finds max/min values
  - R/getScaleFactors.R calculates scale factors and whether 16 or 32 bit int is required
  - run_compress.sh runs scripts in bin/ folder that do the actual packing and compression
  
4. Fixed (limited) time dimensions
  - fix_time_X.sh
  
5. Removed degenerate dimensions on certain variables
  - remove_m_dims
  
######## Metadata rendering ########
readme_downscaling_necsc_notaro.txt - provided w original data
config_meta.yml: various metadata that scripts use to render templates
R/render_join_union_ncml: Renders the join/union ncmls that sit with the data
 - mustache template: notaro_template_join.ncml
 R/render_thredds_meta.ncml: Renders thredds metadata ncmls, and the portion of the catalog.xml (pasted this in by hand)
  - templates: catalog_dataset_template.xml, thredds_config_ncml_template.ncml
R/render_iso: Render the ISO XML for sciencebase from a template
   - template: iso_template.xml

