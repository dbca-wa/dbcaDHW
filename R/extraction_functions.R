# Functions to extract SST data from nc format SST downloads

#' Convert nc format CRW downloads to img format
#'
#' \code{nc_to_img} takes a file path downloaded nc format CRW data and converts
#'     the SST data to img format.
#'
#' @details Takes a file path to downloaded nc format files from NOAA's Coral
#'     Reef Watch \url{ftp://ftp.star.nesdis.noaa.gov/pub/sod/mecb/crw/data/5km/v3.1/nc/v0.1/daily/sst/} and
#'     converts the files to img format for easier handling. The original nc files
#'     are global and this function clips the data to the Western Australian
#'     region unless provided an alternative shape file.
#'
#'     Note that there is a strict folder structure required. The file path
#'     provided is presumed to be a working directory where user provided shape
#'     files and any outputs will be saved. All functions operate relative to
#'     this location. This should also contain a directory called `nc_data/`
#'     which contains the downloaded nc data organised into directories by year.
#'
#'     Note output data will have the EPSG 3577 and any user supplied shape
#'     file will be automatically transformed to this prior to use.
#'
#' @param pathin a character file path to the working directory (see details).
#'
#' @param vector character representation of the shape file name to clip the
#'     global data to. No file extension. Defaults to "WA" an internal bounding
#'     box for the WA region.
#'
#' @return a directory called `img_data/` will be created for output img data.
#'     Yearly folder structure will be recreated here and outputs will all be
#'     clipped to either the default WA region or to a region of the users choice.
#'     All outputs will have the EPSG of 3577.
#'
#' @examples
#' \dontrun{
#' nc_to_img(pathin = ".", vector = "WA")
#' }
#'
#' @author Bart Huntley, \email{bart.huntley@@dbca.wa.gov.au}
#'
#' For more details see \url{https://dbca-wa.github.io/dbcaDHW/index.html}
#' {the dbcaDHW website}
#'
#' @importFrom here set_here here
#' @importFrom sp CRS
#' @importFrom raster raster crop projectRaster writeRaster
#' @importFrom sf st_read st_transform
#'
#' @export
nc_to_img <- function(pathin, vector = "WA"){
  # define where we are
  here::set_here(pathin, verbose = TRUE)

  # img data folder setup
  imdir <- here::here("img_data")
  if(!file.exists(imdir)){dir.create(imdir)}

  # grab a list of raw data nc files (as downloaded)
  flist <- list.dirs(path = here("nc_data"), recursive = FALSE)

  # read in vector to use - defaults to one for WA
  if(vector == "WA"){
    shp <- shpWA
  } else {
    shp <- sf::st_read(dsn = here(), layer = vector)
  }

  alb <- suppressWarnings(sp::CRS(paste("+proj=aea +lat_1=-18 +lat_2=-36 +lat_0=0",
                                    "+lon_0=132 +x_0=0 +y_0=0 +ellps=GRS80",
                                    "+towgs84=0,0,0,0,0,0,0 +units=m +no_defs")))

  for(a in seq_along(flist)){
    # grab list of raw nc files in year directory
    ncfiles <- list.files(path = flist[a], pattern = ".nc$",
                          full.names = TRUE)

    # create a year directory for img data output
    img_year_dir <- gsub(pattern = "nc_data", replacement = "img_data", flist[a])
    if(!dir.exists(img_year_dir)){dir.create(img_year_dir)}

    # loop through year/nc files and create img formatted clipped versions
    for(b in seq_along(ncfiles)){
      # read in raw nc data
      tmpin <- raster::raster(ncfiles[b], varname="CRW_SST")
      # tmpin <- suppressWarnings(stars::read_ncdf(ncfiles[b], var = "CRW_SST"))
      # tmpin4326 <- sf::st_set_crs(tmpin, 4326)

      # ensure cropping vector is same crs
      shpT <- sf::st_transform(shp, crs(tmpin))

      # crop worldwide nc data
      ctmpin <- raster::crop(tmpin, shpT)

      # project raster to WA albers
      wasst <- raster::projectRaster(ctmpin, res = 5000, crs = alb)

      # name and save
      ncname <- sapply(strsplit(ncfiles[b], "/"), tail, 1)
      imname <- paste0(img_year_dir, "/", gsub(pattern = ".nc",
                                               replacement = ".img",
                                               ncname))
      suppressWarnings(raster::writeRaster(wasst, filename = imname, datatype = "FLT4S",
                                           overwrite = TRUE))

    }
  }
}

