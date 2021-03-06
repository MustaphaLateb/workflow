#!/bin/bash -l
#$ -V
#$ -j y


# This script performs post sieving operations: re assigning the nodata value
# to 0 for all the sieved rasters (no longer necessary because we're not using
# the file that comes straight out of the sieving), and deleting all the 
# temporary masks created in the process

module load python/2.7.5_nopath
module load gdal/1.11.1

scn_list="003058 003059 004057 004058 004059 004061 004062 005057 005058 \
          005059 005060 005061 006058 006059 006060 006061 007058 007059 \
          007060 007061 008058 008059 008060 009059 009060"

# General settings

rootdir=/projectnb/landsat/projects/Colombia/images

# Iterate over scenes

for s in $scn_list; do
    cd $rootdir/$s/Results/M2/Class
    
    # Re-assign nodata values (no longer necessary)
    #for yr in $(seq -w 01 01); do    
    #    gdal_edit.py -a_nodata 0 ClassM2B_$yr"_sieved".tif
    #done

    # Delete masks and log files
    rm -f -v mask*
    rm -f -v mA_*
    rm -f -v mB_*
    rm -f -v mC_*
    rm -f -v mD_*
done

