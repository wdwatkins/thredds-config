THREDDS Configuration
=====================

This is a work in progress, we will be adding thredds configuration and documenting it as we go.

All metadata, union and join files are now stored in Stash. 

Metadata about each collection of datasets are statically included in the Dataset Inventory Catalog (catalog.xml) file using the XML namespace for [THREDDS InvCatalog](http://www.unidata.ucar.edu/software/thredds/current/tds/catalog/index.html) markup language version 1.0. The standard tags in the file are used to generate a catalog web site on the CIDA THREDDS server for service exploration. 

Each dataset-specific metadata link included within its collection points to the location of metadata about the specific netcdf dataset. Dataset-specific metadata are stored in Stash in /metadata/[collection]/[dataset].ncml files. 

Within each dataset's metadata ncml file (where they exist), a link is included which points to the /mnt/thredds-optimized/[collection]/[dataset] specific aggregations or join ncmls which are stored on the THREDDS server.

When a dataset does not have specific metadata information, the location link in the catalog.xml file for that dataset can point directly to the union file(s).

Special cases
=============

In the instance where a dataset is provided by a remote server, a metadata file was created and stored in the appropriate metadata/[collection]/[dataset] location in the repository, with the location information in the metadata file pointing to a different server rather than to the ncml file directly in /mnt/[collection]/[dataset]. 

In the catalog.xml inventory, datasets where previous direct linkages to a union ncml file were established in the urlPath attribute have been preserved to support existing direct linkages to the data **but will be phased out at a later date**, requiring service consumers to update their links to the new locations. Following our new convention and standard, metadata files for these datasets with these direct linkages were also created and placed into /metadata/[collection]/[dataset] conforming to the new standard practice of separating dataset metadata and aggregation tag contents. Just as above, new metadata files point to the data hosted on the THREDDS server in /mnt/[collection]/[dataset].

Also required when a dataset provides a direct linkage to an ncml file in the urlPath, are empty directories in the root level of the implementation, so that the server rewrite rules do not cause issues.

### mnt_thredds_optimized
Mirrors the data directory and contains join/union ncml files that were likely created by scripts. As time wears on, the scripts to create these files will be incorporated into these folders in some way.

### metadata
Contains metadata 'wrapper' ncml files for all 'datasets'. Each folder represents a 'collection'. These files contain absolute paths to files on the server.

# gmo, maurer, qpe
These directories are needed to account for an implementation detail of THREDDS that would require changing service urls to overcome. They are empty and should go away once the urls have been changed.


  
