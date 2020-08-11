#  Проверка на корректность данных - не пустота, не бесконечность и не NaN
is_normal_T <- function(t){
  return(!(is.null(t) | is.infinite(t) | is.nan(t) | is.na(t)))
}

# Проверка на адекватность величины температуры
is_valid_T <- function(t){
  return(t <= 500 & t >= -100 & is_normal_T(t))
}

# Загрузка данных и медианная фильтрация
load_input_data <- function(mf=5){
  df_input <- read.csv("input_test_data.csv", header = TRUE, sep=";",dec = ",")
  
  if (mf > 3600){
    mf <- 3600
  }
  
  t11_array <- GetMedVal(as.vector(df_input$t11), mf, -300)
  t12_array <- GetMedVal(as.vector(df_input$t12), mf, -300)
  t21_array <- GetMedVal(as.vector(df_input$t21), mf, -300)
  t22_array <- GetMedVal(as.vector(df_input$t22), mf, -300)
  
  return(list(t11_array, t12_array, t21_array, t22_array))
}


# Вычисление медианного значения температуры
GetMedVal <- function(t_array, mf, def_val){
  arr_len <- length(t_array)
  
  if (arr_len==0){
    return(def_val)
  }
  
  cutted_last = ifelse(arr_len %% mf == 0, 0, 1)
  last_len = arr_len %% mf
  
  outpur_arr = rep(0.0, arr_len %/% mf + cutted_last)
  
  for (i in seq(1, length(outpur_arr), by=1)){
    if (cutted_last==1 & i==length(outpur_arr)){
      buff <- t_array[(length(t_array)-last_len+1):length(t_array)]
    } else {
      start <- (i-1)*mf+1
      finish <- (i-1)*mf+mf
      buff <- t_array[start:finish]
    }

    med_val = sort(buff)[length(buff) %/% 2 + 1]
    outpur_arr[i] <- ifelse((is.null(med_val) | is.infinite(med_val) | is.nan(med_val) | is.na(med_val)), 
                            def_val, 
                            med_val)
  }
  return(outpur_arr)
}

# Функция инициализации выходных данных

create_output <- function(KPD=0, LMTD=0, CLMTD=0, KF=0, KF2=0, KF0=0, FF=0,
                          MES_STATE=0, EFF_STATE=0, OFF_STATE=0, 
                          T_STATE=0, DT_STATE=0, FOL_STATE=0){
  out <- list(KPD=KPD, LMTD=LMTD, CLMTD=CLMTD, KF=KF, KF2=KF2, KF0=KF0, FF=FF,
              MES_STATE=MES_STATE, EFF_STATE=EFF_STATE, OFF_STATE=OFF_STATE, 
              T_STATE=T_STATE, DT_STATE=DT_STATE, FOL_STATE=FOL_STATE)
  
  class(out) <- "output_data"
  
  return(out)
}


