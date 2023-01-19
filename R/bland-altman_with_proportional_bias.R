plot_reliability <- function(measured_value_1,
                             measured_value_2,
                             label_1,
                             label_2,
                             range,
                             filename = NULL) {
  average_value <- 0.5 * (measured_value_1 + measured_value_2)

  difference <- measured_value_1 - measured_value_2

  data <- data.frame(
    average_value,
    difference,
    stringsAsFactors = FALSE
  )


  plot <- plot_ci(linear_fit(data), data, label_1, label_2)
  ggsave(
    paste0("plot_linear_", filename, ".pdf"),
    height = 5,
    width = 10
  )

  plot_ci(quadratic_fit(data), data, label_1, label_2, range)

  if (!is.null(filename)) {
    ggsave(
      paste0("plot_quadratic_", filename, ".pdf"),
      height = 5,
      width = 10
    )
  }
  return(plot)
}
