THREDDS Configuration

This repository contains configurations for the THREDDS server deployed to http://cida.usgs.gov/thredds/catalog.html and http://cidasdqathrds.cr.usgs.gov:8080/thredds/catalog.html for QA.  

The production instance is on machine: cida-eros-thredds3.er.usgs.gov with two instances. The instances share configurations. 

The content directory contains thredds server-oriented configurations. catalog.xml, threddsConfig.xml, and dataset metadata. The dataset metadata files in content/thredds/metadata/... contain absolute paths to data sources. These are the only absolute paths in the system allowing qa and production to share configurations pointing to the same data. QA has a read-only mount to production that is in the same place.
