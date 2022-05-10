if(!require(tidyverse)) install.packages("tidyverse")
if(!require(readr)) install.packages("readr")


library(tidyverse)
library(readr)
library(dplyr)

perf_data <- read.csv(file.path("data", "collections_perf.csv"), header = F, 
         col.names = c("collection_type", "fill_time", "sum_time",
                       "fill_gc0", "fill_gc1", "fill_gc2", 
                       "sum_gc0", "sum_gc1", "sum_gc2" ))



perf_sumamries <- perf_data %>% group_by(collection_type) %>% 
  summarise(avg_fill_time = mean(fill_time),
            avg_sum_time = mean(sum_time),
            avg_fill_gc0 = mean(fill_gc0),
            avg_fill_gc1 = mean(fill_gc1),
            avg_fill_gc2 = mean(fill_gc2),
            avg_sum_gc0 = mean(sum_gc0),
            avg_sum_gc1 = mean(sum_gc1),
            avg_sum_gc2 = mean(sum_gc2)
            )


perf_sumamries %>% ggplot() + 
  geom_col(aes(x=collection_type, y=avg_fill_time))
  
  
perf_sumamries %>% ggplot() + 
    geom_col(aes(x=collection_type, y=avg_sum_time))


