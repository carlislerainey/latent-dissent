
# load packages
library(tidyverse)
library(dataverse)
library(httr)

## Note: see https://github.com/IQSS/dataverse-client-r/issues/17 and 
## https://github.com/IQSS/dataverse/issues/4373 for a couple of wierd
## issues with this particular dataverse repo. I think for some reason
## this breaks the dataverse::get_data() function

# set up 
Sys.setenv("DATAVERSE_SERVER" = "dataverse.harvard.edu")
dataset <- get_dataset("hdl:1902.1/FYXLAWZRIA")
dataset$files[c("filename", "contentType")]

# files to download from dataverse
filenames <- c("Sectors of Source _ Target.txt", 
               "Levels of Source _ Target.txt",
               "Names of Source _ Target.txt",
               "1990-1994 Data (N=2_679_938).tab",
               "1995-1999 Data (N=4_108_102)",
               "2000-2004 Data (N=3464898).tab")
# create a data frame with filenames and associated ids
filenames_df <- dataset$files[, c("label", "id")] %>%
  rename(filename = label) %>%
  filter(filename %in% filenames) %>%
  mutate(download_url = paste0("https://dataverse.harvard.edu/api/access/datafile/", id)) %>%
  glimpse()

# make the filenames compatible with make
filenames_df$clean_filename <- filenames_df$filename %>%
  # convert to lower case
  str_to_lower() %>%
  # replace spaces with dashes
  str_replace_all(" ", "-") %>%
  # remove any extensions (the raw data have .tab, .txt, and missing extensions)
  str_remove("\\.[:alnum:]*") %>%
  # add a common.txt extension
  str_c(".txt") %>%
  # quick look
  glimpse()

# set directory to save files; create if nec
dir <- "data/raw/king-lowe-2008/"
if (!dir.exists(dir)) dir.create(dir)

# download and write each file
for (i in 1:length(filenames)) {
  cat(paste0("Working on ",filenames_df$filename[i]))
  # -?- # doesn't work: file <- get_file(filenames[i], "hdl:1902.1/FYXLAWZRIA", format = "original")
  # -?- # not need bc above doesn't work: writeBin(file, paste0(dir, clean_filenames[i]))
  # -?- # see here for more https://github.com/IQSS/dataverse/issues/4373
  download.file(url = filenames_df$download_url[i], paste0(dir, filenames_df$clean_filename[i]))
}

