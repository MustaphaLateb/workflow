#!/bin/bash -l

# Reprojects sample in east zone to UTM18. The output file is "snapped" to the 
# grid of the west zone in the same way it was done for the mosaics
#  so that they can be merged easily

export GDAL_DATA=/usr3/graduate/parevalo/miniconda2/envs/GDAL_ENV/share/gdal

# cd to the corresponding class folder
cd /projectnb/landsat/projects/Colombia/Mosaics/M3

# Rasterize east sample
qsub -j y -b y -V -N rast_samp1 \
    gdal_rasterize -a strata -a_nodata 255 \
    -te $(gdal_extent eastUTM19_2016.tif) -tr 30 30 -ot Byte \
    -co COMPRESS=PACKBITS sample_east_UTM19N_ID_PR_ZONE.shp \
    sample_east_UTM19N_ID_PR_ZONE.tif

# Reproject east sample to UTM18
qsub -j y -b y -V -N repr_sample -hold_jid rast_samp1 \
    gdalwarp -co COMPRESS=PACKBITS -wt Byte -overwrite \
    -te 725295 -429765 1506435 595185 -te_srs EPSG:32618 \
    -t_srs EPSG:32618 -tr 30 -30 sample_east_UTM19N_ID_PR_ZONE.tif \
    sample_east_UTM18N_ID_PR_ZONE.tif

# Poligonize that file
qsub -j y -b y -V -N pol_sample -hold_jid repr_sample \
    gdal_polygonize.py sample_east_UTM18N_ID_PR_ZONE.tif -f '"ESRI Shapefile"' \
    sample_east_UTM18N_ID_PR_ZONE.shp sample_east_UTM18N_ID_PR_ZONE strata

# Then manually merge the shapefiles from the two zones...


