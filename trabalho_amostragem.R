#limpar o workspace
rm(list=ls())


#definindo diretório
setwd("C:\\Users\\lucas\\Documents\\Universidade Federal Fluminense\\2022.1\\Amostragem 1")


#Instalar pacote da Covid
#install.packages("COVIDIBGE")
#install.packages("sf")

# PACOTE -----
library(sf)
library(tidyverse)
library(survey)
library(srvyr)
library(COVIDIBGE)
library(ggplot2)
library(rmapshaper)
help("get_covid")

dadosPNADCOVID19 <- get_covid(year = 2020, month = 8, vars = c("UF", "V1022", "A004", "A005", "B008", "B009A", "B009B", "B009C", 
                                                               "B009D", "B009E", "B009F", "C002", "C003", "C004", "C006", 
                                                               "C007", "C007C", "C013", "F001", "F002A2", "F002A3"))
class(dadosPNADCOVID19)
# vou salvar para não precisar chamar novamente
saveRDS(dadosPNADCOVID19, file = "dados_2020_08.rds")

# para chamar do rds, fazer:
dadosPNADCOVID_2020_08 <- readRDS("C:\\Users\\lucas\\Documents\\Universidade Federal Fluminense\\2022.1\\Amostragem 1\\dados_2020_08.rds")


# o comando abaixo traz as caracteristicas do plano amostral
dadosPNADCOVID19
# vendo a classe do objeto: 'survey.design2' 'survey.design'
class(dadosPNADCOVID19)  # 'survey.design2' 'survey.design'
# vou salvar para não precisar chamar novamente
saveRDS(dadosPNADCOVID19, file = "dados_2020_08_srv.rds")


# com desing false: retorna tibble design
dadosPNADCOVID19_brutos <- get_covid(year = 2020, month = 8, vars = c("UF", "V1022", "A004", "A005", "B008", "B009A", "B009B",
                                                                      "B009C","B009D", "B009E", "B009F", "C002", "C003", "C004",
                                                                      "C006", "C007", "C007C", "C013", "F001", "F002A2", "F002A3"),
                                     design = FALSE)
class(dadosPNADCOVID19_brutos)  # 'tbl_df'     'tbl'        'data.frame'
dadosPNADCOVID19_brutos
saveRDS(dadosPNADCOVID19_brutos, file = "dados_2020_08_df.rds")

# sem labels
dadosPNADCOVID19_brutos_sem <- get_covid(year = 2020, month = 8, vars = c("UF", "V1022", "A004", "A005", "B008", "B009A", "B009B",
                                                                      "B009C","B009D", "B009E", "B009F", "C002", "C003", "C004",
                                                                      "C006", "C007", "C007C", "C013", "F001", "F002A2", "F002A3"), 
                                         labels = FALSE, design = FALSE)
# os níveis das categorias são representados por números: UF Rondônia = 11
dadosPNADCOVID19_brutos_sem
saveRDS(dadosPNADCOVID19_brutos_sem, file = "dados_2020_08_df_sem.rds")

dadosPNADCOVID19 <- read_covid(microdata = "PNAD_COVID_082020.csv")
#
dadosPNADCOVID19 <- covid_labeller(data_covid = dadosPNADCOVID19, dictionary.file = "Dicionario_PNAD_COVID_082020_20220621.xls")
#
class(dadosPNADCOVID19)  # [1] 'tbl_df'     'tbl'        'data.frame'


#deflator
dadosPNADCOVID19 <- covid_deflator(data_covid = dadosPNADCOVID19, deflator.file = "Deflator_PNAD_COVID_2020_11.xls")
class(dadosPNADCOVID19)  # 'tbl_df'     'tbl'        'data.frame'


#design
dadosPNADCOVID19 <- covid_design(data_covid = dadosPNADCOVID19)
class(dadosPNADCOVID19)  # 'survey.design2' 'survey.design' 
#
dadosPNADCOVID19
# Stratified 1 - level Cluster Sampling design (with replacement) With (14906)
# clusters.  survey::postStratify(design = data_prior, strata = ~posest,
# population = popc.types) posso salvar para depois
saveRDS(dadosPNADCOVID19, file = "dados_2020_08_final.rds")


#variaveis selecionadas
variaveis_selecionadas <- c("UF","CAPITAL", "RM_RIDE", "V1022", "A002","A003","A004", "A005", "B008", "B009A", "B009B",
                            "B009C","B009D", "B009E", "B009F", "C002", "C003", "C004",
                            "C006", "C007", "C007C", "C013", "F001", "F002A2", "F002A3")
dadosPNADCOVID19.var <- get_covid(year = 2020, month = 8, vars = variaveis_selecionadas)
class(dadosPNADCOVID19.var)
saveRDS(dadosPNADCOVID19.var, file = "dados_2020_08_var.rds")


#chamar a tabela sem precisar rodar o arquivo dnv
dadosPNADCOVID19.var <- readRDS("C:\\Users\\lucas\\Documents\\Universidade Federal Fluminense\\2022.1\\Amostragem 1\\dados_2020_08_var.rds")


