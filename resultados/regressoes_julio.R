library(readxl)
library(sandwich)
library(lmtest)
library(dplyr)

length((unique(base$isco08)))
table(base$isco08)


base <- read_excel("C:/Users/julio/PBL FGV/2ano/4 semestre/econometria/trabalho-econometria1/bases de dados/processadas/BASE_PRONTA.xlsx")
base$V2010 <- factor(base$V2010)                        

modelao <- lm(ln_renda ~ score_ia + VD3005 + V2009 + I(V2009^2) + factor(V2007) + factor(V2010) + factor(V1022) + factor(UF), data=base)
summary(modelao)


#variancis <- vcovHC(modelao, type= "HC1")
#resultado_vs <- coeftest(modelao, vcov. = variancis)                  erros robustos a HC sem o cluster la
#print(resultado_vs)


cluster <- vcovCL(modelao, cluster =  ~ isco08, type= "HC1")
coeftest(modelao, vcov. = cluster)                                      #erros robustos a HC com o cluster
print(cluster)
