# DESIGN.md: troco

O restante do design system ainda vai ser feito na fase de design. Por enquanto, este arquivo registra a marca.

## Marca: logo e temas

O logo é um porquinho-cofre em desenho 2D plano, feito com a skill `ip-as-logo`. Ele tem olhos ovais verticais, uma sombra sutil em degradê nas pernas e uma luz leve vinda de cima à esquerda. O desenho é sempre o mesmo, e cada tema muda só as três cores: fundo, corpo e detalhes (focinho, orelhas internas e olhos).

Os arquivos ficam em `public/brand/`, em PNG de 1024 × 1024. Cada tema da configuração da aplicação usa o logo e a paleta correspondentes.

### Temas escuro e claro

| Tema | Arquivo | Fundo | Corpo | Detalhes | Esquema |
|---|---|---|---|---|---|
| Escuro | `logo-dark.png` | `#000000` | `#FFFFFF` | `#5C5C5C` | Neutros. O branco também é a cor das fontes. |
| Meia-noite | `logo-dark-midnight.png` | `#070B1B` | `#FFFFFF` | `#1F2951` | Monocromática azul (228°): fundo meia-noite escuro, detalhes num azul mais claro que o fundo, corpo branco |
| Claro | `logo-light.png` | `#FFFFFF` | `#EDA96E` | `#000000` | Damasco (28°) com preto puro nos detalhes; branco e preto são neutros |
| Fim de tarde | `logo-light-sunset.png` | `#F4E5C7` | `#EDA96E` | `#161616` | Análoga quente: fundo dourado (40°) vizinho do damasco (28°); detalhes em preto carbono |

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

## Pontos em aberto

- Como os temas entram na configuração da aplicação (nomes, padrão, onde fica a escolha do usuário). Isso vira tarefa própria.
- Favicon: em 16 px os detalhes finos somem. Antes de publicar, vale conferir se precisa de uma versão simplificada.
