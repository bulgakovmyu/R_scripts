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

# Вычисляем состояние теплообменника
CalcState <- function(arrays, pi_output){
  
  dt1 <- arrays$t11 - arrays$t12
  dt2 <- arrays$t22 - arrays$t21
  dti <- arrays$t11 - arrays$t21
  pi_output$KPD <- dt2/dti
  pi_output$LMTD <- (dt1 - dt2) / (log(arrays$t11 - arrays$t22) - log(arrays$t12 - arrays$t21))
  
  return(pi_output)
}