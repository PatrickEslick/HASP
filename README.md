# HASP <img src="man/figures/R_logo.png" alt="HASP" height="150px" align="right" />

[![R build
status](https://github.com/USGS-R/HASP/workflows/R-CMD-check/badge.svg)](https://github.com/USGS-R/HASP/actions)
[![Coverage
Status](https://coveralls.io/repos/github/USGS-R/HASP/badge.svg?branch=master)](https://coveralls.io/github/USGS-R/HASP?branch=master)
[![codecov](https://codecov.io/gh/USGS-R/HASP/branch/master/graph/badge.svg)](https://codecov.io/gh/USGS-R/HASP)
[![status](https://img.shields.io/badge/USGS-Research-blue.svg)](https://owi.usgs.gov/R/packages.html#research)

Hydrologic AnalySis Package

Inspiration: <https://fl.water.usgs.gov/mapper/>

## Sample workflow

### Single site workflows:

``` r
library(HASP)
library(dataRetrieval)
site <- "263819081585801"

#Field GWL data:
gwl_data <- dataRetrieval::readNWISgwl(site)

# Daily data:
parameterCd <- "62610"
statCd <- "00001"
dv <- dataRetrieval::readNWISdv(site,
                                parameterCd,
                                statCd = statCd)

# Water Quality data:
parameterCd <- c("00095","90095","00940","99220")
qw_data <- dataRetrieval::readNWISqw(site,
                                     parameterCd)
```

``` r

y_axis_label <- dataRetrieval::readNWISpCode("62610")$parameter_nm

monthly_frequency_plot(dv,
                       date_col = "Date",
                       value_col = "X_62610_00001",
                       approved_col = "X_62610_00001_cd",
                       plot_title = "L2701_example_data",
                       y_axis_label = y_axis_label)
```

![](man/figures/README-graphs-1.png)<!-- -->

``` r

gwl_plot_all(dv, gwl_data, 
             date_col = c("Date", "lev_dt"),
             value_col = c("X_62610_00001", "sl_lev_va"),
             approved_col = c("X_62610_00001_cd",
                              "lev_age_cd"),
             plot_title = "L2701_example_data", 
             add_trend = TRUE, flip_y = FALSE)
```

![](man/figures/README-graphs-2.png)<!-- -->

``` r

Sc_Cl_plot(qw_data, "L2701_example_data")
```

![](man/figures/README-graphs-3.png)<!-- -->

``` r
trend_plot(qw_data, plot_title = "L2701_example_data")
```

![](man/figures/README-graphs-4.png)<!-- -->

### Composite workflows:

``` r

#included sample data:

aquifer_data <- aquifer_data
sum_col <- "lev_va"
num_years <- 30

plot_composite_data(aquifer_data, sum_col, num_years)
```

![](man/figures/README-example-1.png)<!-- -->

``` r

plot_normalized_data(aquifer_data, sum_col, num_years)
```

![](man/figures/README-example-2.png)<!-- -->

## Shiny App

<p align="center">

<img src="https://code.usgs.gov/water/stats/HASP/raw/master/man/figures/app.gif" alt="app_demo">

</p>

## Installation

You can install the `HASP` package using the `remotes` package:

``` r
remotes::install_gitlab("water/stats/HASP", 
                        host = "code.usgs.gov"))
```

## Disclaimer

This software is preliminary or provisional and is subject to revision.
It is being provided to meet the need for timely best science. The
software has not received final approval by the U.S. Geological Survey
(USGS). No warranty, expressed or implied, is made by the USGS or the
U.S. Government as to the functionality of the software and related
material nor shall the fact of release constitute any such warranty. The
software is provided on the condition that neither the USGS nor the U.S.
Government shall be held liable for any damages resulting from the
authorized or unauthorized use of the software.
