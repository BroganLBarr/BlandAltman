plot_reliability <- function(measured_value_1, measured_value_2, label_1, label_2, range, filename = NULL) {
  real_data = 0.5 * (measured_value_1 + measured_value_2)

  difference =  measured_value_1 - measured_value_2

  #plot_differences(measured_value_1, measured_value_2)
  #plot_differences_wrt_data(real_data, difference)

  # create a data frame to easily pass the data into functions below
  data <- data.frame(real_data, difference, stringsAsFactors = FALSE)

  #plot_simple_ci(data)

  plot_ci(linear_fit(data), data, label_1, label_2)
  ggsave(paste0("plot_linear_", filename, ".pdf"), height = 5, width = 10)

  plot <- plot_ci(quadratic_fit(data), data, label_1, label_2, range)

  if (!is.null(filename)) {
    ggsave(paste0("plot_quadratic_", filename, ".pdf"), height = 5, width = 10)
  }
  return(plot)
}
