# DESIGN.md: troco

Design system do Troco, consolidado a partir do protótipo da Fase 1 que o João aprovou em 26/11/2026 (<https://claude.ai/artifact/PT1eCFzPZqfnQpFX3QewKy>, versão 35). Vale para toda tela e componente do `troco-front`.

Ordem de prioridade: a seção "Proibido" vem antes de tudo, inclusive das skills de design. Depois vem o resto deste arquivo, e por último o padrão do shadcn/ui, para o que este arquivo não cobre. O que ainda não foi decidido fica em "Pontos em aberto".

## Princípios

O Troco é um lugar seguro para pensar e registrar o dinheiro do mês. Todo o resto deste arquivo sai daqui:

- **Leveza.** Pouca informação por tela. Cada tela tem um dado principal, e o detalhe extra fica recolhido ("Como a margem é calculada", "Mostrar as 9 categorias"). Nada de faixa com vários números lado a lado.
- **Nada pula.** O que muda de tamanho anima a altura em vez de saltar. Erros têm linha reservada, e o cartão não cresce quando um erro aparece.
- **Controles próprios.** Lista suspensa, calendário, caixa de marcar, opções e interruptor são do Troco, e não os nativos do navegador, para terem a mesma cara em todo lugar.
- **Cor nunca é a única informação.** Estado vem escrito, com ícone quando ajuda. Variação é texto com sinal, valor e base de comparação.
- **Movimento curto e com motivo.** Animação só para mostrar de onde algo veio ou para onde foi (veja "Movimento").
- **Nome da marca.** Na interface é sempre "Troco", com T maiúsculo, ao lado do logo e em títulos e textos. Repositório, pastas e arquivos continuam `troco`.

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
| Fim de tarde | `logo-light-sunset.png` | `#F3E1C8` | `#EF9C44` | `#9F4740` | Análoga quente (4° a 35°): fundo creme, corpo laranja e detalhes em marrom avermelhado. São as cores do Outono invertidas |

No logo, o tema Escuro usa obrigatoriamente preto puro no fundo, e o tema Claro, branco puro. Meia-noite é a variação do Escuro, e Fim de tarde, a do Claro. Até 26/11/2026 havia um décimo tema, Abóbora. As cores dele passaram para o Fim de tarde, e o Fim de tarde antigo (fundo `#F4E5C7`, corpo `#EDA96E`) saiu.

### Outros temas

| Tema | Arquivo | Fundo | Corpo | Detalhes | Esquema |
|---|---|---|---|---|---|
| Azul | `logo-blue.png` | `#1A293C` | `#B3C6DB` | `#2D466B` | Monocromática (210° a 220°) |
| Outono | `logo-autumn.png` | `#9F4740` | `#F3E1C8` | `#EF9C44` | Análoga (4° a 35°) |
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

O fundo do painel é o fundo do logo com a luminosidade ajustada (6 pontos mais escuro nos temas claros, 7 mais claro nos escuros), para o painel se separar da página.

| Tema | Arquivo | Fundo do painel |
|---|---|---|
| Escuro | `login-dark.webp` | `#121212` |
| Meia-noite | `login-dark-midnight.webp` | `#0E1737` |
| Claro | `login-light.webp` | `#F0F0F0` |
| Fim de tarde | `login-light-sunset.webp` | `#EED3AF` |
| Azul | `login-blue.webp` | `#253A55` |
| Outono | `login-autumn.webp` | `#B7544C` |
| Verde-água | `login-sea-green.webp` | `#254C3F` |
| Oceano | `login-ocean.webp` | `#312A56` |
| Zumbi | `login-zombie.webp` | `#532C45` |

Os arquivos ficam em `public/brand/`, junto com `login-edge.svg`.

## Temas da interface

São 9 temas (PRD 7.16, tarefa FE-12), cada um com a paleta completa da interface tirada das três cores do logo (fundo, corpo e detalhes, tabela em "Marca: logo e temas").

- **Padrão:** Fim de tarde. O tema não segue o do sistema operacional.
- **Onde fica a escolha:** na conta (`PATCH /v1/me { theme }`), com cópia num cookie para o servidor já desenhar a página no tema certo, sem piscar. Sem cookie e sem sessão, abre em Fim de tarde.
- **Como se aplica:** um bloco de variáveis por tema em `html[data-theme="<tema>"]`. Os componentes usam só as variáveis, nunca cor fixa.
- **Logo e ilustração:** trocam junto com o tema (`public/brand/logo-*.png` e `login-*.webp`). Favicon e ícone do PWA ficam fixos em Fim de tarde.
- **Troca:** acontece na hora, sem recarregar, com um esmaecer da página inteira de 0,24 s (View Transitions). Com movimento reduzido, a troca é direta.
- **Seletor:** fica em Configurações › Tema. Cada tema aparece numa prévia em miniatura pintada com as cores dele (menu, cartão, duas linhas de texto e uma barra no destaque), com o nome embaixo e "Padrão" ao lado de Fim de tarde. O escolhido tem borda na cor do texto e um check ao lado do nome. É um grupo de opções (`radio`): as setas do teclado também trocam o tema.

### Tokens

Cada token vira uma variável de CSS. A última coluna diz qual variável do shadcn/ui ele alimenta, para os componentes de `src/components/ui/` funcionarem sem ajuste.

| Token | Uso | shadcn/ui |
|---|---|---|
| `bg` | Fundo da área central e das telas de entrada | `--background` |
| `sidebar` | Menu lateral e barras do celular | `--sidebar` |
| `card` | Cartões, modais, painéis laterais, listas suspensas | `--card`, `--popover` |
| `line` | Bordas de cartão e divisórias | `--border` |
| `line-strong` | Borda ao passar o mouse e linha de total | – |
| `hover` | Fundo de item ao passar o mouse, trilho do seletor segmentado | `--accent` |
| `zebra` | Linhas pares das listas | `--muted` |
| `track` | Trilha das barras e medidores | `--secondary` |
| `fg` | Texto principal. Também é o fundo do botão principal, do aviso flutuante e do item escolhido em grupos de opções | `--foreground`, `--primary` |
| `muted` | Texto secundário, rótulos e ícones de apoio | `--muted-foreground` |
| `on-primary` | Texto sobre `fg` | `--primary-foreground` |
| `primary-hover` | Botão principal ao passar o mouse | – |
| `apricot` | Cor de destaque: barras e medidores, marcador da aba ou seção ativa | `--chart-1` |
| `apricot-soft` | Item ativo do menu, avisos, contagem em aba e selo de estado | – |
| `apricot-text` | Texto e ícone sobre `apricot-soft`. Também é a cor de notificação: fundo da pílula e do ponto de pendências, com o número em `on-primary` | `--accent-foreground` |
| `input-b` | Borda de campo | `--input` |
| `focus-b` | Borda do campo em foco | – |
| `focus-soft` | Halo do campo em foco | – |
| `ring` | Contorno de foco por teclado | `--ring` |
| `positive` | Valor de renda, sucesso, check das regras da senha | – |
| `negative` | Erro, exclusão | `--destructive` |
| `negative-hover` | Botão de excluir ao passar o mouse | – |
| `negative-soft` | Fundo de alerta de erro | – |
| `on-status` | Texto sobre `positive` e `negative` (botão "Salvo" e "Revise os campos") | – |
| `ghost` | Valor ainda não digitado na prévia do lançamento | – |
| `disabled` | Dia indisponível no calendário | – |
| `scroll`, `scroll-hover` | Polegar da barra de rolagem | – |
| `art-bg` | Painel da ilustração das telas de entrada | – |
| `shadow` | Cor (RGB) das sombras das camadas que flutuam | – |
| `scrim` | Véu atrás de modal e painel lateral | – |

### Paletas

Todos os temas saem das cores do logo por regras iguais para todos. Depois, cada cor de texto ou de borda é ajustada, clareando ou escurecendo, até passar no contraste:

- **Temas escuros** (Escuro, Meia-noite, Azul, Verde-água, Outono, Oceano, Zumbi): o fundo é o fundo do logo. Outono escurece 45%, porque o vermelho do logo é claro demais para fundo de leitura. Cartão, linhas e trilha são o fundo com o corpo do logo misturado (11%, 34% e 26%), para os cartões se destacarem bem do fundo. O menu leva a cor dos detalhes do logo (metade fundo, metade detalhe), para o tema ter duas cores e não ficar monocromático; em Outono, o menu é o vermelho do logo escurecido 30%, e em Escuro, um cinza 7% mais claro que o fundo. O texto é o corpo clareado. O destaque é o corpo do logo; quando o corpo é branco, vale um azul tirado dos detalhes (Meia-noite) ou cinza (Escuro). Em Outono, o destaque é o laranja dos detalhes. O texto sobre verde e vermelho é a cor do fundo.
- **Claro:** neutros cinza, com o damasco do logo como destaque. O fundo da página é um cinza claro (`#F2F2F2`), e o menu e os cartões ficam em branco puro, para não ficar branco no branco.
- **Fim de tarde:** usa as cores do antigo Abóbora (creme, laranja e marrom avermelhado). O fundo da página é o creme do logo quase sem clarear, o menu e os cartões são versões mais claras dele, e não branco puro, para o tema se distinguir do Claro. O texto é o marrom dos detalhes escurecido, e o destaque é o laranja do corpo, escurecido até 3:1.
- **Verde e vermelho:** em todos os temas são o mesmo verde (150°) e o mesmo vermelho (6°), só com a luminosidade ajustada para o contraste.

A geração e a conferência das paletas estão em `prototipo-fase1/v36/palettes.py`, na pasta do projeto. Mudou uma cor do logo, rode de novo e atualize a tabela.

| Token | Escuro | Meia-noite | Claro | Fim de tarde | Azul | Verde-água | Outono | Oceano | Zumbi |
|---|---|---|---|---|---|---|---|---|---|
| `bg` | `#000000` | `#070B1B` | `#F2F2F2` | `#F5E6D0` | `#1A293C` | `#19342B` | `#572723` | `#231E3E` | `#3C2032` |
| `sidebar` | `#121212` | `#131A36` | `#FFFFFF` | `#F9F0E3` | `#243854` | `#214A3D` | `#6F322D` | `#273056` | `#373E39` |
| `card` | `#1C1C1C` | `#121728` | `#FFFFFF` | `#FDF9F4` | `#2B3A4D` | `#29453C` | `#683B35` | `#31314F` | `#47323F` |
| `line` | `#575757` | `#2A2F42` | `#E2E2E2` | `#E9CFB8` | `#4E5E72` | `#4A695F` | `#8C665B` | `#4E5A72` | `#5E585B` |
| `line-strong` | `#474747` | `#494C59` | `#D4D4D4` | `#DACECA` | `#546070` | `#536962` | `#85615C` | `#595971` | `#6B5A65` |
| `hover` | `#333333` | `#1B2032` | `#EBEBEB` | `#EED8C0` | `#39485C` | `#365349` | `#764C44` | `#3C415D` | `#50414A` |
| `zebra` | `#262626` | `#161B2C` | `#F6F6F6` | `#FAF3E9` | `#314154` | `#2F4C42` | `#6E433C` | `#363855` | `#4B3944` |
| `track` | `#424242` | `#222639` | `#E8E8E8` | `#ECD5BD` | `#425265` | `#3E5D53` | `#80574E` | `#444C66` | `#564B52` |
| `fg` | `#FFFFFF` | `#F2F4FA` | `#2A2A2A` | `#502420` | `#EAEFF5` | `#E7F2EE` | `#FCF7F0` | `#E5F1F4` | `#E4EFE8` |
| `muted` | `#9C9C9C` | `#868993` | `#696969` | `#795754` | `#B0B8C1` | `#B5C3BE` | `#D9CBC5` | `#AAB1BC` | `#B4B4B4` |
| `on-primary` | `#000000` | `#070B1B` | `#FFFFFF` | `#FFFFFF` | `#1A293C` | `#19342B` | `#572723` | `#231E3E` | `#3C2032` |
| `primary-hover` | `#FFFFFF` | `#D1D4DF` | `#191919` | `#301613` | `#DCE5EE` | `#D8EAE3` | `#FAF2E6` | `#D4E8ED` | `#D3E5D9` |
| `apricot` | `#8D8D8D` | `#586BBB` | `#AC7B50` | `#A86E30` | `#B3C6DB` | `#A9D1C3` | `#F0A555` | `#A2CED7` | `#9FC6AC` |
| `apricot-soft` | `#303030` | `#1F2642` | `#FBEEE2` | `#FCEBDA` | `#435367` | `#405E54` | `#804E3B` | `#454D67` | `#574D53` |
| `apricot-text` | `#999999` | `#7E8DCB` | `#8B6441` | `#915F2A` | `#B6C9DD` | `#B5D8CC` | `#F7CDA0` | `#A2CED7` | `#A9CCB4` |
| `input-b` | `#707070` | `#646873` | `#8A8A8A` | `#987D78` | `#828C99` | `#859791` | `#B19892` | `#818496` | `#90878D` |
| `focus-b` | `#A2A2A2` | `#9699A2` | `#686868` | `#7F5E59` | `#A6AFB9` | `#A7B7B2` | `#CBB9B3` | `#A4AAB7` | `#ADABAD` |
| `focus-soft` | `#353535` | `#212948` | `#FCF0E5` | `#FCEDDD` | `#49596C` | `#45645A` | `#86523C` | `#4A546D` | `#5A5357` |
| `ring` | `#8D8D8D` | `#586BBB` | `#AC7B50` | `#A86E30` | `#B3C6DB` | `#A9D1C3` | `#F0A555` | `#A2CED7` | `#9FC6AC` |
| `positive` | `#43B079` | `#3DA16F` | `#1E764A` | `#1B6C44` | `#90D5B2` | `#A4DDC1` | `#AEE0C7` | `#83D0AA` | `#8BD3AF` |
| `negative` | `#E08379` | `#DB7267` | `#BA3C2E` | `#A9372A` | `#EBAFA9` | `#EFBEB8` | `#F3CFCB` | `#E8A69E` | `#EBB0AA` |
| `negative-hover` | `#E49289` | `#DF8379` | `#9E3327` | `#902F24` | `#EDB9B3` | `#F1C6C1` | `#F4D5D1` | `#EBB1AA` | `#EDB9B4` |
| `negative-soft` | `#3B2C2B` | `#322430` | `#F7E8E6` | `#F5E7E5` | `#494B5A` | `#48574E` | `#7E514B` | `#4E425A` | `#61444E` |
| `on-status` | `#000000` | `#070B1B` | `#FFFFFF` | `#FFFFFF` | `#1A293C` | `#19342B` | `#572723` | `#231E3E` | `#3C2032` |
| `ghost` | `#5C5C5C` | `#515563` | `#CACACA` | `#D2C4BF` | `#606D7C` | `#5E756E` | `#917069` | `#63677D` | `#73676E` |
| `disabled` | `#696969` | `#5E626F` | `#BBBBBB` | `#C6B5B0` | `#6C7886` | `#6A8079` | `#9A7B75` | `#6E7287` | `#7C7278` |
| `scroll` | `#2E2E2E` | `#313543` | `#D4D4D4` | `#DCC9B6` | `#3F4D5D` | `#3E564E` | `#754C48` | `#46445F` | `#5A4553` |
| `scroll-hover` | `#474747` | `#494C59` | `#C0C0C0` | `#CCB6A4` | `#546070` | `#536962` | `#85615C` | `#595971` | `#6B5A65` |
| `art-bg` | `#121212` | `#0E1737` | `#F0F0F0` | `#EED3AF` | `#253A55` | `#254C3F` | `#B7544C` | `#312A56` | `#532C45` |
| `shadow` | `0 0 0` | `0 0 0` | `0 0 0` | `60 30 10` | `0 0 0` | `0 0 0` | `0 0 0` | `0 0 0` | `0 0 0` |
| `scrim` | `0 0 0 / .5` | `0 0 0 / .5` | `43 43 43 / .24` | `43 43 43 / .24` | `0 0 0 / .5` | `0 0 0 / .5` | `0 0 0 / .5` | `0 0 0 / .5` | `0 0 0 / .5` |

`shadow` é a cor das sombras em RGB, usada como `rgb(var(--shadow) / .22)`. `scrim` já leva a opacidade.

### Contraste

Todos os temas passam no WCAG AA. Texto pede 4,5:1. Gráfico, borda de campo e contorno de foco pedem 3:1. Cada par foi conferido contra todas as superfícies onde aparece: fundo, cartão, menu, item com o mouse em cima e linha zebrada.

| Par | Mínimo | Escuro | Meia-noite | Claro | Fim de tarde | Azul | Verde-água | Outono | Oceano | Zumbi |
|---|---|---|---|---|---|---|---|---|---|---|
| texto | 4,5 | 12,63 | 13,50 | 12,04 | 9,43 | 6,80 | 6,22 | 6,42 | 7,26 | 6,87 |
| texto secundário | 4,5 | 4,60 | 4,63 | 4,61 | 4,61 | 4,64 | 4,62 | 4,61 | 4,62 | 4,61 |
| botão principal | 4,5 | 21,00 | 13,23 | 14,35 | 13,01 | 11,56 | 10,72 | 10,99 | 12,49 | 11,06 |
| destaque (gráfico) | 3 | 3,03 | 3,02 | 3,01 | 3,00 | 4,58 | 4,35 | 3,01 | 5,00 | 4,42 |
| texto no destaque claro | 4,5 | 4,63 | 4,64 | 4,61 | 4,66 | 4,64 | 4,63 | 4,62 | 4,92 | 4,62 |
| borda de campo | 3 | 3,44 | 3,20 | 3,08 | 3,09 | 3,39 | 3,40 | 3,43 | 3,37 | 3,36 |
| contorno de foco | 3 | 5,13 | 3,59 | 3,29 | 3,47 | 6,62 | 6,26 | 4,51 | 7,34 | 6,21 |
| positivo | 4,5 | 4,65 | 5,02 | 4,70 | 4,65 | 5,47 | 5,50 | 4,95 | 5,49 | 5,48 |
| negativo | 4,5 | 4,63 | 4,62 | 4,67 | 4,66 | 4,61 | 4,63 | 4,61 | 4,61 | 4,63 |
| número na pílula de pendências | 4,5 | 7,37 | 6,11 | 5,25 | 5,42 | 8,68 | 8,71 | 8,25 | 9,31 | 8,29 |
| texto em verde/vermelho | 4,5 | 7,69 | 6,08 | 5,56 | 6,41 | 7,88 | 8,12 | 8,31 | 7,82 | 7,84 |

Na FE-12, o teste com axe nas telas principais confere os 9 temas de novo.

## Tipografia

- **Fonte:** Geist (Google Fonts, pesos 400, 500 e 600), com `ui-sans-serif, system-ui` de reserva. Números sempre com `font-variant-numeric: tabular-nums`, para valores alinharem em coluna.
- **Corpo:** 16 px, altura de linha 1,5. Texto secundário em 14 px na cor `muted`. Nada abaixo de 12 px.
- **Títulos:** título da tela 32 px (28 px no celular), peso 600, espaçamento −0,025em. Título de cartão 19 px, peso 600. Título de modal 20 px. Coluna de detalhes 17 px.
- **Número principal** (margem disponível): 56 px (44 px no celular), peso 600, espaçamento −0,035em, com o "R$" em 26 px na cor `muted`.
- **Telas de entrada:** frase "Seu mês, com calma." de 38 a 56 px, que vira uma linha só em tela baixa. Título do cartão 20 px.
- **Dinheiro:** sempre formatado com `Intl.NumberFormat` na moeda do ledger ("R$ 1.933,27"). Sinal de menos é o "−" tipográfico.

## Forma e espaço

- **Raios:** 10 px (itens de menu, alertas), 12 px (campos), 14 px (listas suspensas, opções, avisos), 20 px (cartões, modais, calendário) e pílula (botões, busca, abas em pílula, aviso flutuante).
- **Alturas:** botão 42 px (36 px pequeno, 46 a 48 px no envio de formulário); campo 48 px (44 px nas telas de entrada e 40 px em tela baixa); campo de valor principal 64 px; item de menu 44 px. Alvo de toque nunca menor que 36 px.
- **Cartão:** fundo `card`, borda de 1 px em `line`, raio de 20 px, espaço interno de 28 × 32 px (22 × 20 px no celular). Sem sombra.
- **Sombra:** só em camadas que flutuam (lista suspensa, calendário, popover, modal, painel lateral, aviso flutuante): `0 12px 32px -12px rgb(shadow / .22), 0 2px 6px rgb(shadow / .06)`.
- **Espaço entre blocos:** 32 px entre cartões no computador e 24 px no celular. 36 px entre o título da tela e o conteúdo.

## Layout do app

- **Menu lateral:** 256 px de largura, fixo, com logo, botão "Novo lançamento", Painel, Lançamentos, Mês e Configurações. No rodapé ficam "Recolher menu" e "Sair". Não tem bloco de conta (avatar, nome e setas); o perfil fica em Configurações.
- **Item ativo:** fundo `apricot-soft`, texto `fg` em peso 500.
- **Pendências no menu:** quando há fixas a confirmar, o item Mês mostra à direita uma pílula de notificação com o número: fundo `apricot-text`, número em `on-primary`, 22 px de altura, peso 600. O leitor de tela ouve "3 fixas a confirmar", que também aparece como dica ao passar o mouse.
- **Menu recolhido:** 76 px, só com os ícones, e o nome aparece numa dica ao passar o mouse. A pílula de pendências vira um ponto de 8 px na mesma cor, no canto do ícone, e o estado fica lembrado no navegador. Fechar tem um efeito de estilingue de 0,5 s, e abrir é uma transição simples de 0,3 s.
- **Celular (abaixo de 960 px):** o menu some. Em cima fica uma barra com o logo; embaixo, uma barra com os quatro destinos (o ativo tem o ícone sobre `apricot-soft`), respeitando a área segura. As pendências aparecem como o mesmo ponto no ícone de Mês.
- **Conteúdo:** até 1160 px, com 40 px de margem em cima e 48 px dos lados (16 px no celular). Lançamentos usa 860 px.
- **Cabeçalho da tela:** título, uma linha de subtítulo em `muted` e as ações à direita. No celular, as ações ocupam a largura toda.
- **Coluna de detalhes:** Painel e Mês têm uma coluna de 300 px à direita, a partir de 1240 px. Abaixo disso, ela desce para depois do conteúdo, separada por uma linha.
- **Larguras de quebra:** 1240 px (coluna de detalhes), 1100 px (índice de datas e subnavegação viram pílulas no topo), 960 px (celular) e 640 px (uma coluna nos formulários).
- **360 px:** toda tela funciona em 360 px de largura sem rolagem lateral.

## Componentes

### Botões

- **Principal:** fundo `fg`, texto `on-primary`, em pílula. Um por área.
- **Contorno:** fundo `card`, borda `line` (`line-strong` ao passar o mouse).
- **Excluir:** contorno com texto `negative`. Na confirmação, botão cheio em `negative`.
- **Ao apertar:** o botão encolhe para 0,97.
- **Retorno de envio:** enquanto espera a API, o botão mostra um girador e um verbo ("Entrando", "Salvando") e trava o formulário. Se der certo, vira verde (`positive`) com check e "Salvo" (ou "Salva", "Conta criada", "Mês aberto"). Se faltar algo, vira vermelho com alerta e "Revise os campos", com uma leve tremida, e volta sozinho depois de 1,8 s. O botão mantém a largura durante a troca.
- **Link de texto:** sublinhado discreto que fica na cor do texto ao passar o mouse ("Corrigir data", "Esqueci minha senha", "Definir depois").

### Campos

- **Campo:** borda `input-b` e raio de 12 px. Rótulo em cima, peso 500.
- **Foco:** a borda escurece (`focus-b`) e aparece um halo de 3 px em `focus-soft`. Nunca um contorno grosso e escuro. O contorno `ring` de 2 px fica para o foco por teclado nos outros controles.
- **Valor em dinheiro:** "R$" dentro do campo, à esquerda e em `muted`. Máscara de centavos enquanto digita ("0,00"), teclado numérico no celular.
- **Percentual:** "%" dentro do campo, à direita.
- **Senha:** olho dentro do campo, que mostra o estado. Fechado e com cílios, a senha está escondida; aberto, à mostra. O formato é o de um olho comum, com pupila em anel, nunca fino. Abre e fecha em 0,26 s e, aberto, pisca a cada 5 s.
- **Regras da senha:** as quatro regras ficam embaixo do campo, em duas colunas, e cada uma vira check verde enquanto a pessoa digita (RF-02). No erro, as que faltam ficam vermelhas.

### Lista suspensa e calendário

- **Lista suspensa:** botão em pílula com o valor e uma seta, que gira ao abrir. A lista flutua por cima de tudo (posição fixa), nunca presa à rolagem de um modal, e abre para cima quando falta espaço embaixo. Tem setas, Home, End, Enter e Esc. O item escolhido fica com check.
- **Calendário:** campo com ícone e a data por extenso ("5 de novembro de 2026", ou "5 nov. 2026" se o campo for estreito). Abre flutuando, com setas por dia, PageUp/PageDown por mês e Esc. Hoje tem um sublinhado em `apricot`. O dia escolhido fica com fundo `fg`. Dias fora do limite ficam em `disabled` e não respondem. Em modal de uma pergunta só ("Corrigir o início do mês"), o calendário aparece aberto dentro do modal.

### Opções, caixa de marcar e interruptor

- **Opções com explicação** (tipo de meta, tipo de fixa): cartões lado a lado (um embaixo do outro no celular), com bolinha, título e uma linha de explicação. O escolhido tem borda `focus-b`.
- **Escolha rápida** (filtros): pílulas com contorno. A escolhida fica com fundo `fg`.
- **Caixa de marcar:** quadrado de 20 px com raio de 6 px. Marcada, fica com fundo `fg` e check. Usada no aceite dos termos.
- **Interruptor:** 36 × 22 px. Ligado, fica com fundo `fg`. Usado em "Usar este valor nos próximos meses" e em pausar fixa.
- **Seletor segmentado** (Gasto/Renda): trilho em `hover` e o escolhido num cartão que desliza em 0,4 s com ease-in-out.

### Cartões, listas e abas

- **Listas de lançamentos:** um cartão por dia, com cabeçalho clicável que recolhe o dia e linhas zebradas. Ao lado fica um índice de datas, fixo na rolagem, que vira pílulas no topo abaixo de 1100 px.
- **Linhas de lista:** descrição em cima e categoria ou data embaixo, em `muted`. O valor fica à direita (renda em `positive`, com "+"). "A confirmar" aparece num selo em `apricot-soft`, que no celular vira texto.
- **Abas:** texto com um traço de 2 px embaixo da aba ativa e a contagem ao lado. Com as setas do teclado, a aba troca sem animação.
- **Subnavegação** (Configurações): lista vertical com um traço na cor de destaque à esquerda do item ativo. Abaixo de 1100 px, vira pílulas no topo.
- **Barras por categoria:** nome, valor e percentual em cima e a barra embaixo, em `apricot` sobre `track`. Ordem da maior para a menor, as 5 maiores aparecem e o resto fica atrás de "Mostrar as 9 categorias".
- **Aviso no fluxo:** faixa em `apricot-soft` com ícone, uma frase curta com o número em negrito e uma ação à direita ("3 fixas a confirmar desde a virada. Até você revisar, a margem usa o valor do mês anterior." + "Revisar fixas").
- **Lista vazia:** cartão centralizado com título, uma frase do que fazer e o botão da ação.
- **Esqueleto de carregamento:** só quando a espera pela API é real. Nunca para enfeitar.

### Camadas

- **Painel lateral:** 440 px, entra pela direita. No celular, sobe de baixo como folha, com cantos arredondados. Tem cabeçalho com título e fechar, corpo que rola e rodapé com as ações. Usado para ver um lançamento e editar fixas e categorias.
- **Modal:** 440 px para confirmações e até 640 px para formulários. Formulário em modal tem 2 colunas no computador e 1 no celular. Confirmação de exclusão diz o que acontece e tem o botão vermelho à direita.
- **Modal em etapas** (virar o mês): "1 de 3" à esquerda do rodapé. Avançar desliza o conteúdo para a esquerda, e voltar, para a direita.
- **Formulário em tela cheia** (novo lançamento): barra no topo com fechar, o título e "Salvar lançamento". O formulário fica à esquerda e a prévia do lançamento à direita (a prévia some abaixo de 960 px).
- **Véu:** `scrim` atrás de modal e painel lateral. Clicar nele fecha.
- **Aviso flutuante (toast):** pílula em `fg` com texto `on-primary`, centralizada embaixo (acima da barra no celular). Some depois de 2,8 s. Uma frase só ("Lançamento excluído").
- **Foco:** toda camada prende o foco enquanto está aberta, fecha com Esc e devolve o foco para quem a abriu.

### Barra de rolagem

Fina (12 px com 4 px de folga, polegar de 4 px), sem setas, com polegar arredondado em `scroll` (`scroll-hover` ao passar o mouse). Dentro de modais e listas, tem folga nas pontas para não encostar nos cantos arredondados.

## Formulários e erros

- **Linha reservada:** todo campo tem a linha de erro embaixo, vazia quando não há erro. O cartão não muda de altura quando o erro aparece. A mensagem tem uma linha só, em 13 a 14 px, na cor `negative`.
- **Erro da API:** aparece na linha do campo a que se refere, traduzido pelo `code` (ex.: `EMAIL_TAKEN` → "Esse e-mail já tem conta. Entrar"). Sem caixa de alerta solta no topo.
- **Ao enviar com erro:** o primeiro campo com erro recebe o foco e o botão mostra "Revise os campos". O erro some assim que a pessoa corrige o campo.
- **Mensagens:** dizem o que fazer ("Escolha o dia em que o salário caiu."), e não o que está errado ("Campo obrigatório").
- **Bloco que some ou aparece** dentro do formulário (subcategoria, campos de renda): a altura anima em vez de pular.
- **Formulário em linha** (renda variável, sazonal): fundo `zebra` dentro do cartão. Depois do "Salva", espera 0,75 s e fecha, e a linha nova acende na largura toda do cartão por 2,4 s.

## Movimento

- **Regras gerais:** só `transform` e `opacity` (altura só para recolher ou abrir um bloco). Ease-out forte, `cubic-bezier(.23, 1, .32, 1)`. A saída vai pelo mesmo caminho da entrada, mais curta.
- **Troca de tela:** o conteúdo sobe 4 px e aparece em 0,22 s, em cascata de 40 ms.
- **Troca de aba ou seção:** só o painel muda (sobe 3 px, 0,18 s). Nada anima quando a troca vem das setas do teclado.
- **Painel lateral:** entra com 0,3 s. **Modal:** aparece de 0,97 para 1 em 0,18 s. **Lista suspensa e calendário:** 0,14 s.
- **Linha salva** acende por 1,6 s. **Linha confirmada** recolhe a altura antes de sair, para a lista não pular.
- **Margem que mudou:** reaparece com um desfoque curto.
- **Troca de tema:** esmaecer de 0,24 s.
- **Movimento reduzido:** fica só a opacidade, sem deslocamento, e o olho da senha não pisca.

## Telas da Fase 1

O protótipo navegável está em <https://claude.ai/artifact/PT1eCFzPZqfnQpFX3QewKy> (versão 35). As telas seguem o PRD (seção 9) e o plano (`docs/plans/phase-1.md`).

### Entrada: login, cadastro, recuperar e redefinir senha (FE-03)

- **Estrutura:** logo no topo, a frase "Seu mês, com calma." e o cartão do formulário à esquerda. A ilustração fica à direita (seção "Ilustração das telas de entrada"). As quatro telas usam a mesma frase e a mesma arte.
- **Sem rolagem:** nenhuma tela de entrada rola no computador a partir de 768 px de altura. Por isso os campos têm 44 px, as regras da senha ficam em duas colunas e a frase vira uma linha em tela baixa.
- **Login:** e-mail e senha, com "Esqueci minha senha" ao lado do rótulo da senha. O erro de credencial é um só para e-mail inexistente e senha errada, e aparece na linha da senha.
- **Cadastro:** nome, e-mail, senha com as regras e aceite dos Termos de uso e da Política de privacidade. Leva direto para o primeiro acesso (RF-05).
- **Recuperar senha:** sempre responde "Confira seu e-mail", sem dizer se a conta existe. O link vale 1 hora.
- **Redefinir:** avisa que salvar a senha nova encerra a sessão em todos os aparelhos. Link vencido ou já usado tem tela própria ("Esse link não vale mais").
- **E-mail digitado:** acompanha a pessoa entre login, cadastro e recuperar.

### Primeiro acesso (FE-05)

- **Quando aparece:** depois do cadastro, ou sempre que `periods/current` responde `NO_PERIOD`. Usa a mesma moldura das telas de entrada.
- **Passo 1, "Quando você recebeu o último salário?":** calendário com limite em hoje e uma linha explicando que o mês vai até a véspera do próximo salário e que dá para corrigir depois. "Continuar" abre o primeiro mês.
- **Passo 2, "Quanto você quer guardar por mês?":** meta de reserva em Percentual ou Valor fixo, com "Salvar e começar" e "Definir depois". Definir depois deixa a meta em 0%.

### Termos de uso e Política de privacidade (FE-03)

- **Estrutura:** página pública com o logo e o botão "Voltar para o cadastro" (ou "Voltar para o login") no topo. O texto fica numa coluna de leitura de 680 px, e a página rola normalmente.
- **Texto:** provisório, montado a partir de `docs/security-lgpd.md`, com a data da versão. No cadastro, o link abre em outra aba para não perder o que foi digitado.

### Painel (FE-07)

- **Margem disponível:** em destaque, com o medidor do quanto já foi gasto da margem do mês. A conta completa ("Como a margem é calculada") fica recolhida.
- **Abaixo da margem:** o aviso de fixas a confirmar, quando há, e os gastos por categoria.
- **Coluna de detalhes:** reserva do mês (meta, já guardado, falta guardar) e os próximos sazonais.
- **Cabeçalho:** "Virar o mês" à direita.

### Lançamentos (FE-06)

- **Topo:** abas Todos, Gastos e Rendas, com contagem. Embaixo, busca, filtros num popover e o mês financeiro numa lista suspensa. Os filtros escolhidos aparecem como pílulas removíveis e ficam na URL.
- **Lista:** um cartão por dia. Clicar num lançamento abre o painel lateral com os detalhes, editar e excluir.
- **Novo lançamento:** formulário em tela cheia com prévia. Começa no seletor Gasto/Renda e no valor em destaque, e diz em qual mês o lançamento entra. Lançar num mês fechado avisa que a sobra desse mês é recalculada.

### Mês: cadastro rápido, revisão das fixas e virada (FE-08, FE-09)

- **Abas em sequência:** Fixas › Rendas variáveis › Sazonais › Meta de reserva, cada uma com "Próxima etapa" no fim.
- **Revisão das fixas ("Teve mudança em algum valor?"):**
  - Cada fixa a confirmar tem o valor sugerido num campo, o valor do mês anterior embaixo do nome e um botão "Confirmar". Embaixo da lista ficam "Confirmar tudo" e as já confirmadas, recolhidas.
  - Quando o valor muda e o campo perde o foco, a tela pede à API a prévia da revisão e mostra a diferença ("+R$ 4,30, +3,1% em relação ao mês anterior"). Se passar da variação esperada, aparece o aviso "Fora da variação esperada de ±5%", com ícone.
  - Se o valor muda, aparece "Usar este valor nos próximos meses".
  - O front não calcula diferença nem variação.
- **Coluna "Este mês":** quando o mês começou, com "Corrigir data", e a sobra do mês anterior. "Desfazer a virada" só aparece enquanto é permitido. Corrigir a data também move para o novo dia as fixas geradas na virada.
- **Virar o mês:** modal em 3 etapas.
  1. Quando o salário caiu, com calendário entre o início do mês atual e hoje.
  2. Fechamento: sobra ou estouro e quanto foi investido.
  3. Confirmação.
  
  Depois leva à revisão das fixas.

### Configurações (FE-10, FE-12)

- **Subnavegação:** Fixas › Categorias › Meta de reserva › Tema › Perfil › Seus dados.
- **Fixas e categorias:** abrem no painel lateral. A fixa tem variação esperada (±%), pausar e "lançar também neste mês". Categoria de sistema não tem excluir. Excluir uma categoria com lançamentos pergunta para onde mover.
- **Tema:** o seletor descrito em "Temas da interface".
- **Seus dados:** exportar (baixa um `.json`) e excluir conta (com senha, em modal de confirmação).

## Acessibilidade

- **Contraste:** WCAG AA em todos os temas (tabela em "Contraste").
- **Teclado:** foco sempre visível. Ordem de tabulação na ordem visual. Toda ação tem teclado, inclusive lista suspensa, calendário, abas (setas) e seletor de tema.
- **Rótulos:** todo campo tem rótulo visível. Botão só com ícone tem `aria-label`. Lista suspensa e calendário dizem o valor escolhido no nome acessível.
- **Anúncios:** "Salvo", "Revise os campos", "A senha atende todas as regras" e "Tema aplicado e salvo" são lidos pelo leitor de tela, numa região `aria-live` discreta.
- **Erros:** campo com erro tem `aria-invalid` e `aria-describedby` apontando para a mensagem.
- **Movimento reduzido:** respeita `prefers-reduced-motion` (veja "Movimento").

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

- **Favicon:** em 16 px os detalhes finos do logo somem. Antes de publicar, vale conferir se ele precisa de uma versão simplificada.
- **Termos de uso e Política de privacidade:** o texto final, antes do primeiro deploy de produção (`docs/security-lgpd.md`).
- **Landing page:** não está no plano da Fase 1. Quando entrar, estende este design system.
