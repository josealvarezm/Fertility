setwd("C:/Users/oskka/OneDrive/Documentos/GitHub/Fertility")
library(dplyr)

source("script/nacimientos_t.R")

df <- foreign::read.dbf("C:/Users/oskka/OneDrive/Documentos/José/INEGI/Nacimientos/NACIM2022.dbf")
df85 <- foreign::read.dbf("C:/Users/oskka/OneDrive/Documentos/José/INEGI/Nacimientos/NACIM1985.dbf")
df85$EDAD_REG <- ifelse(df85$EDAD_REG==98, 0, df85$EDAD_REG)

tabla <- prop.table(table(df85$EDAD_REG))
plot(cumsum(tabla))
tabla <- df %>% 
  