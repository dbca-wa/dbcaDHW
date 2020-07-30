# code to create internal data
library(sf)

shpWA <- sf::st_read(dsn = "../WA_bbox_WGS_84.shp", layer = "WA_bbox_WGS_84")

usethis::use_data(shpWA, internal = TRUE)
