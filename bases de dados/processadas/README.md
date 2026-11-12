## Dicionário de Variáveis — Base PNAD Contínua × OIT (2025)

### Descrição da base

A base integra os microdados individuais da **PNAD Contínua, 4º trimestre de 2025**, disponibilizados pelo Instituto Brasileiro de Geografia e Estatística (IBGE), aos indicadores de exposição ocupacional à inteligência artificial generativa da **Organização Internacional do Trabalho (OIT), 2025**.

A integração é realizada a partir dos códigos ocupacionais da PNAD, compatibilizados com a classificação internacional ISCO-08.

A base tratada apresentada no notebook `limpezadabase.ipynb` contém **214.286 observações e 31 variáveis**, distribuídas entre variáveis originais da PNAD, indicadores provenientes da OIT e variáveis construídas para a análise econométrica.

### 1. Variáveis originais — PNAD Contínua

| Variável | Descrição | Tipo / Codificação |
|---|---|---|
| `UF` | Unidade da Federação de residência do indivíduo. | Categórica; códigos oficiais do IBGE (11 a 53). |
| `UPA` | Unidade Primária de Amostragem, utilizada no desenho amostral da PNAD. | Identificador amostral. |
| `Estrato` | Estrato amostral ao qual pertence a observação. | Identificador amostral. |
| `V1022` | Situação do domicílio. | 1 = Urbano; 2 = Rural. |
| `V1028` | Peso amostral utilizado na expansão das observações para a população. | Numérica contínua. |
| `V2007` | Sexo do indivíduo. | 1 = Homem; 2 = Mulher. |
| `V2009` | Idade do indivíduo na data de referência. | Numérica, em anos completos. |
| `V2010` | Cor ou raça autodeclarada. | 1 = Branca; 2 = Preta; 3 = Amarela; 4 = Parda; 5 = Indígena; 9 = Ignorado. |
| `V4010` | Código da ocupação exercida no trabalho principal, segundo a Classificação de Ocupações para Pesquisas Domiciliares (COD). | Código ocupacional de quatro dígitos. |
| `V4013` | Código da atividade econômica principal do empreendimento em que o indivíduo trabalha. | Código de atividade econômica da PNAD. |
| `V4039` | Número de horas habitualmente trabalhadas por semana no trabalho principal. | Numérica, horas por semana. |
| `VD3004` | Nível de instrução mais elevado alcançado. | 1 = Sem instrução; 2 = Fundamental incompleto; 3 = Fundamental completo; 4 = Médio incompleto; 5 = Médio completo; 6 = Superior incompleto; 7 = Superior completo. |
| `VD3005` | Anos de estudo, padronizados para o ensino fundamental de nove anos. | Valores de 0 a 16, sendo 16 = 16 anos ou mais de estudo. |
| `VD4002` | Condição de ocupação na semana de referência. | 1 = Ocupado; 2 = Não ocupado. |
| `VD4009` | Posição na ocupação e categoria do emprego no trabalho principal. | Categórica; identifica vínculos como empregado, trabalhador doméstico, conta própria, empregador e trabalhador familiar auxiliar, com subdivisões. |
| `VD4016` | Rendimento mensal habitualmente recebido no trabalho principal. | Numérica, em reais (R$). |

### 2. Variáveis de integração e exposição à IA — OIT

Os indicadores de exposição ocupacional foram obtidos a partir de Gmyrek et al. (2025), *Generative AI and Jobs: A Refined Global Index of Occupational Exposure*.

