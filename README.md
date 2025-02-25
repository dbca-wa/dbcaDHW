
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dbcaDHW <img src="man/figures/dbcaDHWlogo2011.png" align="right" style="padding-left:10px;background-color:white;" />

<!-- badges: start -->

[![Project Status: Unsupported – The project has reached a stable,
usable state but the author(s) have ceased all work on it. A new
maintainer may be
desired.](https://www.repostatus.org/badges/latest/unsupported.svg)](https://www.repostatus.org/#unsupported)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
[![GitHub
issues](https://img.shields.io/github/issues/dbca-wa/dbcaDHW.svg?style=popout)](https://github.com/dbca-wa/dbcaDHW/issues/)
[![Last-changedate](https://img.shields.io/github/last-commit/dbca-wa/dbcaDHW.svg)](https://github.com/dbca-wa/dbcaDHW/commits/master)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/dbca-wa/dbcaDHW?branch=master&svg=true)](https://ci.appveyor.com/project/dbca-wa/dbcaDHW)
[![Github top
language](https://img.shields.io/github/languages/top/dbca-wa/dbcaDHW.svg)](https://github.com/dbca-wa/dbcaDHW/)
[![DOI](https://zenodo.org/badge/276774721.svg)](https://zenodo.org/badge/latestdoi/276774721)
<!-- badges: end -->

The goal of `dbcaDHW` is to provide tools to prepare downloaded nc
format sea surface temperature (SST) data for further analysis.
`dbcaDHW` has been specifically designed to work with data downloaded
from NOAA’s Coral Reef Watch
[website](https://coralreefwatch.noaa.gov/product/5km/). The package
provides additional vignettes that demonstrate how to create useful SST
metrics including degree heating weeks.

The functions and workflow presented created the various SST metrics
that were used in the Global Change Biology journal
[paper](https://onlinelibrary.wiley.com/doi/abs/10.1111/gcb.15065),
*“Too hot to handle: Unprecedented seagrass death driven by marine
heatwave in a World Heritage Area”*. Please see the paper for details on
how the metrics were used to model the spatial variation in loss of
seagrass in Shark Bay.

## Installation

You can install the development version from
[GitHub](https://github.com/dbca-wa) with:

``` r
# install.packages("devtools")
devtools::install_github("dbca-wa/dbcaDHW")
library(dbcaDHW)
```

## Help Files

All functions within `dbcaDHW` have the usual R help files, however the
best place to see these and the vignettes is the [dbcaDHW
website](https://dbca-wa.github.io/dbcaDHW/index.html)
