library(dplyr)
library(blandr)
library(ggplot2)
library(gridExtra)
library(ggpubr)
library(irr)
library(stringr)
source("R/functions.R")
source("R/bland-altman_no_proportional_bias.R")
source("R/bland-altman_with_proportional_bias.R")

vtas_range <- c(0, 5)
vpps_range <- c(1, 5)

reliabilitydata <- read.csv(
  "data.csv"
)

print(paste(
  pad("Subscale", 30),
  pad("M(SD)", 15),
  pad("CV (%)", 8),
  pad("ICC  [95% CIs]", 25),
  pad("M diff (SD)", 15),
  pad("LOA", 11),
  sep = "|"
))

compute_statistics_no_bias(
  reliabilitydata$VTAS_PtFac.1,
  reliabilitydata$VTAS_PtFac.2,
  "Paitent factor"
)

compute_statistics_no_bias(
  reliabilitydata$VTAS_TherFac.1,
  reliabilitydata$VTAS_TherFac.2,
  "Therapist Factor"
)

compute_statistics_no_bias(
  reliabilitydata$VPPS_Pt_Participation.1,
  reliabilitydata$VPPS_Pt_Participation.2,
  "Patient Participation"
)

compute_statistics_no_bias(
  reliabilitydata$VPPS_Pt_Exploration.1,
  reliabilitydata$VPPS_Pt_Exploration.2,
  "Patient Exploration"
)

compute_statistics_no_bias(
  reliabilitydata$VPPS_Pt_Distress.1,
  reliabilitydata$VPPS_Pt_Distress.2,
  "Patient Distress"
)

compute_statistics_no_bias(
  reliabilitydata$VPPS_Pt_Hostility.1,
  reliabilitydata$VPPS_Pt_Hostility.2,
  "Patient Hostility"
)

compute_statistics_no_bias(
  reliabilitydata$VPPS_Pt_Dependency.1,
  reliabilitydata$VPPS_Pt_Dependency.2,
  "Patient Dependency"
)

compute_statistics_no_bias(
  reliabilitydata$VPPS_Neg_Ther_Att.1,
  reliabilitydata$VPPS_Neg_Ther_Att.2,
  "Neg therapist attitude"
)

compute_statistics_no_bias(
  reliabilitydata$VPPS_Ther_Warmth.1,
  reliabilitydata$VPPS_Ther_Warmth.2,
  "Therapist Warmth"
)

compute_statistics_no_bias(
  reliabilitydata$VPPS_Ther_Exploration.1,
  reliabilitydata$VPPS_Ther_Exploration.2,
  "Therapist Exploration"
)
