# DESIGN.md: troco

O restante do design system ainda vai ser feito na fase de design. Por enquanto, este arquivo registra a marca e os padrões visuais proibidos.

## Marca: logo e temas

O logo é o porquinho "Curioso", em desenho 2D, feito com a skill `ip-as-logo` no nível de acabamento de um ícone de app: uma orelha caída e outra em pé, olhando para cima, com olhos ovais e brilho, textura leve de grão na pele, degradês suaves nas orelhas e luz vinda de cima à esquerda. Não tem boca nem cifrão.

O desenho é sempre o mesmo, e cada tema muda só as três cores: fundo, corpo e detalhes (olhos e narinas). O focinho e o interior das orelhas são um tom derivado do corpo: 82% corpo e 18% detalhes quando o corpo é claro (Escuro, Meia-noite, Outono), ou 62% corpo e 38% branco nos outros temas. A textura e os degradês vêm do desenho original e são mantidos em todos os temas.

Os arquivos ficam em `public/brand/`, em PNG de 1024 × 1024. Cada tema da configuração da aplicação usa o logo e a paleta correspondentes.

### Temas escuro e claro

| Tema | Arquivo | Fundo | Corpo | Detalhes | Esquema |
|---|---|---|---|---|---|
| Escuro | `logo-dark.png` | `#000000` | `#FFFFFF` | `#5C5C5C` | Neutros. O branco também é a cor das fontes. |
| Meia-noite | `logo-dark-midnight.png` | `#070B1B` | `#FFFFFF` | `#1F2951` | Monocromática azul (228°): fundo meia-noite escuro, detalhes num azul mais claro que o fundo, corpo branco |
| Claro | `logo-light.png` | `#FFFFFF` | `#EDA96E` | `#2A2A2A` | Damasco (28°) com preto suave nos detalhes; neutros não mudam o esquema |
| Fim de tarde | `logo-light-sunset.png` | `#F4E5C7` | `#EDA96E` | `#333333` | Análoga quente: fundo dourado (40°) vizinho do damasco (28°); detalhes em preto carbono, um pouco mais claro que o do Claro |

O tema Escuro usa obrigatoriamente preto puro no fundo, e o tema Claro, branco puro. Meia-noite é a variação do Escuro, e Fim de tarde, a do Claro.

### Outros temas

| Tema | Arquivo | Fundo | Corpo | Detalhes | Esquema |
|---|---|---|---|---|---|
| Azul | `logo-blue.png` | `#1A293C` | `#B3C6DB` | `#2D466B` | Monocromática (210° a 220°) |
| Outono | `logo-autumn.png` | `#9F4740` | `#F3E1C8` | `#EF9C44` | Análoga (4° a 35°) |
| Abóbora | `logo-pumpkin.png` | `#F3E1C8` | `#EF9C44` | `#9F4740` | Análoga, cores do Outono invertidas |
| Verde-água | `logo-sea-green.png` | `#19342B` | `#A9D1C3` | `#29604E` | Monocromática (160°) |
| Oceano | `logo-ocean.png` | `#231E3E` | `#A2CED7` | `#2A416F` | Análoga fria (190°, 220° e 250°) |
| Zumbi | `logo-zombie.png` | `#3C2032` | `#9FC6AC` | `#325D40` | Complementar (140° × 320°) |

## Ilustração das telas de entrada

Login (e, depois, cadastro e recuperação de senha) tem à direita o porquinho jogando uma nota para cima, em traço de giz de cera solto. É um desenho, não uma animação, e é diferente do logo de propósito: o logo é um ícone polido, a ilustração é mais humana e imperfeita. A arte original foi gerada no Figma (arquivo "troco - logo").

### Como a tela é montada

São três camadas:

1. **Arte:** imagem vertical 2:3 (840 × 1260, WebP) com fundo de uma cor única e chapada.
2. **Painel:** a coluna da direita ocupa metade da tela e avança 25% por baixo da coluna do formulário. Ela é pintada com a **mesma cor do fundo da arte**, por isso a borda da imagem não aparece. A imagem fica dentro do painel, alinhada à direita, com `object-fit: cover` e o personagem sempre inteiro.
3. **Recorte:** uma máscara CSS com `login-edge.svg` (esticado ao tamanho do painel) corta o painel com uma borda sinuosa, desenhada à mão: curvas suaves descendo na diagonal, sem dentes pontiagudos. A borda é a mesma em todos os temas.

Abaixo de 960 px de largura o painel some e fica só o formulário.

Para trocar a ilustração: gerar uma arte nova com fundo chapado, pintar o painel com a mesma cor e ajustar o `object-position` para o personagem não ser cortado pela borda. A borda só muda se o desenho dela mudar.

### Temas

Cada tema recolore o mesmo desenho com as três cores do logo: corpo, detalhes (olhos, narinas e cascos) e um fundo próprio do painel. A textura do giz é mantida. O focinho, as orelhas e as falhas do giz usam um tom derivado do corpo: 70% corpo e 30% detalhes quando o corpo é claro sobre painel escuro, ou 62% corpo e 38% branco nos outros. A nota fica verde em todos os temas, porque é ela que diz "dinheiro".

O fundo do painel é o fundo do logo com a luminosidade ajustada (6 pontos mais escuro nos temas claros, 7 mais claro nos escuros), para o painel se separar da página. Fim de tarde usa a cor da arte original.