#' Create extraction and cell vector shape files
#'
#' \code{create_vectors} takes a file path to img format CRW data and a study
#'     area shape file and creates extraction point and cell vector shape files.
#'
#' @details Takes a file path to img format files (the working directory where
#'     `img_data/` is found) and a study area shape file layer name as inputs
#'     and creates two vector files.
#'
#'     The first will be used by (\code{\link{extract_daily}}). It is a point
#'     shape file, derived from the centroids of the SST pixel data and can be
#'     used to extract SST data for a study area.
#'
#'     The second vector file output is a vectorised representation of the SST
#'     raster (cell boundaries) that can be used in further downstream analysis.
#'     All outputs have an EPSG of 3577.
#'
#'     The `aoi` shape file will be reprojected to EPSG 3577.
#'
#' @param pathin a character file path to the working directory (see details).
#'
#' @param aoi character representation of the shape file name of the stuady area.
#'     No file extension.
#'
#' @return two vector files. A point shape file for use in extracting data and a
#'     cell boundaries shape file. Both files will be written to the `pathin`
#'     and will have an EPSG of 3577.
#'
#' @examples
#' \dontrun{
#' create_vectors(pathin = ".", aoi = "my_study_area")
#' }
#'
#' @author Bart Huntley, \email{bart.huntley@@dbca.wa.gov.au}
#'
#' For more details see \url{https://dbca-wa.github.io/dbcaDHW/index.html}
#' {the dbcaDHW website}
#'
#' @importFrom here set_here here
#' @importFrom stars read_stars
#' @importFrom sf st_set_crs st_transform st_crop st_as_sf st_write
#'
#' @export
create_vectors <- function(pathin, shape){
  # define where we are
  here::set_here(pathin, verbose = TRUE)

  img_dat <- here::here("img_data")

  # grab one of the new nc-img files
  img <- stars::read_stars(list.files(img_dat, pattern = ".img$",
                                      recursive = TRUE, full.names = TRUE)[1])

  img3577 <- sf::st_set_crs(img, 3577)

  # study area vector
  shp <- sf::st_read(dsn = here(), layer = aoi)

  # ensure cropping vector is same crs
  shpT <- sf::st_transform(shp, st_crs(img3577))

  # crop larger sst data
  c_img <- sf::st_crop(img3577, shpT)

  # create spatial points and add id
  pts <- sf::st_as_sf(c_img, as_points = TRUE, merge = FALSE)
  pts$id <- paste0("s", sprintf("%04d", 1:dim(pts)[1]))
  suppressWarnings(sf::st_write(pts, dsn = here::here("extraction_pts_3577.shp")))

  # create cells
  cells <- sf::st_as_sf(c_img, as_points = FALSE, merge = FALSE)
  cells$id <- paste0("s", sprintf("%04d", 1:dim(cells)[1]))
  suppressWarnings(sf::st_write(cells, dsn = here::herehere("cells_bnds_3577.shp")))

}

#' Extract daily SST values
#'
#'\code{extract_daily} takes a file path to img format CRW data and previosly
#'    created extraction shape file, extracts daily SST values and outputs to
#'    csv.
#'
#' @details Takes a file path to img format files (the working directory where
#'     `img_data/` is found), previously created by (\code{\link{nc_to_img}}),
#'     then using the previously created extraction shape file
#'     (\code{\link{create_vectors}}), extracts daily SST values and writes them
#'     to csv.
#'
#' @param pathin a character file path to the working directory (see details).
#'
#' @return a csv format file containing daily SST data for all points in the
#'     extraction shape file.
#'
#' @examples
#' \dontrun{
#' extract_daily(pathin = ".")
#' }
#'
#' @author Bart Huntley, \email{bart.huntley@@dbca.wa.gov.au}
#'
#' For more details see \url{https://dbca-wa.github.io/dbcaDHW/index.html}
#' {the dbcaDHW website}
#'
#' @importFrom here set_here here
#' @importFrom sf st_read
#' @importFrom lubridate ymd
#' @importFrom tibble tibble
#' @importFrom raster raster extract
#' @importFrom readr write_csv
#'
#' @export
extract_daily <- function(pathin){
  # define where we are
  here::set_here(pathin, verbose = TRUE)

  # grab a list year folders
  flist <- list.dirs(path = here::here("img_data"), recursive = FALSE)

  # extraction shape file
  shp <- sf::st_read(dsn = here::here(), layer = "extraction_pts_3577")

  # top loop for iterating year folders
  for(a in seq_along(flist)){
    img_list <- list.files(flist[a], pattern = ".img$", full.names = TRUE)
    d1 <- sapply(str_split(str_extract(img_list,
                                       "([0-9]+){8}.*$"), "[.]"), "[[", 1)
    dates <- lubridate::ymd(d1)
    results <- tibble::tibble()

    # internal loop over each day
    for(b in seq_along(img_list)){
      img <- suppressWarnings(raster::raster(img_list[b]))
      out <- suppressWarnings(raster::extract(img, shp))
      results <- rbind(results, out)
    }

    # export year results
    names(results) <- shp$id
    results_out <- tibble::tibble(date = dates, results)
    cyr <- sapply(str_split(flist[a], "/"), tail, 1)
    readr::write_csv(results_out,
                     path = paste0(flist[a], "/", cyr, "_daily_SST.csv"))
  }

  # combine all results and export
  all_results <- list.files(path = here("img_data"), pattern = "SST.csv",
                            recursive = TRUE, full.names = TRUE) %>%
    map_df(~read_csv(.))
  csvName <- paste(all_results[[1]][1], all_results[[1]][dim(all_results)[1]], sep = "_")
  readr::write_csv(all_results, path = paste0("CRW3_1_extract_", csvName,
                                              "_SST_data.csv"))
}
