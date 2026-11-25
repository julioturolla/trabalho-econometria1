library(readxl)
library(dplyr)
library(tidyr)
library(knitr)
library(ggplot2)
base <- read_excel("C:/Users/julio/PBL FGV/2ano/4 semestre/econometria/trabalho-econometria1/bases de dados/processadas/BASE_PRONTA.xlsx")


tabela <- base %>% pivot_longer(cols = c(VD4016,ln_renda,salario_hora,score_ia,VD3005,V2009,V4039,mulher,superior), names_to = "variavel", values_to = "valor") %>%
group_by(variavel) %>% 
summarise(n = sum(!is.na(valor)), media = mean(valor, na.rm = TRUE),desvio_padrao = sd(valor, na.rm = TRUE), mediana = median(valor, na.rm = TRUE), maximo = max(valor, na.rm = TRUE), minimo = min(valor, na.rm = TRUE), .groups = "drop")
print(tabela)


tabela_latex <- kable(
  tabela,
  format = "latex",
  booktabs = TRUE,
  caption = "Estatísticas descritivas da amostra",
  label = "descritivas",
  align = c("l", rep("r", 6)),
  digits = 2,
  format.args = list(
    decimal.mark = ",",
    big.mark = "."
  )
)
writeLines(tabela_latex, "tabela_descritivas.tex")

getwd()

#histogramsas
histograma_ia <- ggplot(base, aes(x = score_ia)) + geom_histogram(binwidth = 0.025, fill = "blue", color = "white") + labs(title = "Distribuição da exposição ocupacional à IA", x = "Índice de exposição à IA", y = "Número de trabalhadores") + theme_minimal(base_size = 12)
print(histograma_ia)
histograma_renda <- ggplot(base, aes(x = ln_renda)) + geom_histogram(binwidth = 0.15, fill = "blue", color = "white") + labs(title = "Distribuição do logaritmo da renda", x = "Logaritmo da renda mensal", y =  "Número de trabalhadores") + theme_minimal(base_size = 12)
print(histograma_renda)


#boxplot nao usei pq ficou feio dms
boxplot_renda <- ggplot(base, aes(y = ln_renda, x = "")) + geom_boxplot(width = 0.25,fill = "#686881",color = "black", outlier.alpha = 0.2, outlier.shape = NA )+ coord_cartesian(ylim = c(5.5, 10)) + labs(title = "Boxplot do ln da renda",x = NULL, y = "ln da renda" ) + theme_minimal(base_size = 12) + theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())
print(boxplot_renda)

#grafico de mediana e quartil criando grupos e os ...
base$grupoIA <- factor(base$grupoIA, levels = c("Baixa", "Intermediaria", "Alta"))
resumo_grupos <- base %>%
  group_by(grupoIA) %>%
  summarise(
    q25 = quantile(ln_renda, 0.25, na.rm = TRUE),
    mediana = median(ln_renda, na.rm = TRUE),
    q75 = quantile(ln_renda, 0.75, na.rm = TRUE),
    .groups = "drop"
  )
print(resumo_grupos)
quartis <- ggplot(resumo_grupos, aes(y = grupoIA)) + geom_segment(aes(x = q25, xend = q75, yend = grupoIA), linewidth = 3, color = "blue") + geom_point(aes(x = mediana), size = 3, color = "black") + labs(title = "Rendimentos por nível de exposição à IA",  x = "Logaritmo da renda mensal",   y = "Grupo de exposição à IA") + theme_minimal(base_size = 12) + theme( panel.grid.major.y = element_blank(), panel.grid.minor = element_blank())
print(quartis)


unique(base$grupoIA)



# mesmo do de cima, dos quartis e medianas mas agora usando escolariadade pq pq nao ne
educ <- base%>% 
 filter(!is.na(grupoIA)) %>%
 group_by(grupoIA) %>%
 summarise(media = mean(VD3005, na.rm = TRUE), .groups = "drop")           #ajustando dnv pq nao fiz na base em si
print(educ)

grafico <- ggplot(educ, aes(x=media, y=grupoIA)) + geom_col(fill = "blue", width = 0.55) + geom_text(aes(label = round(media, 2)), hjust = -0.4, size = 3.5) + scale_x_continuous(expand = expansion(mult = c(0, 0.15))) + labs(title = "Escolaridade média por exposição à IA", x = "Anos médios de estudo", y =  "Grupo de exposição à IA") + theme_minimal(base_size = 12) + theme( panel.grid.major.y = element_blank(),panel.grid.minor = element_blank())
print(grafico)
