setwd("C:/Users/oskka/OneDrive/Documentos/GitHub/Fertility")

library(dplyr)


##########################################################
#### Función 1: NACIMIENTOS REGISTRADOS OPORTUNAMENTE ####
##########################################################

nacimiento <- function(x){
  
  # Loop for i -> Genera tabla con nacimientos ocurridos en cada año y registrados en el mismo año
  for (i in 1985:2022){
    df <- foreign::read.dbf(paste0("C:/Users/oskka/OneDrive/Documentos/José/INEGI/Nacimientos/NACIM", i, ".dbf"))
    df$ANO_NAC <- ifelse(df$ANO_NAC<99, df$ANO_NAC + 1900, df$ANO_NAC)
    df$ANO_REG <- ifelse(df$ANO_REG<99, df$ANO_REG + 1900, df$ANO_REG)

    if (i == 1985){
      # Tabla inicial 1985
      tabla <- df %>% 
        filter(ANO_NAC== i) %>% 
        group_by(SEXO, EDAD_MADN) %>% 
        summarise(n())
      
    }else{
      # Tabla de años siguientes que se fusionan
      tabla_i <- df %>% 
        filter(ANO_NAC == i) %>% 
        group_by(SEXO, EDAD_MADN) %>% 
        summarise(n())
      tabla <- merge(tabla, tabla_i, by=c( "SEXO", "EDAD_MADN"))
    }
      # Loop for j -> genera archivos csv con nacimientos en los años anteriores
      for (j in 1:10){
        if (j == 1){
          # Tabla inicial: año anterior al seleccionado
          tabla_j <- df %>% 
            filter(ANO_NAC == i-j) %>% 
            group_by(SEXO, EDAD_MADN) %>% 
            summarise(n())      
          names(tabla_j) <- c( "SEXO", "EDAD_MADN", as.character(i-j))
        }else{
          tabla_i_j<- df %>% 
            filter(ANO_NAC == i-j) %>% 
            group_by(SEXO, EDAD_MADN) %>% 
            summarise(n())
          names(tabla_i_j) <- c( "SEXO", "EDAD_MADN", as.character(i-j))
          tabla_j <- merge(tabla_j, tabla_i_j, by=c( "SEXO", "EDAD_MADN"))
        }
        
      } #Fin for loop j
    myfile <- paste0("bin/Registro_", i, "_Nac_anterior.csv")
    write.csv(tabla_j, myfile)
  } # Fin for loop i
  names(tabla) <- c("SEXO", "EDAD_MADN", "1985", "1986", "1987", "1988", "1989", "1990", "1991", "1992", "1993", 
                "1994", "1995", "1996", "1997", "1998", "1999", "2000", "2001", "2002", "2003", "2004", "2005",
                "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017",
                "2018", "2019", "2020", "2021", "2022")
  return(tabla)
}

nac <- nacimiento()

write.csv(nac, "bin/nacim_x_edad_en_año_reg.csv")


##################################################################################
#### Función 2 para obtener los registros tardíos en los 10 años siguientes ######
##################################################################################

registro_tardio <- function(){
  year <- c(1985:1985)
  for (y in year){
    nombre <- paste0("X", (y))
    
    for (i in 1:10){
      myfile <- paste0("bin/Registro_", i + y, "_Nac_anterior.csv")
      df <- read.csv(myfile)
      
      
      if (i == 1){
        # Registro del año siguiente
        tabla <- df %>% select(SEXO, EDAD_MADN, nombre)
        names(tabla) <- c("SEXO", "EDAD_MADN", as.character(i + y))
        

      }else{
        # Registro de los años subsiguientes
        tabla_i <- df %>% select(SEXO, EDAD_MADN, nombre)
        names(tabla_i) <- c("SEXO", "EDAD_MADN", as.character(i + y))
        tabla <- merge(tabla, tabla_i, by = c("SEXO", "EDAD_MADN"))
      } #Fin If / Else
      
      
      write.csv(tabla, paste0("bin/Registros Tardíos/Registros_tardíos_Nac_", y, ".csv"))

    } #Fin loop i

  } # Fin loop y 
  return(tabla)
} # Fin de función

ver <- registro_tardio()

##########################################################
#### TOTAL DE REGISTROS TARDIOS POR AÑO DE NACIMIENTO ####
##########################################################

tot_reg <- function(){
  for(y in 1985:2012){
    nombre <- paste0("bin/Registros Tardíos/Registros_tardíos_Nac_", y, ".csv")
    df <- read.csv(nombre)
    estructura <- df[,2:3]
    registros <- apply(df[,4:13], 1, sum)
    tabla_1 <- cbind(estructura, registros)
    if (y == 1985){
      tabla_i <- cbind(estructura, registros)
    }else{
      tabla_i <- merge(tabla_i, tabla_1, by = c("SEXO", "EDAD_MADN"), all=T)
    }
    
    
  }
  names(tabla_i) <- c("SEXO", "EDAD_MADN", as.character(1985:2012))

  return(tabla_i)
}

prueba <- tot_reg()
write.csv(prueba, "bin/Registros tardíos/Total_Registros_Tardíos_x_Ano_Nacim.csv")
