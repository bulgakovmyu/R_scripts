source("heatexchange_init.R")
# Инициализируем начальные свойства
HeatExchanger_props <- init_heatexchanger(0)

# Инициализируем и загружаем входные данные
arrays = create_input(mf=HeatExchanger_props$mf)

# Инициализируем выходные данные
pi_output <- create_output()

#Запускаем расчеты
pi_output <- CalcState(arrays, pi_output)






