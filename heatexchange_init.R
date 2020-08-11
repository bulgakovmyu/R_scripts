source("heatexchange_func.R")

# Функция инициализации входных данных.

create_input <- function(mf=5){
  arr  <- load_input_data(mf=mf)
  out <- list(t11=arr[[1]], t12=arr[[2]], t21=arr[[3]], t22=arr[[4]])
  
  class(out) <- "input_data"
  
  return(out)
}


# Функция инициализиации начальных свойств теплообменника и алгоритма.
init_heatexchanger <- function(f0, shell_num=0, mf=5, 
                               T1_THD_A=1e6, T1_THD_W=1e6, T2_THD_A=1e6, T2_THD_W=1e6, 
                               DT_THD_A=1e6, DT_THD_W=1e6, LMTD_THD_A=1e6, LMTD_THD_W=1e6){
  out <- list(f0=f0, shell_num=shell_num, mf=mf, 
              T1_THD_A=T1_THD_A, T1_THD_W=T1_THD_W, T2_THD_A=T2_THD_A, T2_THD_W=T2_THD_W, 
              DT_THD_A=DT_THD_A, DT_THD_W=DT_THD_W, LMTD_THD_A=LMTD_THD_A, LMTD_THD_W=LMTD_THD_W)
  
  class(out) <- "exchanger_props"
  
  return(out)
  
}

# Функция инициализиации начальных свойств теплообменника и алгоритма.
init_status_values <- function(ST_BAD, ST_NORM, ST_WARN, ST_ALARM){
  out <- list(ST_BAD=ST_BAD, ST_NORM=ST_NORM, ST_WARN=ST_WARN, ST_ALARM=ST_ALARM)
  
  class(out) <- "status_values"
  
  return(out)
  
}