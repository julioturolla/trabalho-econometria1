library(readxl)
library(sandwich)
library(lmtest)
library(dplyr)
library(knitr)

length((unique(base$isco08)))
table(base$isco08)



base <- read_excel(
  file.path("bases de dados", "processadas", "BASE_PRONTA.xlsx"))
base$V2010 <- factor(base$V2010)                        

modelao <- lm(ln_renda ~ score_ia + VD3005 + V2009 + I(V2009^2) + factor(V2007) + factor(V2010) + factor(V1022) + factor(UF), data=base)
summary(modelao)


#variancis <- vcovHC(modelao, type= "HC1")
#resultado_vs <- coeftest(modelao, vcov. = variancis)                  erros robustos a HC sem o cluster la
#print(resultado_vs)


cluster <- vcovCL(modelao, cluster =  ~ isco08, type= "HC1")
coeftest(modelao, vcov. = cluster)                                     #erros  robustos com hc1 clusters
print(cluster)

#tabelando pro paper
resultados <- coeftest(modelao, vcov. = cluster)
termos <- c("score_ia", "VD3005", "V2009", "I(V2009^2)", "factor(V2007)2", "factor(V1022)2")
nomes <- c( "Exposição à IA", "Escolaridade", "Idade", "Idade ao quadrado",  "Mulher", "Rural")
coeficientes <- resultados[termos,1]
erros <- resultados[termos,2]
p_valores <- resultados[termos, 4]


formatar <- function(x) {
  ifelse(
    abs(x) < 0.001,
    formatC(x, format = "f", digits = 7,
            decimal.mark = ","),
    formatC(x, format = "f", digits = 4,
            decimal.mark = ",")
  )
}

estrelas <- ifelse(p_valores < 0.001, "***", ifelse(p_valores < 0.01, "**", ifelse(p_valores < 0.05, "*", "")))
tabela_reg <- data.frame(Variavel = nomes, Coeficientes = paste0(formatar(coeficientes), estrelas), erro_padrao = paste0("(", formatar(erros), ")"))

extras <- data.frame(
  Variavel = c(
    "Controles de cor/raça",
    "Efeitos fixos de UF",
    "Observações",
    "R²"
  ),
  Coeficientes = c(
    "Sim",
    "Sim",
    format(nobs(modelao), big.mark = ".", trim = TRUE),
    formatar(summary(modelao)$r.squared)
  ),
  erro_padrao = c("", "", "", "")
)

tabela_reg <- rbind(tabela_reg, extras)

print(tabela_reg)


tabela_latex <- knitr::kable(
  tabela_reg,
  format = "latex",
  booktabs = TRUE,
  caption = "Resultados da regressão principal",
  label = "regressao_principal",
  col.names = c(
    "Variável",
    "Coeficiente",
    "Erro-padrão"
  ),
  align = c("l", "r", "r"),
  escape = TRUE
)

tabela_latex <- sub(
  "\\begin{table}",
  "\\begin{table}[H]",
  tabela_latex,
  fixed = TRUE
)

writeLines(
  tabela_latex,
  "C:/Users/julio/PBL FGV/2ano/4 semestre/econometria/trabalho-econometria1/resultados/tabela_regressao.tex"
)

getwd()




#voltando pros cluster pq eu quis fazer outras partes antes pq essa é chata
length((unique(base$isco08)))
linhas <- as.integer(rownames(model.frame(modelao)))
length(unique(base$isco08[linhas]))
nobs(modelao)






#diego deu uma ideia legal, adicionarei ## modelo com uma interaçao da dummy superior com o score_ia
modelo_interacao <- update(modelao, . ~ . + superior + superior:score_ia)

cluster_interacao <- vcovCL(modelo_interacao,cluster = ~ isco08, type = "HC1")
A <- length(unique(base$isco08))
resultado_interacao <- coeftest(modelo_interacao, vcov. = cluster_interacao, df = A - 1) 
print(resultado_interacao)


vars <- c("score_ia", "VD3005", "superior", "score_ia:superior")

nomes <- c(
  "Exposição à IA",
  "Escolaridade",
  "Superior completo",
  "IA x Superior"
)

coef <- resultado_interacao[vars, 1]
ep <- resultado_interacao[vars, 2]
p <- resultado_interacao[vars, 4]

estrelas <- ifelse(p < 0.001, "***",
            ifelse(p < 0.01, "**",
            ifelse(p < 0.05, "*", "")))

tabela_interacao <- data.frame(
  Variavel = nomes,
  Coeficiente = paste0(sprintf("%.4f", coef), estrelas),
  ErroPadrao = paste0("(", sprintf("%.4f", ep), ")")
)

extras <- data.frame(
  Variavel = c(
    "Demais controles",
    "Efeitos fixos de UF",
    "Observações",
    "R²"
  ),
  Coeficiente = c(
    "Sim",
    "Sim",
    nobs(modelo_interacao),
    sprintf("%.4f", summary(modelo_interacao)$r.squared)
  ),
  ErroPadrao = c("", "", "", "")
)

tabela_interacao <- rbind(tabela_interacao, extras)

print(tabela_interacao)

tabela_latex <- knitr::kable(
  tabela_interacao,
  format = "latex",
  booktabs = TRUE,
  caption = "Resultados da regressão com interação entre IA e ensino superior",
  label = "regressao_interacao",
  col.names = c(
    "Variável",
    "Coeficiente",
    "Erro-padrão"
  ),
  align = c("l", "r", "r"),
  escape = TRUE
)

tabela_latex <- sub(
  "\\begin{table}",
  "\\begin{table}[H]",
  tabela_latex,
  fixed = TRUE
)

writeLines(
  as.character(tabela_latex),
  "C:/Users/julio/PBL FGV/2ano/4 semestre/econometria/trabalho-econometria1/resultados/tabela_interacao.tex"
)

