
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dbcaDHW <img src="man/figures/dbcaDHWlogo2011.png" align="right" style="padding-left:10px;background-color:white;" />

<!-- badges: start -->

[![Project Status: Active â€“ The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
[![GitHub
issues](https://img.shields.io/github/issues/dbca-wa/rivRmon.svg?style=popout)](https://github.com/dbca-wa/rivRmon/issues/)
[![Last-changedate](https://img.shields.io/github/last-commit/dbca-wa/rivRmon.svg)](https://github.com/dbca-wa/rivRmon/commits/master)
[![Travis build
status](https://travis-ci.org/dbca-wa/rivRmon.svg?branch=master)](https://travis-ci.org/dbca-wa/rivRmon)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/dbca-wa/rivRmon?branch=master&svg=true)](https://ci.appveyor.com/project/dbca-wa/rivRmon)
[![Github top
language](https://img.shields.io/github/languages/top/dbca-wa/rivRmon.svg)](https://github.com/dbca-wa/rivRmon/)
[![DOI](https://zenodo.org/badge/202643428.svg)](https://zenodo.org/badge/latestdoi/202643428)
<!-- badges: end -->

The goal of `dbcaDHW` is to provide tools to prepare downloaded nc
format sea surface temperature (SST) data for further analysis. The
package provides additional vignettes that demonstrate how to create
useful SST metrics including degree heating weeks.

The functions and workflow presented created the various SST metrics
that were used in the Global Change Biology journal paper, [“Too hot to
handle:Unprecedented seagrass death driven by marine heatwave in a World
Heritage
Area”](https://onlinelibrary.wiley.com/doi/abs/10.1111/gcb.15065).
Please see the paper for details on how the metrics were used to model
the spatial variation in loss of seagrass in Shark Bay.

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
