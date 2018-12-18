library(readxl)

##This script gathers the gray matter composition data for each subject,
##saves it to a .csv, then runs the a random coefficient regression 
##to examine the relationship between gray matter composition and
##our indices of variability (spatial & temporal)


#List all the subjects 

subs = c(1001, 1002, 1005, 1006, 1007, 1008, 1031, 1032, 1034, 1036,
         1072, 1077, 1078, 1081, 1089, 1090, 1091, 1098, 1105, 1106,
         1111, 1115, 1116, 1117, 1118, 1119, 1125, 1126, 1127, 1128,
         1132, 1133, 1134, 1136, 1142, 1143, 1145, 1146, 1147, 1152,
         1153, 1154, 1157, 1166, 1167, 1173, 1176, 1185, 1195, 1207,
         1208, 1218, 1226, 1227, 1228, 1233, 1237, 1239, 1240, 1244,
         1245, 1246, 1248, 1249, 1250, 1252, 1253, 1256, 1262, 1263)

#List all 32 spheres (nested under 7 ROIs)

#ROIs = c("ldlPFC_A", "ldlPFC_B", "ldlPFC_C", "ldlPFC_D", "ldlPFC_E", 
#  "ldlPFC_F", "ldlPFC_G", "rdlPFC_A", "rdlPFC_B", "rdlPFC_C",
#  "rdlPFC_D", "rvlPFC_A", "rvlPFC_B", "rvlPFC_C", "rdmPFC_A", 
#  "rdmPFC_B", "rdmPFC_C", "rdmPFC_D", "rdmPFC_E", "rdmPFC_F", 
#  "rdmPFC_G", "lMTG_A", "lMTG_B", "lSPL_A", "lSPL_B", 
#  "lSPL_C", "lSPL_D", "lSPL_E", "rSPL_A", "rSPL_B", "rSPL_C", 
#  "rSPL_D")
#Those labels aren't actually used for anything here. Just meant to be a reminder of what the spheres are.


#create empty vector to store data
outGM = c()

#Loop over subjects, extract data from .txt files, save to output
for (i in 1:length(subs)) {
  data <- read.table(sprintf("C:/Users/jguas/Desktop/McReapp_gm/%s/anatomy/gm_spheres.txt", subs[i]))
  outGM = c(outGM, data$V1)
  
}

#Write output to .csv file
write.table(outGM, file="C:/Users/jguas/Desktop/McReapp_gm/gm_spheres_all.csv", col.names = FALSE, row.names = FALSE)

#import lme4
library(lme4)
library(lmerTest)

#gmML.csv should also be on github. was creating by taking data from output
#above and combinging with estimates of spatial/temporal var (located elsewhere, on OSF)
dat = read.csv("C:/Users/jguas/Desktop/McReapp_gm/gmML.csv")

#Allow random, between-subject error terms for intercepts and error terms
modGini <- lmer(Gini ~ GM + (1+GM|ID), data=dat, REML = FALSE)
modVar <- lmer(Var ~ GM + (1+GM|ID), data=dat, REML = FALSE)

#Summarize the models
summary(modGini)
summary(modVar)
