THREDDS Configuration
=====================

This is a work in progress, we will be adding thredds configuration and documenting it as we go.

All metadata, union and join files are now stored in Stash. 

Metadata about each collection of datasets are included directly in the catalog.xml file using the XML namespace for THREDDS InvCatalog markup language version 1.0. The standard tags in the file are used to generate a catalog web site on the CIDA THREDDS server for service exploration. 

Each dataset-specific metadata link included within its collection points to the location of metadata about the specific netcdf dataset. Dataset-specific metadata are stored in Stash in /metadata/[collection]/[dataset].ncml files. 

Within each dataset's metadata ncml file (where they exist), a link is included which points to the /mnt/thredds-optimized/[collection]/[dataset] specific aggregations or join ncmls which are stored on the THREDDS server.

When a dataset does not have specific metadata information, the location link in the catalog.xml file for that dataset can point directly to the union file(s).




  
