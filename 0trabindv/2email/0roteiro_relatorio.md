# Parte do Stata do trabalho de ADE I



### O que eu quero

- [ ]  De início: proporção da renda de trabalho (`spllin`) e capital (`spkkin`) antes de taxação dos 50% mais pobres (`p0p50`) e dos 10% mais ricos (`p90p100`) nos EUA (`US`), "equal-split" entre casais (`j`), para indivíduos com mais de 20 anos (`992`) entre os anos 1980 e 2014 (`1980/2014`)
- [ ]  Final: proporção da renda de trabalho (`spllin`) e capital (`spkkin`) antes de taxação e riqueza líquida (`shweal`) dos 50% mais pobres (`p0p50`) e dos 10% mais ricos (`p90p100`) nos EUA e na França (`US FR`), "equal-split" entre casais (`j`), para indivíduos com mais de 20 anos (`992`) entre os anos 1980 e 2014 (`1980/2014`)
- [ ]  Fazer um "wide" para ter os dados spllin, spkkin e shweal em coluna ao invés de linha!

### Início

- [ ]  Criar estrutura de pastas
- [ ]  Criar do-file
- [ ]  Fazer cabeçalho
    - [ ]  O que faz este do-file
    - [ ]  Quem criou
    - [ ]  Data
- [ ]  `clear all`
- [ ]  `capture log close`
- [ ]  `set more off`
- [ ]  `version 15`
- [ ]  `mkr`
- [ ]  `log using (logs) ... , replace`
- [ ]  `ssc install ...`
- [ ]  `wid ... , clear`
    - [ ]  metadata
- [ ]  `save (source) (data), replace`
- [ ]  `des`
- [ ]  `save (progs) (do file) , replace (?)`
- [ ]  `log close`

### Rearranjar dados

- [ ]  Mudar observações
    - [ ]  Ver como é o original
        - [ ]  Ano? País? Faixa de renda?
    - [ ]  Mudar para formato mais "longo"
        - [ ]  `reshape wide stub, i(id) j(variable)`
        - [ ]  `i` : "linhas"
        - [ ]  `j` : "colunas"
            - [ ]  Resultado é mais observações e menos variáveis, com observações prévias (em linha) "multiplicadas" por uma das variáveis (em coluna)

### Alterações

- [ ]  O que tem que ser feito
    - [ ]  Adicionar descrições para cada variável (label variable)
    - [ ]  Adicionar descrições para cada categoria de variável (label values)
    - [ ]  Formatar o formato das variáveis (format/variable manager)
    - [ ]  Renomear variáveis
- [ ]  Checar tipos de variáveis
    - [ ]  `browse`
    - [ ]  `des`
- [ ]  Checar normalização de datas
    - [ ]  Se preciso, criar `daten` (data em número)
        - [ ]  `gen double newdate=(date)(datestr,"Y")`
        - [ ]  `gen refyear=year(newdate)`
- [ ]  Checar variáveis com observações faltantes
    - [ ]  .
        - [ ]  `inspect (?)`
- [ ]  Renomear variáveis com nomes "estranhos"
    - [ ]  Caixa baixa
    - [ ]  `rename`
- [ ]  Adicionar descrições às variáveis
    - [ ]  `label variable` "..."
- [ ]  Adicionar notas às variáveis
    - [ ]  O que elas contém
        - [ ]  `note (var)`
- [ ]  Remover variáveis irrelevantes
    - [ ]  `drop`
        - [ ]  Metadata
- [ ]  Eliminar ao máximo variáveis string
    - [ ]  Converter para número (float)
        - [ ]  `encode`
        - [ ]  Página 23
    - [ ]  Usar "value labels"
        - [ ]  `label define`
        - [ ]  `label values`
    - [ ]  Usar `labmask`
        - [ ]  Atribuir "label values" usando outras variáveis no "dataset"
    - [ ]  Usar `numlabel`
        - [ ]  Usar `label define` e `label values`
        - [ ]  Atribui valor numérico ao "label value"
- [ ]  Combinar "datasets" diferentes
    - [ ]  Código de países
        - [ ]  Usar passo a passo a partir da página 27
        - [ ]  `labmask`
        - [ ]  `numlabel`
        - [ ]  `drop`
        - [ ]  `des`
- [ ]  Criar "label" e notas para o data set
    - [ ]  `label data "..."`
    - [ ]  `note: "..."`
    - [ ]  `notes`
        - [ ]  `note: "Changed on c(current_date)'`
- [ ]  Organizar por variável numérica
    - [ ]  `sort (country) (year)`
    - [ ]  `order (varlist)`
- [ ]  "Comprimir"
    - [ ]  `compress`
- [ ]  Salvar
    - [ ]  `save "... (data)", replace`

### Debug

- [ ]  Verificar problemas
    - [ ]  `codebook, problems`
    - [ ]  `duplicates report`
    - [ ]  `panelstat`

### Análise de variáveis

- [ ]  `sum`
- [ ]  `des`
- [ ]  `codebook`, compact
- [ ]  `inspect`