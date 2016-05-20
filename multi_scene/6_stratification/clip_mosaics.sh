#!/bin/bash -l

# Script to clip mosaic to Amazon boundary. Requires GDAL <=2.1

cd /projectnb/landsat/projects/Colombia/Mosaics/M3
ps=0.000270099 #Pixel size in degrees in case it's needed
limit=/projectnb/landsat/projects/Colombia/vector/amazon_boundary.shp

# Unset NoData and clip

for yr in $(seq -w 01 16); do
    
    # Unset NoData so that we can operate over areas with value of 0
    gdal_edit.py -unsetnodata 20$yr"_final.tif"
    
    # Clip    
    qsub -j y -V -N clip$yr -b y \
     gdalwarp -cutline $limit -cl amazon_boundary \
      -ot Byte -co COMPRESS=PACKBITS -overwrite 20$yr"_final.tif" \
       20$yr"_final_crop.tif"

done

