
file <- './87695-IncidentReport_2017-02-21_233917.XLSX - UpstreamIncident.csv'
dd <- read.csv(file, stringsAsFactors = FALSE,
               header=T)

out <- dd[, c(1,9)]

write.csv(out, './data/spills_lsd.csv', 
          row.names = FALSE,
          quote = FALSE)
write.csv(unique(out$Land.Dls.Id), './unqique_lsd.csv', row.names = FALSE, quote = FALSE)

