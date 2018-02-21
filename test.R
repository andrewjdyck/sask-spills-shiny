
# tests
ncalls <- 100
lsd_data <- read.csv('./unqique_lsd.csv', stringsAsFactors = FALSE)[1:200, 1]
lsd_num <- length(lsd_data)
start_loc_seq <- seq(from=1, to=lsd_num, by=ncalls)
start_loc <- start_loc_seq[1]
lsd_batch <- gen_lsd_batch(lsd_data, start_loc = 1)
api_call_content <- api_batch_call(lsd_batch)
batch_json_output(
  api_call_content, 
  paste0('./json_response/response_', start_loc, '_', (start_loc + ncalls-1), '.json')
)
jj <- readLines('./json_response/response_1_100.json')
json <- fromJSON(jj, simplifyDataFrame = FALSE)

sb <- run_single_batch(lsd_data[1:100], start_loc = 1)



