source("heatexchange_init.R")
# Инициализируем начальные свойства
HeatExchanger_props <- init_heatexchanger(f0=1.10000002384185, shell_num=2, mf=1)

# Инициализируем и загружаем входные данные
arrays = create_input(mf=HeatExchanger_props$mf)

# Инициализируем значения статусов обменника
status_values <- init_status_values(ST_BAD=10, ST_NORM=1, ST_WARN=2, ST_ALARM=4)


#Запускаем расчеты
for (i in seq(1, length(arrays$t11), by=1)){
  input <- list(arrays$t11[i], arrays$t12[i], arrays$t21[i], arrays$t22[i])
  output <- CalcState(input, status_values, HeatExchanger_props)
}
write.csv(pi_output, file = "Result.csv")




