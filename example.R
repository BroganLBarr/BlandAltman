# This script demonstrates Bland-Altman plots using a simple synthetic data with random noise
# See R/functions.R for more details on the synthetic instruments and how the bias is produced
# Work through each line to see the plots

library(dplyr)
library(ggplot2)
source("R/functions.R")

number_of_observations <- 300

# set up the synthetic data
real_data <- runif(number_of_observations, 0, 10) # the "real" observation
measured_value_1 <- sapply(real_data, instrument_1) # measured value 1
measured_value_2 <- sapply(real_data, instrument_2) # measured value 2

difference <-  measured_value_1 - measured_value_2

plot_differences(measured_value_1, measured_value_2)
plot_differences_wrt_data(real_data, difference)

# create a data frame to easily pass the data into functions below
data <- data.frame(real_data, difference, stringsAsFactors = FALSE)

plot_simple_ci(data)

plot_ci(linear_fit(data), data, "Rater mean score", "Rater difference")

ggsave(paste0("images/example_linear.png"), height = 5, width = 10)

plot_ci(quadratic_fit(data), data, "Rater mean score", "Rater difference")

ggsave(paste0("images/example_quadratic.png"), height = 5, width = 10)
