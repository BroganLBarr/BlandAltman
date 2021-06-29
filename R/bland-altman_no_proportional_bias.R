plot_reliability_no_bias <- function(measured_value_1, measured_value_2, label_1, label_2, range, filename = NULL) {
  values <- blandr.statistics(
    measured_value_1,
    measured_value_2,
    sig.level=0.95,
    LoA.mode = 1
  )

  #clean up the display
  blandr.output.text (measured_value_1, measured_value_2, sig.level=0.95)

  caption_text = expression(
    paste(
      italic("Note:"),
      "ULA = Upper limits of agreement, M diff = grand mean of difference between rater scores,
         LLA = lower limits of agreement, VPPS = Vanderbilt Psychotherapeutic Process Scale"
    )
  )

  central_point <- 0.5 * (range[[2]] + range[[1]])

  if (mean(measured_value_1) > central_point) {
    text_position <- range[[1]] + 0.5
  } else {
    text_position <- 0.9 * range[[2]]
  }

  result <- blandr.draw(
    measured_value_1,
    measured_value_2,
    sig.level=0.95,
    ciShading = FALSE,
    plotTitle = ""
  ) +
    scale_y_continuous(breaks=seq(-3, 3), limits = c(-3,3)) +
    xlim(range[[1]], range[[2]]) +
    xlab(label_1) +
    ylab(label_2) +
    annotate("text", x = text_position, y = 1.5 * values$upperLOA, label = paste("ULA =", round(values$upperLOA, 2))) +
    annotate("text", x = text_position, y = 1.5 * values$lowerLOA, label = paste("ULA =", round(values$lowerLOA, 2))) +
    annotate("text", x = text_position, y = 0.3, label = paste("M diff =", round(values$biasSEM, 2))) +
    theme_bw() +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
    theme(plot.caption = element_text(hjust = 0, vjust = -2)) +
    theme(text = element_text(size=16, family="serif"))

  # Remove the horizontal line at y = 0
  result$layers[[2]] <- NULL

  if (!is.null(filename)) {
    ggsave(paste0("plot_", filename, ".pdf"), plot = result, height = 5, width = 10)
  }

  return(result)
}
