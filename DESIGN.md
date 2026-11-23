# DESIGN.md: troco

O restante do design system ainda vai ser feito na fase de design. Por enquanto, este arquivo registra a marca.

## Marca: logo e temas

O logo é um porquinho-cofre em desenho 2D plano, feito com a skill `ip-as-logo`. Ele tem olhos ovais verticais, uma sombra sutil em degradê nas pernas e uma luz leve vinda de cima à esquerda. O desenho é sempre o mesmo, e cada tema muda só as três cores: fundo, corpo e detalhes (focinho, orelhas internas e olhos).

Os arquivos ficam em `public/brand/`, em PNG de 1024 × 1024. Cada tema da configuração da aplicação usa o logo e a paleta correspondentes.

### Temas escuro e claro

| Tema | Arquivo | Fundo | Corpo | Detalhes | Esquema |
|---|---|---|---|---|---|
| Escuro · Máximo | `logo-dark-max.png` | `#000000` | `#FFFFFF` | `#5C5C5C` | Neutros. O branco também é a cor das fontes. |
| Escuro · Meia-noite | `logo-dark-midnight.png` | `#0F1429` | `#FFFFFF` | `#5C5C5C` | Igual ao Máximo, com azul meia-noite (228°) no lugar do preto |
| Claro · Máximo | `logo-light-max.png` | `#FFFFFF` | `#EDA96E` | `#1C254A` | Damasco (28°) × azul meia-noite (228°), complementar |
| Claro · Fim de tarde | `logo-light-sunset.png` | `#F4E5C7` | `#EDA96E` | `#1C254A` | Fundo dourado (40°), vizinho do damasco; detalhes complementares |

O "Máximo" de cada modo usa obrigatoriamente preto puro (escuro) ou branco puro (claro).

### Paletas extras

| Paleta | Arquivo | Fundo | Corpo | Detalhes | Esquema |
|---|---|---|---|---|---|
| Azul | `logo-blue.png` | `#1A293C` | `#B3C6DB` | `#2D466B` | Monocromática (210° a 220°) |
| Outono · tijolo | `logo-autumn-brick.png` | `#9F4740` | `#F3E1C8` | `#EF9C44` | Análoga (4° a 35°) |
| Outono · creme | `logo-autumn-cream.png` | `#F3E1C8` | `#EF9C44` | `#9F4740` | Análoga, cores invertidas |
| Verde-água | `logo-sea-green.png` | `#19342B` | `#A9D1C3` | `#29604E` | Monocromática (160°) |
| Água e índigo | `logo-water-indigo.png` | `#231E3E` | `#A2CED7` | `#2A416F` | Análoga fria (190°, 220° e 250°) |
| Sálvia × vinho | `logo-sage-wine.png` | `#3C2032` | `#9FC6AC` | `#325D40` | Complementar (140° × 320°) |

## Pontos em aberto

- Como os temas entram na configuração da aplicação (nomes, padrão, onde fica a escolha do usuário). Isso vira tarefa própria.
- Favicon: em 16 px os detalhes finos somem. Antes de publicar, vale conferir se precisa de uma versão simplificada.
