# This file contains functions used for generating example data and producing the plots

# Example instruments
# Both instruments apply some random variation to the real value,
# with a mean of zero and variance of 0.1, using the rnorm function.
# Instrument 2 adds some additional random values with a bias, by adding a random
# number from a uniform range between 0 and a value proportional to the value being
# measured.  Therefore, the bias gets larger for larger values of the value
# being measured
instrument_1 <- function(real_value) {
  measured_value <- real_value + rnorm(1, 0, 1)
  return(measured_value)
}

instrument_2 <- function(real_value) {
  measured_value <- real_value +
    rnorm(1, 0, 1) -
    runif(1, 0, 0.5 * real_value + 0.08 * real_value**2)

  return(measured_value)
}

# fit a straight line through the differences (linear regression)
linear_fit <- function(data) {
  fit <- lm(difference ~ average_value, data)

  modelled_difference <- fit$coefficients[[1]] +
    fit$coefficients[[2]] * data$average_value

  return(modelled_difference)
}

# fit a quadratic line through the differences
quadratic_fit <- function(data) {
  data$average_value_squared <- data$average_value**2

  quadratic_fit <- lm(difference ~ average_value + average_value_squared, data)

  modelled_difference <- quadratic_fit$coefficients[[1]] +
    quadratic_fit$coefficients[[2]] * data$average_value +
    quadratic_fit$coefficients[[3]] * data$average_value * data$average_value
  return(modelled_difference)
}

plot_simple_ci <- function(data) {
  mean_difference <- mean(data$difference)
  sd_difference <- sd(data$difference)
  percentile <- 0.975

  crude_upper_limit <- mean_difference + qnorm(percentile) * sd_difference
  crude_lower_limit <- mean_difference - qnorm(percentile) * sd_difference

  plot(data$average_value, data$difference)
  abline(mean_difference, 0, lty = 1)
  abline(crude_lower_limit, 0, lty = 2)
  abline(crude_upper_limit, 0, lty = 2)
}


plot_ci <- function(modeled_differences,
                    data,
                    label_1 = "label1",
                    label_2 = "label2",
                    range = c(0, 5)) {
  average_value <- data$average_value

  data$residuals <- abs(modeled_differences - data$difference)

  # fit a linear model to the residuals
  fit_to_residuals <- lm(residuals ~ average_value, data)

  lower_limit <- modeled_differences + sqrt(0.5 * pi) * (
    fit_to_residuals$coefficients[[1]] +
      fit_to_residuals$coefficients[[2]] * average_value
  )
  upper_limit <- modeled_differences - sqrt(0.5 * pi) * (
    fit_to_residuals$coefficients[[1]] +
      fit_to_residuals$coefficients[[2]] * average_value
  )

  loa_error <- sqrt(2.92) * sd(average_value) / sqrt(length(modeled_differences))
  mean_difference_error <- sd(average_value) / sqrt(length(modeled_differences))

  lines_data <- data.frame(
    lower_limit = lower_limit[order(average_value)],
    upper_limit = upper_limit[order(average_value)],
    modeled_differences = modeled_differences[order(average_value)],
    x = average_value[order(average_value)],
    stringsAsFactors = FALSE
  )

  ggplot(data, aes(average_value, difference)) +
    geom_point() +
    scale_y_continuous(breaks = seq(-3, 3), limits = c(-3, 3)) +
    xlim(range[[1]], range[[2]]) +
    geom_path(
      aes(x = x, y = upper_limit),
      data = lines_data,
      linetype = 2
    ) +
    geom_path(
      aes(x = x, y = upper_limit + loa_error),
      data = lines_data,
      linetype = 3
    ) +
    geom_path(
      aes(x = x, y = upper_limit - loa_error),
      data = lines_data,
      linetype = 3
    ) +
    geom_path(
      aes(x = x, y = lower_limit),
      data = lines_data,
      linetype = 2
    ) +
    geom_path(
      aes(x = x, y = lower_limit + loa_error),
      data = lines_data,
      linetype = 3
    ) +
    geom_path(
      aes(x = x, y = lower_limit - loa_error),
      data = lines_data,
      linetype = 3
    ) +
    geom_path(
      aes(x = x, y = modeled_differences),
      data = lines_data,
      linetype = 2
    ) +
    geom_path(
      aes(x = x, y = modeled_differences + mean_difference_error),
      data = lines_data,
      linetype = 3
    ) +
    geom_path(
      aes(x = x, y = modeled_differences - mean_difference_error),
      data = lines_data,
      linetype = 3
    ) +
    xlab(label_1) +
    ylab(label_2) +
    theme_bw() +
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank()
    ) +
    theme(
      plot.caption = element_text(hjust = 0),
      text = element_text(size = 16, family = "serif")
    )
}

plot_differences <- function(measured_value_1, measured_value_2) {
  plot(
    measured_value_2,
    measured_value_1,
    xlab = "Average value",
    ylab = "Difference between instruments"
  )
  abline(0, 1)
}

plot_differences_wrt_data <- function(average_value, difference) {
  plot(
    average_value,
    difference,
    xlab = "Average value",
    ylab = "Difference between instruments"
  )
  abline(0, 0)
}
