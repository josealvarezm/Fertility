setwd("C:/Users/oskka/OneDrive/Documentos/GitHub/Fertility")
library(data.table)
library(dplyr)
df <- foreign::read.dbf("C:/Users/oskka/OneDrive/Documentos/José/INEGI/Nacimientos/nacim22.dbf")

tabla_año <- df %>% 
  group_by(SEXO, EDAD_MADN) %>% 
  summarise(n())


tabla <- merge(tabla, tabla_año, by = c("SEXO", "EDAD_MADN"))
names(tabla) <- c("SEXO", "EDAD_MADN", "1985", "1986", "1987", "1988", "1989", "1990", "1991", "1992", "1993", 
                  "1994", "1995", "1996", "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004", "2005",
                  "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017",
                  "2018", "2019", "2020", "2021", "2022")
head(tabla)

write.csv(tabla, "bin/nacimientos_edad_año.csv")
