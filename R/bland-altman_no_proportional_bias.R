compute_icc <- function(measured_value_1, measured_value_2) {
  if (length(measured_value_1) != length(measured_value_2)) {
    stop("Measurements must be the same length")
  }
  ns <- length(measured_value_1)
  average_values <- 0.5 * (measured_value_1 + measured_value_2)
  MSr <- var(average_values) * 2
  MSw <- sum((measured_value_1 - measured_value_2)**2) / (2 * ns)
  coeff <- (MSr - MSw) / MSr
  return(coeff)
}

pad <- function(s, width) {
  str_pad(s, width, side="right")
}

compute_statistics_no_bias <- function(measured_value_1, measured_value_2, subscale) {
  differences <- measured_value_1 - measured_value_2
  m_diff_text <- paste0(
    pad(round(mean(differences), 2), 5),
    " (",
    round(sd(differences), 2),
    ")"
  )
  loa_text <- paste0(
    round(mean(differences) - 1.96 * sd(differences), 2),
    ", ",
    round(mean(differences) + 1.96 * sd(differences), 2)
  )

  # Compute the ICC using the irr package to get the lbound and ubound
  icc_values <- icc(
    cbind(measured_value_1, measured_value_2),
    "oneway",
    unit = "average"
  )
  # Compute the ICC using the function above,
  # which is specific to the two measurement case
  icc_value <- compute_icc(measured_value_1, measured_value_2)

  icc_text <- paste0(
    pad(round(icc_value, 2), 4),
    " [",
    round(icc_values$lbound, 2),
    ", ",
    round(icc_values$ubound, 2),
    "]"
  )
  rater_1_mean <- mean(measured_value_1)
  rater_1_std <- sd(measured_value_1)
  mean_text <- paste0(pad(round(rater_1_mean, 2), 4), " (", round(rater_1_std, 2), ")")

  cvs <- (2 ** 0.5) * abs(measured_value_1 - measured_value_2) /
    (measured_value_1 + measured_value_2)
  cv_text <- paste0(round(100 * mean(cvs), 0), " %")

  total_mean <- mean(c(measured_value_1, measured_value_2))
  total_sd <- sd(c(measured_value_1, measured_value_2))

  print(paste(
    pad(subscale, 30),
    pad(mean_text, 15),
    pad(cv_text, 8),
    pad(icc_text, 25),
    pad(m_diff_text, 15),
    pad(loa_text, 11),
    sep = "|"
  ))
}

plot_reliability_no_bias <- function(measured_value_1,
                                     measured_value_2,
                                     label_1,
                                     label_2,
                                     range,
                                     filename = NULL) {
  values <- blandr.statistics(
    measured_value_1,
    measured_value_2,
    sig.level=0.95,
    LoA.mode = 1
  )
  # clean up the display
  blandr.output.text(measured_value_1, measured_value_2, sig.level = 0.95)

  central_point <- 0.5 * (range[[2]] + range[[1]])

  if (mean(measured_value_1) > central_point) {
    text_position <- range[[1]] + 0.5
  } else {
    text_position <- 0.9 * range[[2]]
  }

  print(values)
  result <- blandr.draw(
    measured_value_1,
    measured_value_2,
    sig.level = 0.95,
    ciShading = FALSE,
    plotTitle = ""
  ) +
    scale_y_continuous(breaks = seq(-3, 3), limits = c(-3, 3)) +
    xlim(range[[1]], range[[2]]) +
    xlab(label_1) +
    ylab(label_2) +
    annotate(
      "text",
      x = text_position,
      y = 1.5 * values$upperLOA,
      label = paste("ULA =", round(values$upperLOA, 2))
    ) +
    annotate(
      "text",
      x = text_position,
      y = 1.5 * values$lowerLOA,
      label = paste("ULA =", round(values$lowerLOA, 2))
    ) +
    annotate(
      "text",
      x = text_position,
      y = 0.3,
      label = paste("M diff =", round(values$bias, 2))
    ) +
    theme_bw() +
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank()
    ) +
    theme(plot.caption = element_text(hjust = 0, vjust = -2)) +
    theme(text = element_text(size = 16, family = "serif"))

  # Remove the horizontal line at y = 0
  result$layers[[2]] <- NULL

  if (!is.null(filename)) {
    ggsave(
      paste0("plot_", filename, ".pdf"),
      plot = result,
      height = 5,
      width = 10
    )
  }

  return(result)
}
