setwd("~/timeseries_map")

library(xts)
library(dplyr)
library(rgdal)

shape_path<-"~/geographic shape files 2018"

nyc_zip_shp=readOGR(dsn=shape_path,layer="ZIP_CODE_040114",verbose=FALSE)

nyc_zip_file=spTransform(nyc_zip_shp, CRS("+proj=longlat +datum=WGS84"))

nyc_zip_file<-nyc_zip_file[order(nyc_zip_file$ZIPCODE),]

date<-seq(as.Date("2015-01-01"), as.Date("2015-01-10"), by="day")
zip_codes<-unique(nyc_zip_file@data$ZIPCODE)
df <- data.frame(expand.grid(date, zip_codes))
colnames(df)<-c("date","ZIPCODE")
df$has_lyme<-sample(100, size = nrow(df), replace = TRUE)

