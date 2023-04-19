
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ecopiapi

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The goal of ecopiapi is to Get, post, patch data from the ecop API.

## Installation

You can install the development version of ecopiapi from
[GitHub](https://github.com/) with: You will need your Github PAT for
authentication (privat repo).

``` r
# install.packages("devtools")
devtools::install_github("OekoFor/ecopiapi", auth_token = {GITHUB_PAT})
```

Install a specific version

``` r
devtools::install_github("OekoFor/ecopiapi@0.0.9", auth_token = {GITHUB_PAT})
```

## Example

``` r
library(ecopiapi)
get_detections_list(params = list("project_name" = "017_neeri", "datetime__month" = 3))
get_latest_detections()
get_latest_detections_by_project(project_name = "017_neeri")
get_latest_detections_by_recorder(recorder_name = "00000000d76d0bf9")
get_latest_detections_by_recordergroup(project_name = "053_sion", recordergroup_name = "lapwing")
get_recordings_list(params = list("project_name" = "017_neeri", "datetime__month" = 3))
```
