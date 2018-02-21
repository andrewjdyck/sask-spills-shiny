
library(jsonlite)
library(dplyr)
library(plyr)

# Functions to read JSON data files
loop_over_json <- function(lsd_data, ncalls=100) {
  lsd_num <- length(lsd_data)
  start_loc_seq <- seq(from=1, to=lsd_num, by=ncalls)
  allJsonLists <- lapply(start_loc_seq, function(x) read_json_file(lsd_num, x))
  return(allJsonLists)
}

read_json_file <- function(lsd_num, start_loc, ncalls=100) {
  json_filename <- gen_json_filename(lsd_num, start_loc)
  jsonList <- fromJSON(json_filename, simplifyDataFrame = FALSE)
  return(jsonList)
}

gen_json_filename <- function(lsd_num, start_loc, ncalls=100) {
  end_loc <- ifelse(start_loc + ncalls - 1 <= lsd_num, start_loc + ncalls - 1, lsd_num)
  json_filename <- paste0('./json_response/response_', start_loc, '_', end_loc, '.json')
  return(json_filename)
}


# Run the JSON data file reading
json_list <- unlist(loop_over_json(lsd_data), recursive = FALSE)
full_json <- toJSON(json_list)
write(full_json, './full_lsd_api_response.json')

extract_lat_lng <- function(list_element) {
  lsd <- list_element$query
  if (list_element$response$status == 'ok') {
    lat = list_element$response$lat
    lng = list_element$response$lng
  } else {
    lat = NA
    lng = NA
  }
  df <- data.frame(
    lsd = lsd,
    lat = lat,
    lng = lng,
    stringsAsFactors = FALSE
  )
  return(df)
}

# tt <- lapply(json_list, extract_lat_lng)
out_df <- ldply(lapply(json_list, extract_lat_lng), data.frame)
write.csv(out_df, './lsd_geocoded.csv', row.names = FALSE)





