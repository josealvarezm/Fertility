setwd("C:/Users/oskka/OneDrive/Documentos/GitHub/Fertility")
library(ggplot2)
library(dplyr)
df <- foreign::read.dbf("C:/Users/oskka/OneDrive/Documentos/José/INEGI/Nacimientos/nacim22.dbf")

# Gráfica entre edad del padre y madre
edades <- ggplot(df, aes(x=EDAD_MADN, y= EDAD_PADN, color=ESCOL_MAD)) + geom_point()
edades

# Lista de archivos
myfiles <- list.files(path="C:/Users/oskka/OneDrive/Documentos/José/INEGI/Nacimientos/", pattern="*.dbf")
#Función para asignar el año de nacimiento
nacimiento <- lapply(myfiles, function(x){
  for (i in 1:length(myfiles)){
    foreign::read.dbf(paste0("C:/Users/oskka/OneDrive/Documentos/José/INEGI/Nacimientos/", i))  
  }
  
})


tabla_año <- df %>% 
  group_by(ANO_NAC, SEXO, EDAD_MADN) %>% 
  summarise(n())


tabla <- merge(tabla, tabla_año, by = c("SEXO", "EDAD_MADN"))
names(tabla) <- c("SEXO", "EDAD_MADN", "1985", "1986", "1987", "1988", "1989", "1990", "1991", "1992", "1993", 
                  "1994", "1995", "1996", "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004", "2005",
                  "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017",
                  "2018", "2019", "2020", "2021", "2022")
head(tabla)

write.csv(tabla, "bin/nacimientos_edad_año.csv")