#fazer com syvr
names(dadosPNADCOVID19.var[["variables"]])


#
pnad_srvyr <- srvyr::as_survey(dadosPNADCOVID19)
saveRDS(pnad_srvyr, file = "pnad_srvyr.rds")
class(pnad_srvyr)
# 'tbl_svy' 'survey.design2' 'survey.design' posso selecionar as colunas
# simplesmente fazendo
variaveis <- c("Ano", "V1013", "UF", "V1008", "V1012", "Estrato", "UPA", "V1022", "V1030", "V1031", "V1032", "posest", "A001", "A003",        
               "A004", "A005", "B008", "B009A", "B009B", "B009C", "B009D", "B009E", "B009F", "C002", "C003", "C004", "C006", "C007", 
               "C007C", "C013", "F001", "F002A2","F002A3", "ID_DOMICILIO", "Habitual", "Efetivo", "CO3")
# usar select() in dplyr
pnad_srvyr_select <- pnad_srvyr %>%
  select(variaveis)
class(pnad_srvyr_select)
saveRDS(pnad_srvyr_select, file = "pnad_srvyr_select.rds")


names(pnad_srvyr_select[["variables"]])
#"Ano", "V1013", "UF", "V1008", "V1012", "Estrato", "UPA", "V1022", "V1030", "V1031", "V1032", "posest", "A001", "A003"       
#"A004", "A005", "B008", "B009A", "B009B", "B009C", "B009D", "B009E", "B009F", "C002", "C003", "C004", "C006", "C007", 
#"C007C", "C013", "F001", "F002A2","F002A3", "ID_DOMICILIO", "Habitual", "Efetivo", "CO3" 

# comparar com o names de pnad_srvyr
names(pnad_srvyr[["variables"]])  # retornam 117 variaveis


# -------------------------------------------------------------------------

# usarei um coringa x para depois compor uma rotina iterativa entre arquivos
x <- dadosPNADCOVID19.var 

x2 <- subset(x$variables, UF == "Rio de Janeiro")

# Proporção de Homens e Mulheres que tiveram covid

#estimação do total populacional do RJ
totalsexo <- svytotal(x = ~A003, design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE)
totalsexo

totalsexo14 <- svytotal(x = ~A003, design = subset(x, UF == "Rio de Janeiro" & A002 > 14), na.rm = TRUE)
totalsexo14

totalraca <- svytotal(x = ~A004, design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE)
totalraca

#estimação total populacional do sexo e raça do RJ
totalsexoraca <- svytotal(x = ~A003 + A004, design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE)
totalsexoraca

#Total resultante do cruzamento de sexo e raça
totalsexoEraca <- svytotal(x = ~interaction(A003, A004), design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE) #analisar sexo com raça
ftable(x = totalsexoEraca)

#ESTIMAÇÃO DE PROPORÇÕES
propsexo <- svymean(x = ~A003, design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE)
propsexo

propsexo14 <- svymean(x = ~A003, design = subset(x, UF == "Rio de Janeiro" & A002 > 14), na.rm = TRUE)
propsexo14

propraca <- svymean(x = ~A004, design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE)
propraca

#propocao de sexo e raca
propsexoraca <- svymean(x = ~A003 + A004, design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE)
propsexoraca

#cruzamento de duas (ou mais) variaveis
propsexoEraca <- svymean(x = ~interaction(A003, A004), design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE)
ftable(x = propsexoEraca)
#propsexoEraca


#Estimação de quantidades em vários domínios mutuamente exclusivos

#vamos analisar qual é o nível de instrução de cada sexo
freqInstrSexo <- svyby(formula = ~A005, by = ~A003, design = subset(x, UF == "Rio de Janeiro"), FUN = svymean, na.rm = TRUE)
tab_freqInstrSexo <- freqInstrSexo

#vamos descobrir qual teste foi mais usado por cada sexo

#teste SWAB
propsexoSWAB <- svymean(x = ~interaction(A003, B009A), design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE)
propsexoSWAB

#teste DEDO               
propsexoDEDO <- svymean(x = ~interaction(A003, B009C), design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE)
propsexoDEDO

#teste VEIA
propsexoVEIA <- svymean(x = ~interaction(A003, B009E), design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE)
propsexoVEIA

#Chegamos a conclusão que o teste de furar o Dedo foi o mais utilizado tanto para os homens quanto para mulheres.


#Resultados dos testes SWAB/ DEDO/ VEIA
#SWAB
propsexotesteSWAB <- svymean(x = ~A003 + B009B, design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE)
propsexotesteSWAB

propsexoEtesteSWAB <- svymean(x = ~interaction(A003, B009B), design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE)
ftable(x = propsexoEtesteSWAB)

#DED0
propsexotesteDEDO <- svymean(x = ~A003 + B009D, design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE)
propsexotesteDEDO

