#  Проверка на корректность данных - не пустота, не бесконечность и не NaN
is_normal_T <- function(t){
  return(!(is.null(t) | is.infinite(t) | is.nan(t)))
}

# Проверка на адекватность величины температуры
is_valid_T <- function(t){
  return(t <= 500 & t >= -100 & is_normal_T(t))
}

# Вычисление медианного значения температуры
GetMedVal <- function(t_array, index, count, def_val){
  print(t_array)
  if (count > mf){
    count <- mf
  }
  if (length(t_array)==0 | index > count | !count){
    return(def_val)
  }
  
  for (i in seq(1, count, by=1)){
    j <- index + mf
    sort_array[i] <- t_array[(j-i) %% mf + 1]
    print(sort_array[i])
  }
  print(sort_array)
  return(sort(sort_array)[count %/% 2 + 1])
  
}