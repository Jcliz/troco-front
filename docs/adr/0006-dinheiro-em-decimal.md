# ADR-0006: Dinheiro em `Decimal`, trafegado como string

- **Status:** Aceito
- **Data:** 2026-11-23

## Contexto

RNF-06 proíbe ponto flutuante. Haverá moedas com casas decimais diferentes (CLP sem centavos) e cotações (Fase 3).

## Decisão

- Valores monetários: coluna `Decimal(18, 2)`. Cotações: `Decimal(18, 8)`. Percentuais: `Decimal(7, 4)` (ex.: `0.1000` = 10%).
- No código, sempre `Prisma.Decimal` (decimal.js). Nunca `number` para dinheiro. Arredondamento: meio para cima (`ROUND_HALF_UP`) com 2 casas, só no fim de cada cálculo.
- Na API (JSON), valores trafegam como **string** com ponto decimal: `"1234.56"`. Percentuais também como string: `"0.1000"`.
- Todo valor vem acompanhado da moeda (`currency`, ISO 4217) quando sai da API.
- No front, formatação com `Intl.NumberFormat`; conta de soma, se precisar, com uma biblioteca decimal, nunca com `number`.

## Consequências

- Um utilitário `money` em cada repo concentra parse, soma e formatação.
- Teste obrigatório: o exemplo da seção 8 do PRD (margem de R$ 1.900,00) bate centavo a centavo.
