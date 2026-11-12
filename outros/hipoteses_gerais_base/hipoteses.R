library(readxl)
base <- read_excel("C:/Users/julio/PBL FGV/2ano/4 semestre/econometria/trabalho-econometria1/bases de dados/processadas/BASE_PRONTA.xlsx")

colSums(is.na(base))
colMeans(is.na(base)) * 100


variaveis <- c("score_ia", "VD3005", "V2009", "idade2", "mulher", "superior")
matriz_cor <- cor(base[, variaveis])
round(matriz_cor, 3)

idade_media <- mean(base$V2009)
base$idade_c <- base$V2009 - idade_media
base$idade_c2 <- base$idade_c ^2
cor(base[c("V2009", "idade2", "idade_c", "idade_c2")])


escores_por_ocupacao <- tapply(
  base$score_ia,
  base$isco08,
  function(x) length(unique(x))
)

sum(escores_por_ocupacao > 1)

colSums(is.na(base[c("V1028", "UPA", "Estrato")]))
sum(base$V1028 <= 0, na.rm = TRUE)


upas_por_estrato <- tapply(
  base$UPA,
  base$Estrato,
  function(x) length(unique(x))
)
sum(upas_por_estrato == 1)