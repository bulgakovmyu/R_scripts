df <- read.csv("input_test_data.csv", header = TRUE, sep=";",dec = ",")
vec <- as.vector(df$t11)


#source("heatexchange_func.R")
#ar = c(34,2,32,4,7,NaN,134, 56, NaN, NaN)
#ar
#GetMedVal(ar, 3, -300)
GetMedVal(vec, 5, -300)
log(vec)
