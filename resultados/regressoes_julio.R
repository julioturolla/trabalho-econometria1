library(readxl)
base <- read_excel("C:/Users/julio/PBL FGV/2ano/4 semestre/econometria/trabalho-econometria1/bases de dados/processadas/BASE_PRONTA.xlsx")
base$V2010 <- factor(base$V2010)





modelo_simples <- lm(ln_renda ~ score_ia, data=base)
summary(modelo_simples)                                      #modelo simples, renda e score


modelao <- lm(ln_renda ~ dummy_ia + VD3005 + V2009 + I(V2009^2) + factor(V2007) + factor(V2010) + factor(V1022) + factor(UF), data=base)
summary(modelao)
