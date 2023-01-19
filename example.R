# This script demonstrates Bland-Altman plots using a simple synthetic data set
# with random noise and an artificially produced bias in one instrument.
# See R/functions.R for more details on the synthetic instruments and how the
# bias is produced.
#
# Run each line individually to see the plots as you go or run the whole script
# and see the key results in the /images/ directory.
library(dplyr)
library(ggplot2)
library(blandr)
library(gridExtra)
library(ggpubr)
source("R/functions.R")
source("R/bland-altman_no_proportional_bias.R")
source("R/bland-altman_with_proportional_bias.R")

# Create some synthetic data
number_of_observations <- 300
real_data <- runif(number_of_observations, 0, 10) # the "real" observation

# Create some synthetic measurements with the same, non-biased instrument
measured_value_1 <- sapply(real_data, instrument_1)
measured_value_2 <- sapply(real_data, instrument_1)

# For unbiased data we can use the blandr package by running the function
# below.
plot_reliability_no_bias(
  measured_value_1,
  measured_value_2,
  "Rater mean score",
  "Rater difference",
  c(0, 10)
)
ggsave(paste0("images/example_1_no_bias.png"), height = 5, width = 10)


# Create some synthetic measurements using two different instruments, in this
# case instrument_2 has a bias
measured_value_1 <- sapply(real_data, instrument_1)
measured_value_2 <- sapply(real_data, instrument_2)

difference <-  measured_value_1 - measured_value_2

# Run these lines to see the differences between the two instruments,
# and the difference with respect to the real observations
plot_differences(measured_value_1, measured_value_2)
plot_differences_wrt_data(real_data, difference)

# Create a data frame to easily pass the data into functions below.
# Since we know the real value, we can use that instead of the average of the
# measurements.
data <- data.frame(average_value=real_data, difference, stringsAsFactors = FALSE)

# Plot without any fit to the differences
plot_simple_ci(data)

# Plot using a linear fit to the differences
plot_ci(linear_fit(data), data, "Rater mean score", "Rater difference")
ggsave(paste0("images/example_2_with_bias_linear_fit.png"), height = 5, width = 10)

# Plot using a quadratic fit to the differences
plot_ci(quadratic_fit(data), data, "Rater mean score", "Rater difference")
ggsave(paste0("images/example_2_with_bias_quadratic_fit.png"), height = 5, width = 10)