propsexoEtesteDEDO <- svymean(x = ~interaction(A003, B009D), design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE)
ftable(x = propsexoEtesteDEDO)

#VEIA
propsexotesteVEIA <- svymean(x = ~A003 + B009F, design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE)
propsexotesteVEIA

propsexoEtesteVEIA <- svymean(x = ~interaction(A003, B009F), design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE)
ftable(x = propsexoEtesteVEIA)


#Escolaridade das pessoas que pegaram covid
propescola <- svymean(x = ~A005, design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE)
propescola #é melhor unir as escolaridades antes de fazer essa analise


freqCovidInstr <- svyby(formula = ~A005, by = ~B009B, design = subset(x, UF == "Rio de Janeiro"), FUN = svymean, na.rm = TRUE)
freqCovidInstr

freqCovidInstr2 <- svyby(formula = ~A005, by = ~B009D, design = subset(x, UF == "Rio de Janeiro"), FUN = svymean, na.rm = TRUE)
freqCovidInstr2

freqCovidInstr3 <- svyby(formula = ~A005, by = ~B009F, design = subset(x, UF == "Rio de Janeiro"), FUN = svymean, na.rm = TRUE)
freqCovidInstr3


escolaSWAB <- svymean(x = ~A005, design = subset(x, UF == "Rio de Janeiro" & (B009B == "Positivo" | B009D == "Positivo" | 
                                                                                 B009F == "Positivo")), na.rm = TRUE)
escolaSWAB #será que ele tá fazendo a leitura certa pois estou usando o operador & e o operador | ao mesmo tempo
#Fazer pergunta para o grugg/gadg/rafa

#Motivo pelo afastamento
propafastamento <- svymean(x = ~C003, design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE)
ftable(x = propafastamento)

#Continuou sendo remunerado (C004) se pegou covid
propdinheiro <- svymean(x = ~C004, design = subset(x, UF == "Rio de Janeiro" & C003 == "Estava em quarentena, isolamento, distanciamento social ou férias coletivas"), 
                        na.rm = TRUE)
propdinheiro

#Tem mais de 1 trabalho
proptrab <- svymean(x = ~C006, design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE)
proptrab
#Pensei em fazer o questionamento se das pessoas que pegaram covid tem mais de 1 trabalho, mas a porcentagem de pessoas com
#mais de 1 trabalho é de 6% o que eu considero baixo


#Boxplot idade

svyboxplot(formula = A002 ~ A003, design =  subset(x, UF == "Rio de Janeiro"),
           main = "Boxplot da idade dos entrevistados por Sexo")

mediaidade <- svymean(x = ~A002, design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE)
mediaidade

mediaidadeH <- svymean(x = ~A002, design = subset(x, UF == "Rio de Janeiro" & A003 == "Homem"), na.rm = TRUE)
mediaidadeH

mediaidadeM <- svymean(x = ~A002, design = subset(x, UF == "Rio de Janeiro" & A003 == "Mulher"), na.rm = TRUE)
mediaidadeM

#Situação do Domicilio
propsitdomicilio <- svymean(x = ~V1022, design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE)
propsitdomicilio

#Proporção de domicilios
propdomicilio <- svymean(x = ~F001, design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE)
propdomicilio

propgel <- svymean(x = ~F002A2, design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE)
propgel

propmasc <- svymean(x = ~F002A3, design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE)
propmasc

#Quantas pessoas fizeram o teste pra covid
totalteste <- svytotal(x = ~B008, design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE)
totalteste

propteste <- svymean(x = ~B008, design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE)
propteste

proptodosteste <- svymean(x = ~B009A + B009C + B009E, design = subset(x, UF == "Rio de Janeiro"), na.rm = TRUE)
proptodosteste
ftable(x = proptodosteste)

#Vamos descobrir sobre a capital e a região metropolitana
totalsexo

totalsexocap <- svytotal(x = ~A003, design = subset(x, UF == "Rio de Janeiro" & CAPITAL == "Município de Rio de Janeiro (RJ)"), 
                         na.rm = TRUE)
totalsexocap

totalsexometro <- svytotal(x = ~A003, design = subset(x, UF == "Rio de Janeiro" & RM_RIDE == "Região Metropolitana de Rio de Janeiro (RJ)"),
                           na.rm = TRUE)
totalsexometro

#----------------------------#
propsexo

propsexo14 <- svymean(x = ~A003, design = subset(x, UF == "Rio de Janeiro" & A002 > 14), na.rm = TRUE)
propsexo14

propsexocap <- svymean(x = ~A003, design = subset(x, UF == "Rio de Janeiro" & CAPITAL == "Município de Rio de Janeiro (RJ)"), 
                       na.rm = TRUE)
propsexocap

propsexometro <- svymean(x = ~A003, design = subset(x, UF == "Rio de Janeiro" & RM_RIDE == "Região Metropolitana de Rio de Janeiro (RJ)"), 
                       na.rm = TRUE)
propsexometro

