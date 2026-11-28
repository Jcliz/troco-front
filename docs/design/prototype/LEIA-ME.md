# Protótipo da Fase 1

Protótipo navegável que o João aprovou, na versão 42 (28/11/2026). É a referência visual das telas; a regra é o [`DESIGN.md`](../../../DESIGN.md), que vence o protótipo quando os dois discordam.

## O que tem aqui

| Arquivo | Para quê |
|---|---|
| `troco-prototipo.html` | O protótipo inteiro num arquivo só, com CSS, JS, imagens e **todas as animações**. Abra no navegador. |
| `screens/desktop-1440/` e `screens/celular-360/` | Print de cada tela no tema Fim de tarde (o padrão), com a tela inteira. Servem para comparar o visual parado. |
| `screens.js` | Script que gera os prints de novo (`node docs/design/prototype/screens.js "$PWD/docs/design/prototype/troco-prototipo.html" docs/design/prototype/screens`, com o Playwright instalado). |

## Como navegar

Cada tela tem um endereço depois do `#`: `#login`, `#cadastro`, `#recuperar`, `#redefinir`, `#redefinir/expirado`, `#primeiro-acesso`, `#termos`, `#privacidade`, `#painel`, `#lancamentos`, `#mes/fixas`, `#mes/rendas`, `#mes/sazonais`, `#mes/reserva` e `#configuracoes/<fixas|categorias|reserva|tema|perfil|dados>`. O tema escolhido em Configurações › Tema fica guardado no navegador.

## Como ver as animações

Os prints são parados. Para ver um movimento (menu recolhendo, modal da virada em etapas, linha confirmada saindo, troca de tema), abra o `troco-prototipo.html` com o MCP do Playwright (`.mcp.json`), interaja com a tela e observe. As durações e curvas que valem estão na seção "Movimento" do `DESIGN.md`; o protótipo mostra como elas ficam juntas. Com o movimento reduzido do sistema ligado, o protótipo deixa só a opacidade, como o `DESIGN.md` pede.

## O que não é Fase 1

A versão 42 já traz o desenho da Fase 2: Parcelamentos no menu e a aba `#parcelamentos`, "Comprei parcelado" e a compra com resgate no novo lançamento, e o destino "Mais" no celular. Na Fase 1, o menu não tem Parcelamentos e o quarto destino do celular é "Ajustes", que abre Configurações direto (`DESIGN.md`, "Layout do app").

As fontes do protótipo (partes de CSS e JS e os scripts que montam cada versão) ficam na pasta do projeto `prototipo-fase1/`, fora do repositório. Quando o protótipo mudar, substitua o HTML daqui pela versão nova e gere os prints de novo.