# Вычисляем состояние теплообменника
CalcState <- function(input, status_values, HeatExchanger_props){
  t11 <- input[[1]]
  t12 <- input[[2]]
  t21 <- input[[3]]
  t22 <- input[[4]]
  
  # Инициализируем выходные данные
  output <- create_output()
  
  # проверяем корректные ли данные поданы на вход функции
  if (!is_valid_T(t11) | !is_valid_T(t12) | !is_valid_T(t21) | !is_valid_T(t22)){
    output$MES_STATE <- 1
    output$EFF_STATE <- status_values$ST_BAD
    output$OFF_STATE <- status_values$ST_BAD
    output$T_STATE <- status_values$ST_BAD
    output$DT_STATE <- status_values$ST_BAD
    output$FOL_STATE <- status_values$ST_BAD
    
    output$KPD <- status_values$ST_BAD
    output$LMTD <- status_values$ST_BAD
    output$CLMTD <- status_values$ST_BAD
    output$KF <- status_values$ST_BAD
    output$KF2 <- status_values$ST_BAD
    output$KF0 <- status_values$ST_BAD
    output$FF <- status_values$ST_BAD
    
  } else {
    output$MES_STATE <- 0
    
    # Вычисляем первую часть параметров обменника
    dt1 <- t11 - t12
    dt2 <- t22 - t21
    dti <- t11 - t21
    KPD <- dt2/dti
    LMTD <- (dt1 - dt2) / (log(t11 - t22) - log(t12 - t21))
    
    # Делаем промежуточную проверку значений
    if ((t11 >= HeatExchanger_props$T1_THD_A) | (t21 >= HeatExchanger_props$T1_THD_A)){
      output$T_STATE <- 2
    } else if ((t11 >= HeatExchanger_props$T1_THD_W) | (t21 >= HeatExchanger_props$T1_THD_W)) {
      output$T_STATE <- 1
    } else {
      output$T_STATE <- 0
    }
    
    if ((dt1 >= HeatExchanger_props$DT_THD_A) | (dt2 >= HeatExchanger_props$DT_THD_A) | (LMTD >= HeatExchanger_props$LMTD_THD_A)){
      output$DT_STATE <- 2
    } else if ((dt1 >= HeatExchanger_props$DT_THD_W) | (dt2 >= HeatExchanger_props$DT_THD_W) | (LMTD >= HeatExchanger_props$LMTD_THD_W)){
      output$DT_STATE <- 1
    } else {
      output$DT_STATE <- 0
    }
    
    if ((t11 - t21) < 10.0){
      # Теплообменник не работает. Дальнейшие вычисления недостоверны
      output$OFF_STATE <- 1
      return(output)
      
    } else {
      output$OFF_STATE <- 0
    }
    
    #Присваиваем значение КПД
    output$KPD <- KPD
    
    #Проверяем эффективность теплообменника
    if (KPD <= 0.1){
      #  Низкая эффективност. Дальнейшие вычисления недостоверны
      output$EFF_STATE <- 3
      return(output)
    }
    
    if ((t11 - t12) < 5.0){
      # Перерасход теплоносителя по потоку 1. Низкая эффективность. Дальнейшие вычисления недостоверны.
      output$EFF_STATE <- 1
      return(output)
    }
    
    if ((t22 - t21) < 5.0){
      # Перерасход теплоносителя по потоку 2. Низкая эффективность. Дальнейшие вычисления недостоверны.
      output$EFF_STATE <- 2
      return(output)
    }
    
    #Присваиваем значение LMTD
    output$LMTD <- LMTD
    
    #Продолжаем проверку эффективности обменника
    if (LMTD < 10.0){
      #  Низкая эффективность. Дальнейшие вычисления недостоверны.
      output$EFF_STATE <- 3
      return(output)
    }
    
    #Присваиваем начальное значение коэффициента Ф
    KF0 <- HeatExchanger_props$f0
    output$KF0 <- KF0
    
    KF <- sqrt(dt1*dt2) / LMTD
    output$KF <- KF
    
    if ((HeatExchanger_props$shell_num > 0) & (HeatExchanger_props$shell_num < 10)){
      r <- dt2/dt1
      p <- dt1/dti
      w <- ((1-p*r)/(1-p))**(1/HeatExchanger_props$shell_num)
      s <- sqrt(r*r+1) / (r-1)
      n <- s*log(w)
      d <- log((1+w-s+w*s) / (1+w+s-w*s))
      f <- n/d

      if (!is_normal_T(f)){
        # Низкая эффективность. Дальнейшие вычисление не достоверны
        output$EFF_STATE <- 4
        
        output$CLMTD <- status_values$ST_BAD
        output$KF <- status_values$ST_BAD
        output$KF2 <- status_values$ST_BAD
        return(output)
        
      } else {
        corr_f <- f
      }
      
    } else {
      corr_f <- 1
    }
    
    # C эффективностью все в порядке
    output$EFF_STATE <- 0
    
    #Присваиваем CLMTD, KF2 и FF
    CLMTD <- LMTD*corr_f
    output$CLMTD <- CLMTD
    
    KF2 <- KF/corr_f
    FF <- 1 - KF2/KF0
    output$KF2 <- KF2
    output$FF <- FF
    
    # Присваиваем статус FOL_STATE
    if (FF < 0.1){
      STATE = status_values$ST_NORM
    } else if (FF < 0.3){
      STATE = status_values$ST_WARN
    } else {
      STATE = status_values$ST_ALARM
    }
    
    output$FOL_STATE <- STATE
   
    
    return(output)
  }
}