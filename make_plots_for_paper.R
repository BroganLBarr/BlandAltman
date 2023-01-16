library(dplyr)
library(blandr)
library(ggplot2)
library(gridExtra)
library(ggpubr)
library(irr)
source("R/functions.R")
source("R/bland-altman_no_proportional_bias.R")
source("R/bland-altman_with_proportional_bias.R")

vtas_range <- c(0, 5)
vpps_range <- c(1, 5)

reliabilitydata <- read.csv(
  "data.csv"
)

plot_paitent_factor <- plot_reliability_no_bias(
  reliabilitydata$VTAS_PtFac.1,
  reliabilitydata$VTAS_PtFac.2,
  "VTAS Patient Factor Mean Score",
  "VTAS Patient Factor Difference",
  vtas_range,
  "Paitent factor"
)

plot_therapist_factor <- plot_reliability_no_bias(
  reliabilitydata$VTAS_TherFac.1,
  reliabilitydata$VTAS_TherFac.2,
  "VTAS Therapist Factor Mean Score",
  "VTAS Therapist Factor Difference",
  vtas_range,
  "Therapist Factor"
)

compute_statistics_no_bias(
  reliabilitydata$VTAS_TherFac.1,
  reliabilitydata$VTAS_TherFac.2
)


plot_patient_exploration <- plot_reliability_no_bias(
  reliabilitydata$VPPS_Pt_Exploration.1,
  reliabilitydata$VPPS_Pt_Exploration.2,
  "VPPS Patient Exploration Mean Score",
  "VPPS Patient Exploration Difference",
  vpps_range,
  "Patient Exploration"
)

plot_distress <- plot_reliability_no_bias(
  reliabilitydata$VPPS_Pt_Distress.1,
  reliabilitydata$VPPS_Pt_Distress.2,
  "VPPS Patient Distress Mean Score",
  "VPPS Patient Distress Difference",
  vpps_range,
  "Patient Distress"
)

plot_hostility <- plot_reliability_no_bias(
  reliabilitydata$VPPS_Pt_Hostility.1,
  reliabilitydata$VPPS_Pt_Hostility.2,
  "VPPS Patient Hostility Mean Score",
  "VPPS Patient Hostility Difference",
  vpps_range,
  "Patient Hostility"
)


plot_therapist_exploration <- plot_reliability_no_bias(
  reliabilitydata$VPPS_Ther_Exploration.1,
  reliabilitydata$VPPS_Ther_Exploration.2,
  "VPPS Therapist Exploration Mean Score",
  "VPPS Therapist Exploration Difference",
  vpps_range,
  "Therapist Exploration"
)

plot_warmth <- plot_reliability_no_bias(
  reliabilitydata$VPPS_Ther_Warmth.1,
  reliabilitydata$VPPS_Ther_Warmth.2,
  "VPPS Therapist Warmth Mean Score",
  "VPPS Therapist Warmth Difference",
  vpps_range,
  "Therapist Warmth"
)

plot_paitent_participation_quadratic <- plot_reliability(
  reliabilitydata$VPPS_Pt_Participation.1,
  reliabilitydata$VPPS_Pt_Participation.2,
  "VPPS Patient Participation Mean Score",
  "VPPS Patient Participation Difference",
  vpps_range,
  "Patient Participation"
)

compute_statistics_no_bias(
  reliabilitydata$VPPS_Pt_Participation.1,
  reliabilitydata$VPPS_Pt_Participation.2
)

plot_neg_therapist_attitude_quadratic <- plot_reliability(
  reliabilitydata$VPPS_Neg_Ther_Att.1,
  reliabilitydata$VPPS_Neg_Ther_Att.2,
  "VPPS Negative Therapist Attitude Mean Score",
  "VPPS Negative Therapist Attitude Difference",
  vpps_range,
  "Neg therapist attitude"
)

plot_paitent_dependency_quadratic <- plot_reliability(
  reliabilitydata$VPPS_Pt_Dependency.1,
  reliabilitydata$VPPS_Pt_Dependency.2,
  "VPPS Patient Dependency Mean Score",
  "VPPS Patient Dependency Difference",
  vpps_range,
  "Patient Dependency"
)

ggarrange(plotlist = list(
  plot_therapist_factor,
  plot_warmth,
  plot_distress,
  plot_paitent_participation_quadratic,
  plot_neg_therapist_attitude_quadratic,
  plot_paitent_dependency_quadratic
  ),
  nrow = 2,
  ncol = 3,
  heights = c(10, 9)
)
ggsave("combined_plots.png", width = 18, height = 10)
