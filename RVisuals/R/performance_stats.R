if(!require(tidyverse)) install.packages("tidyverse")
if(!require(readr)) install.packages("readr")

library(tidyverse)
library(readr)
library(dplyr)

# read the data
perf_data <- read.csv(file.path("data", "collections_perf.csv"), header = F, 
         col.names = c("collection_type", "fill_time", "sum_time",
                       "fill_gc0", "fill_gc1", "fill_gc2", 
                       "sum_gc0", "sum_gc1", "sum_gc2" ))

# convert to long format suitable for aggregation and graphing
perf_data_long <- perf_data %>% 
  pivot_longer(cols = c(-collection_type), names_to = "measure", values_to = "value") 

# summarize the data
perf_summaries <- perf_data_long %>% 
  filter(measure %in% c("fill_time", "sum_time")) %>% 
  group_by(collection_type, measure) %>% 
  summarise(avg = mean(value))

# graph it
perf_summaries %>% 
    ggplot() + geom_col(aes(x=measure, y=avg)) + facet_grid(.~collection_type)


