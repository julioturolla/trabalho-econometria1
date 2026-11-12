# Diagnósticos Preliminares da Base — PNAD × OIT (2025)

Este documento apresenta os resultados dos diagnósticos realizados no script `hipoteses.R`, utilizado para verificar a consistência da base de dados, investigar correlações entre variáveis explicativas e avaliar características importantes para a estimação econométrica.

**Base utilizada:** `BASE_PRONTA.xlsx` — PNAD Contínua (4º trimestre de 2025) integrada aos indicadores de exposição à IA generativa da OIT.

**Amostra:** 214.286 observações e 31 variáveis originais da base tratada.

## 1. Verificação de valores ausentes (NA)

Foram calculadas a quantidade e a proporção de valores ausentes em todas as variáveis da base, utilizando `colSums(is.na(base))` e `colMeans(is.na(base)) * 100`.

### Resultados

| Variável | Valores ausentes | Percentual |
|---|---:|---:|
| `dummy_ia` | 38.308 | 17,88% |
| Todas as demais variáveis | 0 | 0,00% |

**Conclusões:**

- A única variável com valores ausentes é `dummy_ia`, utilizada para distinguir trabalhadores com alta e baixa exposição à IA.
- Os 38.308 valores ausentes são intencionais e correspondem às ocupações classificadas como intermediárias.
- Nenhuma observação precisa ser excluída em razão de valores ausentes nas demais variáveis.
- A análise com `score_ia`, indicador contínuo de exposição, pode utilizar as 214.286 observações.
- A análise com `dummy_ia` dispõe de 175.978 observações com classificação binária definida.

## 2. Correlação entre variáveis explicativas

Foi calculada a matriz de correlação de Pearson entre seis variáveis potencialmente utilizadas nos modelos econométricos.

### Variáveis analisadas

| Variável | Descrição |
|---|---|
| `score_ia` | Índice contínuo de exposição ocupacional à IA |
| `VD3005` | Anos de estudo |
| `V2009` | Idade do trabalhador |
| `idade2` | Idade ao quadrado |
| `mulher` | Dummy de sexo feminino |
| `superior` | Dummy de ensino superior completo |

### Matriz de correlação

| Variável | score_ia | VD3005 | V2009 | idade2 | mulher | superior |
|---|---:|---:|---:|---:|---:|---:|
| `score_ia` | 1,000 | 0,431 | -0,118 | -0,110 | 0,172 | 0,345 |
| `VD3005` | 0,431 | 1,000 | -0,277 | -0,289 | 0,209 | 0,638 |
| `V2009` | -0,118 | -0,277 | 1,000 | 0,984 | -0,038 | 0,017 |
| `idade2` | -0,110 | -0,289 | 0,984 | 1,000 | -0,048 | -0,005 |
| `mulher` | 0,172 | 0,209 | -0,038 | -0,048 | 1,000 | 0,164 |
| `superior` | 0,345 | 0,638 | 0,017 | -0,005 | 0,164 | 1,000 |

### Principais resultados

**Exposição à IA e escolaridade:** a correlação entre `score_ia` e `VD3005` é de 0,431, indicando associação positiva entre a exposição ocupacional potencial à IA e os anos de estudo.

**Exposição à IA e ensino superior:** a correlação de 0,345 entre `score_ia` e `superior` indica que trabalhadores com ensino superior completo tendem a estar em ocupações com maior exposição potencial à IA.

**Escolaridade e ensino superior:** a correlação entre `VD3005` e `superior` é de 0,638, resultado esperado, dado que ambas as variáveis representam dimensões relacionadas à formação educacional.

**Idade e idade ao quadrado:** a correlação de 0,984 é extremamente elevada, motivando a centralização da idade para reduzir a correlação entre os termos linear e quadrático.

As correlações representam associações lineares entre as variáveis e não constituem evidência de causalidade.

## 3. Centralização da idade

Para reduzir a correlação elevada entre idade e idade ao quadrado, foram criadas duas novas variáveis no R:

| Variável | Construção | Descrição |
|---|---|---|
| `idade_c` | `V2009 - mean(V2009)` | Idade centralizada na média |
| `idade_c2` | `idade_c^2` | Quadrado da idade centralizada |

### Resultados

| Par de variáveis | Correlação |
|---|---:|
| Idade × Idade² | 0,9843 |
| Idade centralizada × Idade centralizada² | 0,2330 |
| Idade × Idade centralizada | 1,0000 |
| Idade² × Idade centralizada² | 0,4010 |

### Conclusão

A centralização reduziu a correlação entre os termos linear e quadrático de **0,9843 para 0,2330**.

Essa transformação pode facilitar a interpretação dos coeficientes de idade e melhorar o condicionamento numérico da regressão.

Nos modelos com idade e idade ao quadrado, poderão ser utilizadas `idade_c` e `idade_c2` em substituição aos termos originais, sem alterar o ajuste do modelo quando houver intercepto.

