# Estatísticas Descritivas — PNAD Contínua × OIT (2025)

Este documento apresenta as estatísticas descritivas da base utilizada na investigação da relação entre exposição ocupacional à inteligência artificial generativa e rendimentos do trabalho no Brasil.

**Base:** PNAD Contínua — 4º trimestre de 2025, integrada aos indicadores de exposição ocupacional à IA da OIT.

**Amostra:** 214.286 trabalhadores, 31 variáveis.

## 1. Dicionário das variáveis analisadas

| Variável | Descrição |
|---|---|
| `VD4016` | Rendimento mensal habitual do trabalho principal (R$) |
| `ln_renda` | Logaritmo natural da renda mensal |
| `salario_hora` | Rendimento por hora trabalhada (R$/hora) |
| `score_ia` | Escore contínuo de exposição potencial à IA |
| `grupoIA` | Classificação de exposição: baixa, intermediária ou alta |
| `dummy_ia` | Indicador binário de exposição à IA |
| `V2009` | Idade, em anos |
| `VD3005` | Anos de estudo |
| `mulher` | Indicador de sexo feminino (1 = mulher; 0 = homem) |
| `superior` | Indicador de ensino superior completo |
| `regiao` | Grande Região de residência |
| `V2010` | Cor ou raça |
| `V1022` | Situação urbana ou rural |
| `VD4009` | Posição na ocupação e categoria do emprego |
| `V1028` | Peso amostral da PNAD |

## 2. Estatísticas descritivas gerais

### 2.1. Média, mediana e dispersão

| Variável | N | Média | Mediana | Desvio-padrão | Variância |
|---|---:|---:|---:|---:|---:|
| Renda mensal (R$) | 214.286 | 3.303,15 | 2.000,00 | 5.044,84 | 25.450.386,46 |
| Log da renda | 214.286 | 7,67 | 7,60 | 0,91 | 0,83 |
| Salário-hora (R$) | 214.286 | 20,61 | 12,02 | 40,33 | 1.626,37 |
| Exposição à IA | 214.286 | 0,27 | 0,22 | 0,14 | 0,02 |
| Idade (anos) | 214.286 | 41,65 | 41,00 | 13,45 | 180,88 |
| Escolaridade (anos) | 214.286 | 11,12 | 12,00 | 4,13 | 17,08 |

### 2.2. Valores mínimos, máximos e percentis

| Variável | Mínimo | P1 | P25 | P75 | P95 | P99 | Máximo |
|---|---:|---:|---:|---:|---:|---:|---:|
| Renda mensal | 5,00 | 150,00 | 1.518,00 | 3.500,00 | 10.000,00 | 21.000,00 | 300.000,00 |
| Log da renda | 1,61 | 5,01 | 7,33 | 8,16 | 9,21 | 9,95 | 12,61 |
| Salário-hora | 0,05 | 1,57 | 8,65 | 20,98 | 57,69 | 144,23 | 5.769,23 |
| Exposição à IA | 0,09 | 0,09 | 0,15 | 0,38 | 0,58 | 0,60 | 0,70 |
| Idade | 18 | 18 | 31 | 51 | 64 | 73 | 102 |
| Escolaridade | 0 | 0 | 9 | 14 | 16 | 16 | 16 |

## 3. Distribuição das variáveis categóricas

### 3.1. Exposição à inteligência artificial

| Grupo | Frequência | Percentual |
|---|---:|---:|
| Alta | 19.009 | 8,87% |
| Baixa | 156.969 | 73,25% |
| Intermediária | 38.308 | 17,88% |
| **Total** | **214.286** | **100,00%** |

### 3.2. Sexo (`mulher`)

| Categoria | Frequência | Percentual |
|---|---:|---:|
| Homem (0) | 122.028 | 56,95% |
| Mulher (1) | 92.258 | 43,05% |

### 3.3. Ensino superior (`superior`)

| Categoria | Frequência | Percentual |
|---|---:|---:|
| Sem superior completo (0) | 163.521 | 76,31% |
| Com superior completo (1) | 50.765 | 23,69% |

### 3.4. Região de residência (`regiao`)

| Região | Frequência | Percentual |
|---|---:|---:|
| Centro-Oeste | 24.408 | 11,39% |
| Nordeste | 59.540 | 27,79% |
| Norte | 27.657 | 12,91% |
| Sudeste | 60.356 | 28,17% |
| Sul | 42.325 | 19,75% |

### 3.5. Cor ou raça (`V2010`)

