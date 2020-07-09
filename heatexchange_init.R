source("heatexchange_func.R")
# Входные данные

create_input <- function(t11, t12, t21, t22){
  out <- list(t11=t11, t12=t12, t21=t21, t22=t22)
  
  
  class(out) <- "input_data"
  
  return(out)
}

# Выходные данные

create_output <- function(KPD=0, LMTD=0, CLMTD=0, KF=0, KF2=0, KF0=0, FF=0,
                          MES_STATE=0, EFF_STATE=0, OFF_STATE=0, 
                          T_STATE=0, DT_STATE=0, FOL_STATE=0){
  out <- list(KPD=KPD, LMTD=LMTD, CLMTD=CLMTD, KF=KF, KF2=KF2, KF0=KF0, FF=FF,
              MES_STATE=MES_STATE, EFF_STATE=EFF_STATE, OFF_STATE=OFF_STATE, 
              T_STATE=T_STATE, DT_STATE=DT_STATE, FOL_STATE=FOL_STATE)
  
  class(out) <- "output_data"
  
  return(out)
}

# Теплообменник
init_heatexchanger <- function(f0, shell_num=0, mf=5, 
                               T1_THD_A=1e6, T1_THD_W=1e6, T2_THD_A=1e6, T2_THD_W=1e6, 
                               DT_THD_A=1e6, DT_THD_W=1e6, LMTD_THD_A=1e6, LMTD_THD_W=1e6){
  out <- list(f0=f0, shell_num=shell_num, mf=mf, 
              T1_THD_A=T1_THD_A, T1_THD_W=T1_THD_W, T2_THD_A=T2_THD_A, T2_THD_W=T2_THD_W, 
              DT_THD_A=DT_THD_A, DT_THD_W=DT_THD_W, LMTD_THD_A=LMTD_THD_A, LMTD_THD_W=LMTD_THD_W)
  
  class(out) <- "exchanger_props"
  
  return(out)
  
}