**Observação:** `V2009` e `idade_c` possuem correlação perfeita, pois diferem apenas por uma constante. Portanto, não devem ser incluídas simultaneamente em uma regressão com intercepto.

As variáveis centralizadas foram criadas no objeto `base` durante a execução do script, sem modificar automaticamente o arquivo Excel original.

## 4. Consistência do escore de exposição por ocupação

Foi verificado se trabalhadores pertencentes à mesma ocupação, identificada pelo código ISCO-08, receberam o mesmo valor de `score_ia`.

A verificação contou o número de valores distintos de exposição à IA dentro de cada ocupação.

### Resultado

| Indicador | Resultado |
|---|---:|
| Ocupações com mais de um escore de IA | 0 |

### Conclusão

**Nenhuma ocupação apresenta escores de exposição divergentes.**

Isso confirma a consistência interna da atribuição do indicador de exposição à IA por ocupação na base analisada.

Como `score_ia` é constante dentro de cada ocupação ISCO-08, a variação da exposição ocorre entre ocupações, e não entre indivíduos da mesma ocupação.

Essa característica será relevante para a inferência estatística, especialmente na avaliação de erros-padrão agrupados por ocupação.

## 5. Verificação dos pesos e identificadores amostrais

Foram examinadas três variáveis importantes para o desenho amostral da PNAD:

| Variável | Descrição |
|---|---|
| `V1028` | Peso amostral |
| `UPA` | Unidade Primária de Amostragem |
| `Estrato` | Identificador do estrato amostral |

### Resultados

| Verificação | Resultado |
|---|---:|
| Valores ausentes em `V1028` | 0 |
| Valores ausentes em `UPA` | 0 |
| Valores ausentes em `Estrato` | 0 |
| Pesos amostrais menores ou iguais a zero | 0 |

### Conclusão

Todas as observações da amostra tratada possuem pesos amostrais positivos e identificadores de UPA e estrato preenchidos.

Assim, as informações necessárias para considerar o desenho amostral da PNAD foram preservadas na base.

## 6. Estratos com apenas uma UPA

Foi calculada a quantidade de UPAs distintas dentro de cada estrato amostral, utilizando a combinação de `tapply()` e `unique()`.

### Resultado

| Indicador | Resultado |
|---|---:|
| Estratos com apenas uma UPA na amostra tratada | 5 |

### Conclusão

Foram identificados **5 estratos contendo somente uma UPA** na amostra analisada.

Essa característica, conhecida como *lonely PSU*, merece atenção na estimação de erros-padrão que considerem o desenho complexo da PNAD.

A existência desses estratos não impede a estimação dos coeficientes por MQO e não significa necessariamente que exista um problema nos dados.

Entretanto, poderá ser necessário adotar um tratamento específico na estimação das variâncias amostrais, considerando que os filtros aplicados à base podem ter reduzido o número de UPAs em determinados estratos.

Nenhuma observação foi excluída em decorrência dessa verificação.

## 7. Resumo dos diagnósticos

| Diagnóstico | Resultado | Situação |
|---|---|---|
| Valores ausentes | Apenas `dummy_ia`: 38.308 NA intencionais | Consistente |
| Correlações entre regressoras | Correlação elevada entre idade e idade² | Identificada |
| Centralização da idade | Correlação reduzida de 0,9843 para 0,2330 | Realizada |
| Exposição por ocupação | 0 ocupações com escores divergentes | Consistente |
| Pesos amostrais | 0 ausentes e 0 não positivos | Consistente |
| Identificadores amostrais | 0 ausentes em UPA e Estrato | Consistente |
| Estratos com uma UPA | 5 | Atenção na inferência |

## 8. Implicações para as regressões

Os diagnósticos preliminares não identificaram inconsistências que exigissem alterações ou exclusões adicionais de observações.

A análise das correlações mostrou que a exposição à IA está positivamente associada à escolaridade, reforçando a relevância de considerar características educacionais na especificação dos modelos.

A centralização da idade oferece uma alternativa para representar a relação não linear entre idade e rendimentos, sem a elevada correlação observada entre os termos originais.

A estrutura da variável de exposição por ocupação e as características do desenho amostral da PNAD deverão ser consideradas na definição da estratégia de inferência estatística.

**Importante:** este script realiza diagnósticos preliminares da base, mas não testa diretamente todas as hipóteses do modelo clássico de regressão linear. As verificações de heterocedasticidade, análise de resíduos, multicolinearidade condicional e outras propriedades específicas deverão ser realizadas após a estimação dos modelos.

## 9. Arquivos relacionados

- `hipoteses.R` — Script dos diagnósticos preliminares.
- `BASE_PRONTA.xlsx` — Base tratada PNAD–OIT.
- `estatisticas.R` — Script de estatísticas descritivas e identificação de outliers.
