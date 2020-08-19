library(openxlsx)
source("heatexchange_init.R")
# Инициализируем начальные свойства
HeatExchanger_props <- init_heatexchanger(f0=1.10000002384185, shell_num=2, mf=1)

# Инициализируем и загружаем входные данные
arrays = create_input(mf=HeatExchanger_props$mf)

# Инициализируем значения статусов обменника
status_values <- init_status_values(ST_BAD=10, ST_NORM=1, ST_WARN=2, ST_ALARM=4)

# Инициализируем выходные данные
zero_vec <- rep(0, length(arrays$t11))
output <- create_pi_output(KPD=zero_vec, LMTD=zero_vec, CLMTD=zero_vec, KF=zero_vec, KF2=zero_vec, KF0=zero_vec, FF=zero_vec,
                           MES_STATE=zero_vec, EFF_STATE=zero_vec, OFF_STATE=zero_vec, 
                           T_STATE=zero_vec, DT_STATE=zero_vec, FOL_STATE=zero_vec)
#Запускаем расчеты
for (i in seq(1, length(arrays$t11), by=1)){
  input <- list(arrays$t11[i], arrays$t12[i], arrays$t21[i], arrays$t22[i])
  output <- CalcState(input, output, i, status_values, HeatExchanger_props)
}


write.xlsx(output, file = "Result.xlsx", row.names=FALSE)




