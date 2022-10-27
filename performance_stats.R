
##############################################################
# visualize dotnet core array performance
# the data is is a form of a csv from running a dotnet core app 
# and taking measurements.
# 
# Array type: 
#  - regular array int[]
#  - generic List<int>
#  - arraylist
# 
# Metrics
#  - fill_time - time for populating collection
#  - sum_time - time for summing the values in the collection
#
#  - fill_gc0 - # of gen 0 a garbage collection while populating the array
#  - fill_gc1 - # of gen 1 a garbage collection while populating the array
#  - fill_gc2 - # of gen 2 a garbage collection while populating the array
#
#  - sum_gc0  - # of gen 0 a garbage collection while summing the values in the array
#  - sum_gc1  - # of gen 1 a garbage collection while summing the values in the array
#  - sum_gc2  - # of gen 2 a garbage collection while summing the values in the array


##############################################################
if(!require(tidyverse)) install.packages("tidyverse")
if(!require(readr)) install.packages("readr")

library(tidyverse)
library(readr)
library(dplyr)


# read the data
file_path <- "arrays_performance.csv"
perf_data <- read.csv(file_path, header = F, 
         col.names = c("collection_type", "fill_time", "sum_time",
                       "fill_gc0", "fill_gc1", "fill_gc2", 
                       "sum_gc0", "sum_gc1", "sum_gc2" ))

# convert to long format suitable for aggregation and graphing
perf_data_long <- perf_data %>% 
  pivot_longer(cols = c(-collection_type), names_to = "measure", values_to = "value") 

# summarize performance for filling collection and summation
performance_fill_and_sum <- perf_data_long %>% 
  filter(measure %in% c("fill_time", "sum_time")) %>% 
  group_by(collection_type, measure) %>% 
  summarise(avg = mean(value))

# summarize performance for garbage collection
performance_fill_gc <- perf_data_long %>% 
  filter(measure %in% c("fill_gc0", "fill_gc1")) %>% 
  group_by(collection_type, measure) %>% 
  summarise(avg = mean(value))

# gc for filling array
performance_fill_gc <- perf_data_long %>% 
  filter(measure %in% c("fill_gc0", "fill_gc1")) %>% 
  group_by(collection_type, measure) %>% 
  summarise(avg = mean(value))

# gc for summing array values
performance_sum_gc <- perf_data_long %>% 
  filter(measure %in% c("sum_gc0", "sum_gc1")) %>% 
  group_by(collection_type, measure) %>% 
  summarise(avg = mean(value))


performance_fill_and_sum
performance_fill_gc
performance_sum_gc

# graph filling and summation performance
performance_fill_and_sum %>% 
   ggplot() + geom_bar(aes(x=measure, y=avg, fill=measure), stat = "identity") + 
   facet_grid(. ~ collection_type)

# graph garbage collection performance
performance_fill_gc %>% 
  ggplot() + geom_bar(aes(x=measure, y=avg, fill=measure), stat = "identity") + 
  facet_grid(. ~ collection_type)

performance_sum_gc %>% 
  ggplot() + geom_bar(aes(x=measure, y=avg, fill=measure), stat = "identity") + 
  facet_grid(. ~ collection_type)