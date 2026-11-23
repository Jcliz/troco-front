# ADR-0008: Datas de calendário sem hora; fuso horário do usuário

- **Status:** Aceito
- **Data:** 2026-11-23

## Contexto

Lançamentos e viradas são datas de calendário ("o salário caiu dia 5"), não instantes.

## Decisão

- Datas de negócio (data do lançamento, início do mês, data prevista de sazonal) são coluna `date` e trafegam como `"AAAA-MM-DD"`.
- Instantes técnicos (criação, sessão, tokens) são `timestamptz` em UTC e trafegam em ISO 8601 com `Z`.
- O usuário tem `timezone` (padrão `America/Sao_Paulo`). "Hoje" é sempre calculado no fuso dele, na API.
- Biblioteca: `date-fns` + `@date-fns/tz` nos dois repos. Nunca `new Date("AAAA-MM-DD")` para datas de negócio (vira meia-noite UTC e muda de dia no Brasil).

## Consequências

- Um utilitário `calendar-date` em cada repo concentra conversões.