| Categoria | Frequência | Percentual |
|---|---:|---:|
| Branca (1) | 88.097 | 41,11% |
| Preta (2) | 23.344 | 10,89% |
| Amarela (3) | 1.066 | 0,50% |
| Parda (4) | 100.704 | 47,00% |
| Indígena (5) | 1.057 | 0,49% |
| Ignorada (9) | 18 | 0,01% |

### 3.6. Situação do domicílio (`V1022`)

| Categoria | Frequência | Percentual |
|---|---:|---:|
| Urbana (1) | 169.964 | 79,32% |
| Rural (2) | 44.322 | 20,68% |

### 3.7. Posição na ocupação (`VD4009`)

| Código | Frequência | Percentual |
|---|---:|---:|
| 1 | 73.415 | 34,26% |
| 2 | 29.128 | 13,59% |
| 3 | 3.115 | 1,45% |
| 4 | 10.034 | 4,68% |
| 5 | 3.293 | 1,54% |
| 6 | 9.229 | 4,31% |
| 7 | 18.028 | 8,41% |
| 8 | 9.351 | 4,36% |
| 9 | 58.693 | 27,39% |

Os códigos correspondem às categorias da variável original `VD4009` da PNAD.

## 4. Comparação entre grupos de exposição à IA

### 4.1. Estatísticas não ponderadas

| Indicador | Baixa | Intermediária | Alta |
|---|---:|---:|---:|
| Observações | 156.969 | 38.308 | 19.009 |
| Renda média mensal (R$) | 3.045,77 | 4.098,49 | 3.825,69 |
| Renda mediana mensal (R$) | 2.000,00 | 2.500,00 | 2.500,00 |
| Salário-hora médio (R$) | 19,27 | 24,75 | 23,42 |
| Escolaridade média (anos) | 10,47 | 12,44 | 13,85 |
| Idade média (anos) | 42,41 | 41,04 | 36,68 |
| Mulheres (%) | 39,39% | 47,70% | 63,96% |

### 4.2. Estatísticas ponderadas pelos pesos amostrais da PNAD

| Indicador | Baixa | Intermediária | Alta |
|---|---:|---:|---:|
| Participação ponderada (%) | 70,15% | 19,71% | 10,13% |
| Renda média mensal (R$) | 3.252,27 | 4.361,29 | 3.961,43 |
| Escolaridade média (anos) | 10,98 | 12,68 | 13,84 |
| Idade média (anos) | 41,18 | 39,80 | 35,83 |
| Mulheres (%) | 39,89% | 46,71% | 61,88% |

*Diferenças mínimas na soma dos percentuais decorrem do arredondamento.*

## 5. Identificação de outliers

Foram identificados possíveis valores extremos nas distribuições de renda mensal e salário-hora, utilizando a regra de 1,5 × intervalo interquartil.

| Variável | Limite inferior | Limite superior | Outliers | Percentual |
|---|---:|---:|---:|---:|
| Renda mensal (`VD4016`) | -1.455,00 | 6.473,00 | 20.288 | 9,47% |
| Salário-hora (`salario_hora`) | -9,83 | 39,47 | 21.298 | 9,94% |

Como os rendimentos observados são positivos, os outliers identificados se encontram acima dos respectivos limites superiores.

Nenhuma observação foi automaticamente removida.

## 6. Principais resultados descritivos

- A renda média mensal é de **R$ 3.303,15**, enquanto a mediana é de **R$ 2.000,00**, indicando assimetria à direita na distribuição dos rendimentos.
- Aproximadamente **73,25% da amostra** pertence ao grupo de baixa exposição à IA.
- Trabalhadores do grupo de alta exposição apresentam **maior escolaridade média** (13,85 anos) e **menor idade média** (36,68 anos) que os trabalhadores de baixa exposição.
- A participação de mulheres é mais elevada no grupo de alta exposição: **63,96%**, contra **39,39%** no grupo de baixa exposição.
- A renda média não ponderada é de **R$ 3.825,69** no grupo de alta exposição e **R$ 3.045,77** no grupo de baixa exposição.
- O grupo intermediário apresenta a maior renda média: **R$ 4.098,49**, antes da ponderação, e **R$ 4.361,29**, após a ponderação.
- Foram identificados **20.288 possíveis outliers de renda mensal** (9,47%) e **21.298 de salário-hora** (9,94%).

As diferenças apresentadas são descritivas e não representam estimativas de efeito causal da exposição à IA sobre os rendimentos.

## 7. Arquivos

- `estatisticas.R` — Script de cálculo das estatísticas.
- `BASE_PRONTA.xlsx` — Base consolidada PNAD–OIT.
- `README.md` — Apresentação dos resultados descritivos.
