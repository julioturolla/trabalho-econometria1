library(readxl)
library(sandwich)
library(lmtest)
library(dplyr)
library(knitr)
library(car)

base <- read_excel(
  file.path("bases de dados", "processadas", "BASE_PRONTA.xlsx"))

base$grupoIA <- factor(base$grupoIA,, levels = c("Baixa", "Intermediaria", "Alta"))





modelao <- lm(ln_renda ~ score_ia + VD3005 + V2009 + I(V2009^2) + factor(V2007) + factor(V2010) + factor(V1022) + factor(UF), data=base)

modelao_categ <- lm(ln_renda ~ grupoIA + VD3005 + V2009 + I(V2009^2) + factor(V2007) + factor(V2010) + factor(V1022) + factor(UF), data=base)  #diferente pq usa categoria
cluster <- vcovCL(modelao_categ, cluster =  ~ isco08, type= "HC1")
coeftest(modelao_categ, vcov. = cluster)                                     #erros  robustos com hc1 clusters




nobs(modelao_categ)

table(base$grupoIA, useNA = "ifany")

summary(modelao_categ)$r.squared



#teste F pra mostrar q é 10 na prova!
linearHypothesis(modelao_categ, c( "grupoIAIntermediaria = 0",  "grupoIAAlta = 0"), vcov. = cluster, test = "F", error.df = 413)




#modelo com mais variaveis, queria colocar todas mas VD4009 e V4013 parecem mais plausiveis pro meu caso
modelo_ampliado <- update(modelao, . ~ . + factor(VD4009) + factor(V4013))
cluster_ampliado <- vcovCL(modelo_ampliado, cluster = ~isco08, type = "HC1")
coeftest(modelo_ampliado, vcov. = cluster_ampliado)


nobs(modelo_ampliado)
summary(modelo_ampliado)$r.squared


























































#aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa