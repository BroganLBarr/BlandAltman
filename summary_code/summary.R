# Main function for plotting linear and quadratic fits
# to measurements with proportional bias
#
# @param measured_value_1
#   Measurements from first instrument
# @param measured_value_2
#   Measurements from second instrument (must be
#   same length as measured_value_1)
# @param range
#   Define the range to plot for the x-axis
plot_reliability <- function(measured_value_1,
                             measured_value_2,
                             label_1,
                             label_2,
                             range) {
    data <- data.frame(
        average_value = 0.5 * (measured_value_1 + measured_value_2),
        difference = measured_value_1 - measured_value_2,
        stringsAsFactors = FALSE
    )

    plot_ci(linear_fit(data), data, range)
    # save the plot to file here

    plot_ci(quadratic_fit(data), data, range)
    # save the plot to file here
}

# Fit a straight line through the
# differences (linear regression)
#
# @param data
#    This data.frame has columns:
#    - average_value: the mean of the two measurements
#    - difference: the differences of the two measurements
#
# @return
#   Vector of the modelled differences based on a linear
#   fit to the actual differences.
linear_fit <- function(data) {
    fit <- lm(difference ~ average_value, data)

    modelled_difference <- fit$coefficients[[1]] +
        fit$coefficients[[2]] * data$average_value

    return(modelled_difference)
}

# Fit a quadratic line through the
# differences
#
# @param data
#    This data.frame has columns:
#    - average_value: the mean of the two measurements
#    - difference: the differences of the two measurements
#
# @return
#   Vector of the modelled differences based on a quadratic
#   fit to the actual differences.
quadratic_fit <- function(data) {
    data$average_squared <- data$average_value**2
    fit <- lm(difference ~ average_value + average_squared, data)

    modelled_difference <- fit$coefficients[[1]] +
        fit$coefficients[[2]] * data$average_value +
        fit$coefficients[[3]] * data$average_value * data$average_value
    return(modelled_difference)
}

# Plot the confidence intervals using the modeled differences
# compared with the actual measurements
#
# @param modeled_differences
#    The output from either linear_fit or quadratic_fit
# @param data
#    This data.frame has columns:
#    - average_value: the mean of the two measurements
#    - difference: the differences of the two measurements
# @param range
#   Define the range to plot for the x-axis
plot_ci <- function(modeled_differences, data, range) {
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

    loa_error <- sqrt(2.92) * sd(average_value) /
        sqrt(length(modeled_differences))
    mean_difference_error <- sd(average_value) /
        sqrt(length(modeled_differences))

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
        xlab("Average measurement") +
        ylab("Difference") +
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
