# workflow
Repository to include all the basic scripts needed to run all steps of yatsm for each of the scenes

**UPDATE WITH EXPLANATIONS OF ALL OF THE STEPS!**

### Stratification:

* 0 - Other classes to other classes
* 1 - Stable forest
* 2 - Stable grassland
* 3 - Stable urban
* 4 - Stable pasture/cropland
* 5 - Stable regrowth (includes regrowth to forest)
* 6 - Stable water
* 7 - Stable other (sandbanks, rocks)
* 8 - Forest to pastures
* 9 - Forest to regrowth
* 10 - Forest to all others (Grasslands, urban, water and "Other")
* 11 - Pastures to regrowth
* 12 - Grassland, Urban, Water and "Other" to regrowth
* 13 - ALL CLASSES (except forest and regrowth) to unclassified
* 14 - Loss of regrowth (regrowth to all other classes except to forest)
* 15 - True NoData

### File locations:

**Images**: `/projectnb/landsat/projects/Colombia/<path><row>/images`

**Image cache**: `/projectnb/landsat/projects/Colombia/<path><row>/images/.cache` 

**Time Series Results**: `/projectnb/landsat/projects/Colombia/<path><row>/Results/M3/TSR`

**Individual scene classification results**: 
`/projectnb/landsat/projects/Colombia/<path><row>/Results/M3/Class/mergedmaps_<year>_final.tif`

**Final mosaics**: `/projectnb/landsat/projects/Colombia/Mosaics/M3`
