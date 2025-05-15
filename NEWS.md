# ecopiapi 0.3.1
- added get_response argument to resp_body_json_to_df() and all get_* functions in order to be able to return the raw response from the API

# ecopiapi 0.3.0
 - get_aggregations_project_time_series
 -get_aggregations_project_recorder_time_series

# ecopiapi 0.2.11
- added aggregations_project_detections_count, where you can also specify groups like recorder and species

# ecopiapi 0.2.10
- added aggregation endpoint - detection counts per recording .

# ecopiapi 0.2.9
- aggregation endpoint url change adaption

# ecopiapi 0.2.8
- added option to set request URL , to access the dev backend/api

# ecopiapi 0.2.7
- added get_by_url() to get linked URL endpoints from other get functions

# ecopiapi 0.2.6
- added include_validation_status to get_recorderSpeciesCounts()

# ecopiapi 0.2.5
- switch to backend api v0.2

# ecopiapi 0.2.4

# ecopiapi 0.2.3
- adapted patch_detection() to be able to patch empty/ blank comments (i.o.w. deleting old comments)

# ecopiapi 0.2.2
new function get_detetcions_retrieve()

# ecopiapi 0.2.1

- return NULL when response body is empty instead of erroring

# ecopiapi 0.2.0

