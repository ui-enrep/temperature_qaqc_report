library(tidyverse)
library(knitr)
library(markdown)
library(rmarkdown)
library(here)

#-----------------------------------------------------------------------------------------------------------------
#  Use this script to iterate through multiple working basins.  This allows you to take a folder of CSVs from all
#  basins and it will process all data and generate a report for each basin.
#-----------------------------------------------------------------------------------------------------------------

# Set local location of this file.
here::i_am("scripts/temperature_QA_report_iterator.R")

# Location of CSV files. The retrieval of files is recursive so files may be in sub directory structure (e.g. BN, BS, SN, etc)
filePath <- here("data_input/csv_data_files")

# Location of the "key".  This is a table relating serial number to sensor locations.
# Currently, this needs to have the following columns in this order: 
# basin_name_abrv,	Station,	SensorMedium,	StationID,	SensorID,	serial  
stationKeyLoc <- here("metadata/temperature_logger_serial_lookup.csv")

## Create list of basin names to iterate through.  Only include basins where there is that basin's data in "data_input/csv_data_files." 
serialNumsInDirectory <- list.files(path = filePath, pattern = "*.csv", include.dirs = FALSE, recursive = TRUE) %>% tools::file_path_sans_ext()
basinNames <- read_csv(stationKeyLoc) %>%
  filter(serial %in% serialNumsInDirectory) %>%
  pull(basin_name_abrv) %>% unique()
  
# Iterate over each basin.  Broadly, this is doing:
#   1) Create html report with graphs of air/subsurface/surface temp sensors at each reach break
#   2) Add more information to the raw csv files including UTC time, basin, and reach break values.
#   3) Save CSV files with appropriate filenames.  For example: tw_air_02.csv is the air tidbit at reach break 
#      (station) 2 in the Tripps Knob West basin.
for(workingBasin in basinNames){  
rmarkdown::render(here("scripts/temperature_QA_report_iterator_V3.Rmd"),
                  output_file = paste("report_", workingBasin, ".html", sep = ""),
                  output_dir = here("data_output"))
}