| Variável | Descrição | Tipo / Codificação |
|---|---|---|
| `cod_pnad` | Código ocupacional extraído de `V4010` e padronizado para a integração com a OIT. | Texto de quatro dígitos. |
| `isco08_ajustado` | Código ocupacional após os ajustes de correspondência entre a classificação da PNAD e a ISCO-08. | Texto de quatro dígitos. |
| `isco08` | Código ocupacional correspondente encontrado na base da OIT. | Código ISCO-08 de quatro dígitos. |
| `Title` | Denominação da ocupação na classificação utilizada pela OIT. | Texto. |
| `score_ia` | Escore médio de exposição potencial à IA generativa da ocupação, proveniente de `mean_score_2025`. | Numérica contínua; valores mais elevados representam maior exposição potencial. |
| `potential25` | Categoria original de exposição ocupacional à IA generativa, segundo a metodologia da OIT de 2025. | `Not Exposed`, `Minimal Exposure`, `Exposed: Gradient 1`, `Exposed: Gradient 2`, `Exposed: Gradient 3` ou `Exposed: Gradient 4`. |
| `dummy_ia` | Indicador binário construído para comparar trabalhadores em ocupações de alta e baixa exposição à IA. | 0 = Baixa exposição; 1 = Alta exposição; `NaN` = Exposição intermediária. |
| `status_merge` | Resultado da correspondência entre os registros da PNAD e os indicadores da OIT. | `both` = Correspondência encontrada; `left_only` = Registro da PNAD sem correspondência; `right_only` = Registro exclusivo da base da OIT (não ocorre no merge à esquerda utilizado). |

**Critérios de construção de `dummy_ia`:**

| Classificação original (`potential25`) | `dummy_ia` |
|---|---|
| `Not Exposed` | 0 |
| `Minimal Exposure` | 0 |
| `Exposed: Gradient 1` | `NaN` |
| `Exposed: Gradient 2` | `NaN` |
| `Exposed: Gradient 3` | 1 |
| `Exposed: Gradient 4` | 1 |

Os valores ausentes de `dummy_ia` para os gradientes 1 e 2 são intencionais. Eles permitem comparar os grupos extremos de exposição sem classificar as ocupações intermediárias como altamente ou pouco expostas.

O indicador mede a **exposição potencial das tarefas de uma ocupação à IA generativa**, e não a utilização efetiva dessas tecnologias pelo trabalhador nem a probabilidade de substituição de seu emprego.

### 3. Variáveis construídas no tratamento da base

As variáveis abaixo foram criadas no notebook `limpezadabase.ipynb`, a partir das informações originais da PNAD e dos indicadores da OIT.

| Variável | Descrição | Construção / Codificação |
|---|---|---|
| `ln_renda` | Logaritmo natural do rendimento mensal habitual do trabalho principal. | `ln(VD4016)`. |
| `idade2` | Idade ao quadrado, utilizada para captar possíveis efeitos não lineares da idade sobre o rendimento. | `V2009 ** 2`. |
| `mulher` | Variável dummy para o sexo feminino. | 1 = Mulher; 0 = Homem. |
| `superior` | Variável dummy para conclusão do ensino superior. | 1 = `VD3004` igual a 7; 0 = `VD3004` entre 1 e 6. |
| `regiao` | Grande Região brasileira de residência, construída a partir de `UF`. | Norte, Nordeste, Sudeste, Sul ou Centro-Oeste. |
| `salario_hora` | Remuneração horária aproximada, obtida pela divisão do rendimento mensal habitual pelas horas mensais estimadas. | `VD4016 / (V4039 * 52/12)`, para jornadas positivas. |
| `grupoIA` | Agrupamento das categorias da OIT em três níveis de exposição. | Baixa, Intermediaria ou Alta. |

**Critérios de construção de `grupoIA`:**

| Classificação original | `grupoIA` |
|---|---|
| `Not Exposed` | Baixa |
| `Minimal Exposure` | Baixa |
| `Exposed: Gradient 1` | Intermediaria |
| `Exposed: Gradient 2` | Intermediaria |
| `Exposed: Gradient 3` | Alta |
| `Exposed: Gradient 4` | Alta |

As classificações `dummy_ia` e `grupoIA` são agregações analíticas definidas neste projeto a partir das categorias originais da OIT.

### 4. Critérios de seleção da amostra

O tratamento dos microdados foi realizado sequencialmente, preservando a base bruta original.

Foram aplicados os seguintes critérios:

1. **Condição de ocupação:** manutenção apenas dos indivíduos ocupados (`VD4002 = 1`).
2. **Idade:** manutenção dos indivíduos com 18 anos ou mais (`V2009 >= 18`).
3. **Rendimento:** manutenção dos trabalhadores com rendimento mensal habitual positivo (`VD4016 > 0`).
4. **Exposição à IA:** manutenção das observações com escore ocupacional disponível na OIT (`score_ia` não ausente).

A amostra resultante contém **214.286 observações**.


