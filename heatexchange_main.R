source("heatexchange_init.R")

pi_t <- create_input(t11=150, t12=200, t21=130, t22=320)

pi_output <- create_output()

m_index = 0
m_count = 0 
mf = 11

if (mf > 3600){
  mf <- 3600
}

t11_array = rep(0.0, mf)
t12_array = rep(0.0, mf)
t21_array = rep(0.0, mf)
t22_array = rep(0.0, mf)
sort_array = rep(0.0, mf)

HeatExchanger_props <- init_heatexchanger(0)


GetMedVal(c(1,2,3,4,5,6,7,8,9,10,11), 0, 11, 300)

