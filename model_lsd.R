

dd <- read.csv('./data/lsd_geocoded.csv', stringsAsFactors = FALSE)

dd$sub <- substr(dd$lsd, 1, 2)
dd$section <- substr(dd$lsd, 4, 5)
dd$township <- substr(dd$lsd, 7, 9)
dd$range <- substr(dd$lsd, 11, 12)
dd$meridiandir <- substr(dd$lsd, 13, 13)
dd$meridian <- substr(dd$lsd, 14, length(dd$lsd))
dd$quarter <- sapply(dd$sub, set_quarter)


set_quarter <- function(legal_subdivision_num) {
  quarter <- ''
  legal_subdivision_num <- as.numeric(legal_subdivision_num)
  if (legal_subdivision_num %in% c(1,2,7,8)) {
    quarter <- 'SE'
  } else if (legal_subdivision_num %in% c(3, 4, 5, 6)) {
    quarter <- 'SW'
  } else if (legal_subdivision_num %in% c(9,10,15,16)) {
    quarter <- 'NE'
  } else if (legal_subdivision_num %in% c(11,12,13,14)) {
    quarter <- 'NW'
  }
  return(quarter)
}
