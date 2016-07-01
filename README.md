# workflow
Repository to include all the basic scripts needed to run all steps of yatsm for each of the scenes

### Definitive stratification 

* 0 - Other classes to other classes (includes forest to grassl., urban, water and "other")
* 1 - Stable forest
* 2 - Stable grassland
* 3 - Stable urban + former stratum 7 (stable other (sandbanks, rocks))
* 4 - Stable pasture/cropland
* 5 - Stable regrowth (includes regrowth to forest)
* 6 - Stable water
* 8 - Forest to pastures + forest to unclassified
* 9 - Forest to regrowth
* 11 - Pastures to regrowth + former stratum 12 (Grassland, Urban, Water and "Other" to regrowth)
* 13 - ALL CLASSES (except forest and regrowth) to unclassified
* 14 - Loss of regrowth (regrowth to all other classes except to forest)
* 15 - True NoData

### File locations:

**Images**: `/projectnb/landsat/projects/Colombia/<path><row>/images`

**Image cache**: `/projectnb/landsat/projects/Colombia/<path><row>/images/.cache` 

**Time Series Results**: `/projectnb/landsat/projects/Colombia/<path><row>/Results/M3/TSR`

**Individual scene classification results**: 
`/projectnb/landsat/projects/Colombia/<path><row>/Results/M3/Class/mergedmaps_<year>_final.tif`

**Final mosaics, strata and samples**: `/projectnb/landsat/projects/Colombia/Mosaics/M3`

### File names:

**Mosaics of east region**: `eastUTM19_<year>.tif`

**Mosaics of west region**: `westUTM18_<year>.tif`

**Reprojected mosaics of east region matching west grid**: `eastUTM18_<year>.tif`

**Mosaics of entire region**: `<year>_final.tif`

**Mosaics of entire region clipped to amazon boundary**: `<year>_final_crop.tif`

**Strata created for 2001-2016**: `strata_01_16_UTM18N.tif`

**Reprojected-forced clipped strata in UTM19N in case it's needed**: `strata_01_16_UTM19N.tif`

**Sample obtained straight from script**: `sample_may2016_UTM18N.shp`

**Definitive, ready to use samples for each zone**: 
`sample_east_UTM19N_ID_PR_ZONE.shp` and `sample_west_UTM18N_ID_PR_ZONE.shp`
