#!/bin/bash -l

# Script to process the maps to compare them to those of IDEAM
# Has three main steps
# 1) Create custom strata with only forest/non forest classes
# (All "other" changes will still be labeled as zero)
# 2) Reproject to MAGNA-SIRGAS and match grids.
# 3) Sieve polygons of less than 1 ha (or around 11.11 pixels)

cd /projectnb/landsat/projects/Colombia/Mosaics/M3/IDEAM
export GDAL_DATA=/usr3/graduate/parevalo/miniconda2/envs/GDAL_ENV/share/gdal
export GDAL_CACHEMAX=2048

# Create a list of years we want to get strata from, omitting 00-02
# Periods have +1 year to make them more comparable to my maps (which correspond
# to the first day of the year
period_list="03-05" #05-07 07-09 09-10 11-13 13-14 14-15" #03-05

# Calculate strata for each year we might want to check
# We can classify regrowing vegetation as forest or not
# How to label change from 1 to 2, 3, 6, 7?
# How to label all to unclassified? (13)

# 1 stable forest, 2 forest to others (forest loss), 3 forest to regrowth, 
# 4 regrowth to forest (regrowth), 5 Stable nonforest, 
# 6 Stable regrowth, 7 Anything to regrowth (regrowth), 8 Regrowth to others 
# 9 others to forest (regrowth)
for p in $period_list; do
    f="custom__strata_"$p"_UTM18N.tif"
    
    # 1) Create custom strata 
    y1=${p:0:2}
    y2=${p:3:2}
    qsub -j y -V -N strata_$p -b y \
     gdal_calc.py -A ../20$y1"_final_crop.tif" -B ../20$y2"_final_crop.tif" \
      --outfile=$f \
      --calc='"logical_and(A == 1, B==1)*1 + logical_and(A == 2, B==2)*5+' \
              'logical_and(A == 3, B==3)*5 + logical_and(A == 4, B==4)*5 +' \
              'logical_and(A == 5, B==5)*6 + logical_and(A == 5, B==1)*4+' \
              'logical_and(A == 6, B==6)*5 +' \
              'logical_and(A == 7, B==7)*5 + logical_and(A == 1, B==4)*2 +' \
              'logical_and(A == 1, B==5)*3 +' \
              'logical_and(A == 1, logical_or(B==2, B==3))*2 +' \
              'logical_and(A == 1, logical_or(B==6, B==7))*2 +' \
              'logical_and(A == 1, B == 0)*2 +' \
              'logical_and(A == 4, B==5)*7 +' \
              'logical_and(logical_or(A == 2, A==3), B==5)*7 +' \
              'logical_and(logical_or(A == 6, A==7), B==5)*7 +' \
              'logical_and(logical_and(logical_and(A!=0,A!=1), A!=5), B==0)*5 +' \
              'logical_and(A == 5, logical_and(B != 5, B!= 1))*8 +' \
              'logical_and(logical_or(A == 2, A==3), B==1)*9 +' \
              'logical_and(logical_or(A == 4, A==6), B==1)*9 +' \
              'logical_and(A == 7, B==1)*9 +' \
              'logical_and(A == 0, B==0)*15"' \
      --type=Byte --co="COMPRESS=PACKBITS" --overwrite

    # 2) Reproject to MAGNA-SIRGAS and grid
    # This section works fine except because the output file has a 2 meter 
    # offset in the lower left Y coordinate for an unknown reason. Also, the 
    # annual IDEAM files have a sligtly different origin than the others


    # Use 15 as input and output nodata, because the "other to other" class is 
    # still labeled as zero
    qsub -V -b y -j y -N reproj_$p -hold_jid strata_$p \
     gdalwarp -co COMPRESS=PACKBITS -co NBITS=4 -wt Byte \
      -te $(gdal_extent cambio_2002_2004_v6_amazonia.tif) -te_srs EPSG:3116 \
       -t_srs EPSG:3116 -tr 30.717 -30.2624 -srcnodata 15 -dstnodata 15 \
        -overwrite $f $(basename $f .tif)"_MAGNA.tif"
    

    # 3) Sieve "polygons" of less than 1 ha (around 11.11 pixels)
    qsub -V -b y -j y -N sieve_$p -hold_jid reproj_$p  gdal_sieve.py -st 11 -8 \
     $(basename $f .tif)"_MAGNA.tif" $(basename $f .tif)"_MAGNA_sieved.tif"


    # 4) Use gdalcalc to compare the the maps
    # Revert to IDEAM's numbering
    y1p=`expr $y1 - 1`
    y2p=`expr $y2 - 1`
    printf -v yr1 '%02d' $y1p 
    printf -v yr2 '%02d' $y2p
        
    qsub -j y -V -N compare_$p -hold_jid sieve_$p -b y \
     gdal_calc.py -A "cambio_20"$yr1"_20"$yr2"_v6_amazonia.tif" \
      -B $(basename $f .tif)"_MAGNA_sieved.tif" \
      --outfile=comparison_$p \
       --calc='"logical_and(A == 1, B==1)*1 + logical_and(A == 2, B==2)*2+' \
       --type=Byte --co="COMPRESS=PACKBITS" --overwrite

done

