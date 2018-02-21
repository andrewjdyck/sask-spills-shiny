
library(httr)
library(jsonlite)

# CSV Data
# out <- read.csv('~/Dropbox/business/opendatask.ca/temp_spill_data/spills_lsd.csv', 
#                 header=T, stringsAsFactors = FALSE)

# Functions
check_lookups <- function(api_key=return_api_key()) {
  sub_status_url <- paste0('https://www.lsdfinder.com/api/v1/', api_key, '/quota')
  call <- GET(sub_status_url)
  res <- content(call)
  return(res$lookups)
}

return_api_key <- function() {
  return(readLines(con=file('./api_key.txt')))
}

loop_over_lsd <- function(lsd_data, ncalls=100) {
  lsd_num <- length(lsd_data)
  start_loc_seq <- seq(from=1, to=lsd_num, by=ncalls)
  rem_calls <- check_lookups()
  # tryCatch({
  #   rem_calls >= lsd_num
  # }, error = function(e) {
  #   print('Not enough calls remaining to process data')
  # }, 
  # finally = )
  sapply(start_loc_seq, function(x) run_single_batch(lsd_data, x))
}

run_single_batch <- function(lsd_data, start_loc, ncalls=100) {
  end_loc <- ifelse(start_loc + ncalls - 1 <= length(lsd_data), start_loc + ncalls - 1, length(lsd_data))
  lsd_batch <- gen_lsd_batch(lsd_data, start_loc, end_loc)
  api_call_content <- api_batch_call(lsd_batch)
  batch_json_output(api_call_content, paste0('./json_response/response_', start_loc, '_', end_loc, '.json'))
}

gen_lsd_batch <- function(data, start_loc, end_loc, ncalls=100) {
  lsd_batch_vec <- data[start_loc:end_loc]
  return(lsd_batch_vec)
}

api_batch_call <- function(lsd_batch_vec) {
  url_base <- paste0('https://www.lsdfinder.com/api/v1/', return_api_key(), '/lsd/')
  # e <- simpleError('Batch call cannot be > 100')
  # tryCatch(
  #   length(lsd_batch_vec)<=100,
  #   finally = stop(e)
  # )
  multi_lsd <- paste(lsd_batch_vec, collapse = '|')
  call_url <- paste0(url_base, multi_lsd)
  call <- GET(call_url)
  return(content(call))
}

batch_json_output <- function(call_content, out_filename) {
  json <- toJSON(call_content)
  write(json, out_filename)
}



