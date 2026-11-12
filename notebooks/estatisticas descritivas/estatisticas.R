library(readxl)
 base <- read_excel("C:/Users/julio/PBL FGV/2ano/4 semestre/econometria/trabalho-econometria1/bases de dados/processadas/BASE_PRONTA.xlsx")

numericas <- c(
  "VD4016",       # Renda mensal
  "ln_renda",     # Logaritmo da renda
  "salario_hora", # Salário-hora
  "score_ia",     # Exposição à IA
  "V2009",        # Idade
  "VD3005"        # Anos de estudo
)

resumo_num <- function(x) {

  x <- x[is.finite(x)]

  q <- quantile(
    x,
    probs = c(0.01, 0.25, 0.75, 0.95, 0.99)
  )

  c(
    N = length(x),
    Media = mean(x),
    Mediana = median(x),
    DP = sd(x),
    Variancia = var(x),
    Minimo = min(x),
    P1 = q[1],
    P25 = q[2],
    P75 = q[3],
    P95 = q[4],
    P99 = q[5],
    Maximo = max(x)
  )
}

descritivas <- t(
  sapply(base[numericas], resumo_num)
)

print(round(descritivas, 2))




categoricas <- c(
  "grupoIA",
  "mulher",
  "superior",
  "regiao",
  "V2010",   # Raça/cor
  "V1022",   # Urbano/rural
  "VD4009"   # Posição na ocupação
)

for (v in categoricas) {

  frequencia <- table(
    base[[v]],
    useNA = "ifany"
  )

  percentual <- prop.table(frequencia) * 100

  cat("\nVARIÁVEL:", v, "\n")

  print(
    data.frame(
      Frequencia = as.vector(frequencia),
      Percentual = round(as.vector(percentual), 2),
      row.names = names(frequencia)
    )
  )
}



grupos <- split(base, base$grupoIA)

comparacao_ia <- do.call(
  rbind,
  lapply(names(grupos), function(g) {

    dados <- grupos[[g]]

    data.frame(
      Grupo = g,
      N = nrow(dados),
      Renda_Media = mean(dados$VD4016, na.rm = TRUE),
      Renda_Mediana = median(dados$VD4016, na.rm = TRUE),
      Salario_Hora = mean(dados$salario_hora, na.rm = TRUE),
      Escolaridade = mean(dados$VD3005, na.rm = TRUE),
      Idade = mean(dados$V2009, na.rm = TRUE),
      Mulheres_Pct = mean(dados$mulher, na.rm = TRUE) * 100
    )
  })
)

row.names(comparacao_ia) <- NULL

print(comparacao_ia)

pesos_grupo <- tapply(
  base$V1028,
  base$grupoIA,
  sum
)

participacao_ponderada <- round(
  pesos_grupo / sum(pesos_grupo) * 100,
  2
)

print(participacao_ponderada)




comparacao_ponderada <- do.call(
  rbind,
  lapply(names(grupos), function(g) {

    dados <- grupos[[g]]

    data.frame(
      Grupo = g,
      Renda_Media = weighted.mean(
        dados$VD4016, dados$V1028, na.rm = TRUE
      ),
      Escolaridade = weighted.mean(
        dados$VD3005, dados$V1028, na.rm = TRUE
      ),
      Idade = weighted.mean(
        dados$V2009, dados$V1028, na.rm = TRUE
      ),
      Mulheres_Pct = weighted.mean(
        dados$mulher, dados$V1028, na.rm = TRUE
      ) * 100
    )
  })
)

row.names(comparacao_ponderada) <- NULL

print(comparacao_ponderada)




variaveis_outliers <- c(
  "VD4016",
  "salario_hora"
)

outliers <- do.call(
  rbind,
  lapply(variaveis_outliers, function(v) {

    x <- base[[v]]
    x <- x[is.finite(x)]

    q1 <- unname(quantile(x, 0.25))
    q3 <- unname(quantile(x, 0.75))

    iqr <- q3 - q1

    limite_inf <- q1 - 1.5 * iqr
    limite_sup <- q3 + 1.5 * iqr

    n_outliers <- sum(
      x < limite_inf | x > limite_sup
    )

    data.frame(
      Variavel = v,
      Limite_Inferior = limite_inf,
      Limite_Superior = limite_sup,
      N_Outliers = n_outliers,
      Percentual = 100 * n_outliers / length(x)
    )
  })
)

print(outliers)