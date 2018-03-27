#utf-8

library(dplyr)
#####
setwd("D:/workspace/dea_preprocess")
prelabor <- read.csv(file = 'prelabor.csv',header = T,na.strings = '-')
precapital <- read.csv(file = 'precapital.csv', header = T , na.strings = '-')
preenergy <- read.csv(file = 'preenergy.csv' , header = T , na.strings =  '-')
pregdp <- read.csv(file = 'pregdp.csv' , header = T , na.strings = '-')
preco2 <- read.csv(file = 'preco2.csv' , header = T , na.strings = '-')
#####labor
final_labor <- data.frame()
for(i in 1 : dim(prelabor)[1]){
  test_1 <- slice(prelabor,i)
  test_1_1 <- merge(test_1[1],colnames(test_1)[-1])
  tmp <- cbind(test_1_1 , t(test_1[1,-1]))
  names(tmp) <- c('location','year','labor')
  rownames(tmp) <- NULL
  final_labor <- rbind(final_labor , tmp)
}

#####capital
final_capital <- data.frame()
for(i in 1 : dim(precapital)[1]){
  test_1 <- slice(precapital,i)
  test_1_1 <- merge(test_1[1],colnames(test_1)[-1])
  tmp <- cbind(test_1_1 , t(test_1[1,-1]))
  names(tmp) <- c('location','year','capital')
  rownames(tmp) <- NULL
  final_capital <- rbind(final_capital , tmp)
}

#####energy
#drop 14 col(other data has no 2002 data)
preenergy <- preenergy[,-16]

final_energy <- data.frame()
for(i in 1 : dim(preenergy)[1]){
  test_1 <- slice(preenergy,i)
  test_1_1 <- merge(test_1[1],colnames(test_1)[-1])
  tmp <- cbind(test_1_1 , t(test_1[1,-1]))
  names(tmp) <- c('location','year','energy')
  rownames(tmp) <- NULL
  final_energy <- rbind(final_energy , tmp)
}


######gdp 
final_gdp <- data.frame()
for(i in 1 : dim(pregdp)[1]){
  test_1 <- slice(pregdp,i)
  test_1_1 <- merge(test_1[1],colnames(test_1)[-1])
  tmp <- cbind(test_1_1 , t(test_1[1,-1]))
  names(tmp) <- c('location','year','gdp')
  rownames(tmp) <- NULL
  final_gdp <- rbind(final_gdp , tmp)
}

######co2
preco2 <- preco2[,-16]
final_co2 <- data.frame()
for(i in 1 : dim(preco2)[1]){
  test_1 <- slice(preco2,i)
  test_1_1 <- merge(test_1[1],colnames(test_1)[-1])
  tmp <- cbind(test_1_1 , t(test_1[1,-1]))
  names(tmp) <- c('location','year','co2')
  rownames(tmp) <- NULL
  final_co2 <- rbind(final_co2 , tmp)
}

#######
#final <- final_capital %>% left_join(final_co2 , by = 'year')
final <- bind_cols(final_capital , final_co2) %>% bind_cols(final_energy) %>% bind_cols(final_gdp) %>%bind_cols(final_labor)

#####

my_data <- final %>% select('location' , 'year' , 'capital' , 'co2' , 'gdp' , 'labor' , 'energy')
write.csv(my_data,file = 'dea_data.csv')
