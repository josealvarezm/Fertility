#setwd("C:/Users/oskka/OneDrive/Documentos/GitHub/Fertility")
setwd("C:/Users/JoseC/OneDrive/Documents/GitHub/Fertility")
library(dplyr)

source("script/nacimientos_t.R")

# Función nacimiento: registros oportunos y extemporáneos
ubicación <- "C:\\Users\\JoseC\\OneDrive\\Documents\\2023-2\\INEGI\\Nacimientos\\"
nac <- nacimiento(ubicación)

# Nacimientos registrados oportunamente
# write.csv(nac, "bin/nacim_x_edad_en_año_reg.csv")

# Registros extemporáneos:
# "bin/Registro_x_Nac_anterior.csv"

# Función para agrupar los registros tardíos por año de nacimiento
reg_ext <- registro_tardio()

# ANÁLISIS POR AÑO DE REGISTRO Y EDAD DE REGISTRO
df <- foreign::read.dbf("C:/Users/oskka/OneDrive/Documentos/José/INEGI/Nacimientos/NACIM2022.dbf")
df85 <- foreign::read.dbf("C:/Users/oskka/OneDrive/Documentos/José/INEGI/Nacimientos/NACIM1985.dbf")
df85$EDAD_REG <- ifelse(df85$EDAD_REG==98, 0, df85$EDAD_REG)

tabla <- prop.table(table(df85$EDAD_REG))
plot(cumsum(tabla))