| Tema | Arquivo | Fundo do painel |
|---|---|---|
| Escuro | `login-dark.webp` | `#121212` |
| Meia-noite | `login-dark-midnight.webp` | `#0E1737` |
| Claro | `login-light.webp` | `#F0F0F0` |
| Fim de tarde | `login-light-sunset.webp` | `#EDDBB5` |
| Azul | `login-blue.webp` | `#253A55` |
| Outono | `login-autumn.webp` | `#B7544C` |
| Abóbora | `login-pumpkin.webp` | `#EED3AF` |
| Verde-água | `login-sea-green.webp` | `#254C3F` |
| Oceano | `login-ocean.webp` | `#312A56` |
| Zumbi | `login-zombie.webp` | `#532C45` |

Os arquivos ficam em `public/brand/`, junto com `login-edge.svg`.

## Proibido

Padrões visuais que deixam a interface com cara de template ou de código gerado sem critério. Valem para toda tela, componente e gráfico, inclusive enquanto o resto do design system não existe, e têm prioridade sobre sugestões de skills de design (`frontend-design`, `impeccable` e outras). Exceção só com pedido explícito do João.

### Superfícies e cards

- **Gradiente desnecessário.** Fundos, cards, botões e textos usam cor sólida do tema. Gradiente só onde ele explica forma, como a luz e a sombra suaves do logo.
- **Neon em cima de preto.** Nada de cores saturadas e brilhantes sobre fundo escuro, nem brilho (`glow`) em texto ou borda. Nos temas escuros, destaques vêm da paleta do tema, com contraste WCAG AA.
- **Efeito de vidro em cards.** Sem `backdrop-blur` e sem fundo translúcido em cards. Card tem fundo sólido do tema e borda simples.
- **Sombra desproporcional.** Sem sombras grandes, borradas ou coloridas. Use no máximo as sombras do tema do shadcn (`shadow-sm` em cards); elevação maior só em camadas que flutuam, como menu, popover e diálogo.
- **Faixa colorida na borda de cards.** Sem barra de cor na lateral ou no topo do card. Se o card tem um estado (atrasado, estourado), diga em texto, com ícone se ajudar.

### Títulos e textos

- **Eyebrow em títulos.** Sem rótulo pequeno, em caixa alta e espaçado, acima do título. O título se basta; se precisar de contexto, use um subtítulo normal abaixo.
- **Emoji em títulos.** Nenhum emoji em título, botão, rótulo ou mensagem da interface.
- **Título genérico de gráfico.** Nada de título de template, como "Vendas por mês", "Receita" ou "Visão geral". O título diz o que o gráfico mostra com os termos do troco (glossário em `docs/conventions.md`), por exemplo "Gastos por categoria em novembro".
- **"Bem-vindo de volta, {usuário}".** Sem saudação no topo das telas. A tela abre com o título dela e com o dado principal. Saudação ou outro texto de abertura só quando o João pedir, do jeito que ele definir.
- **Bloco de "Insights" em texto.** Sem card ou seção chamada "Insights" (ou parecido) cheia de parágrafos que ninguém lê, nem frases de comentário sobre os dados ("Você está indo muito bem este mês!"). Os avisos do PRD (7.9, RF-29b, RF-137), como proximidade do limite e comparação entre meses, continuam valendo: aparecem curtos, junto do dado a que se referem, com o número e a base de comparação.

### Tags, chips e ícones

- **Tags desnecessárias.** Sem selos como "Ao vivo", "Tempo real", "Novo", "Beta" ou "IA", nem bolinha pulsando. Badge só quando mostra um estado real que o usuário precisa ver (ex.: fatura vencida).
- **Chips coloridos.** Sem chips em que cada um tem uma cor diferente só para enfeitar. Chips usam o estilo neutro do tema; cor só quando ela significa um estado, e sempre junto com texto.
- **Ícones coloridos nos KPIs.** Sem ícone dentro de quadrado ou círculo colorido em cada indicador. Indicador é rótulo e valor; ícone só se ajudar a reconhecer, na cor do texto.
- **Pílula verde com setinha.** Sem selo do tipo "↑ 12%" em verde ou vermelho. Variação é escrita como texto, com sinal, valor e base de comparação (ex.: "+R$ 120,00 em relação a outubro"). Cor nunca é a única informação.
- **Ícone de brilho.** Não use o ícone de brilho (`Sparkles` do lucide-react ou parecidos) para nada.

### Gráficos

- **Rosca com total no meio.** Sem gráfico de rosca ou pizza com o total no centro. Para dividir um total entre categorias, use barras horizontais ordenadas da maior para a menor, com o total escrito acima do gráfico.
- **Arco-íris nos gráficos.** Sem uma cor diferente para cada categoria. Uma cor do tema para a série e, se precisar destacar, uma segunda cor só para o item em destaque.
- **Sparkline pequena.** Sem minigráfico de tendência dentro de cards ou indicadores. O indicador mostra o número; se a tendência importa, ela vira um gráfico de verdade, com eixos e rótulos.

### Interação

- **Filtro que não filtra.** Todo filtro exibido muda os dados da tela. Não coloque filtro decorativo, de exemplo ou ainda sem efeito; se a API não suporta o filtro, ele não aparece.

## Pontos em aberto

- Paleta completa da interface para cada tema (botões, bordas, textos, estados e alertas), a partir das três cores do logo e com contraste WCAG AA. O comportamento da troca de tema está no PRD, 7.16 (Fase 1, tarefa FE-12).
- Favicon: em 16 px os detalhes finos somem. Antes de publicar, vale conferir se precisa de uma versão simplificada.
