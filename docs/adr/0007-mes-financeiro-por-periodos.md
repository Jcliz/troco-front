# ADR-0007: Mês financeiro como tabela de períodos, com cálculo derivado

- **Status:** Aceito
- **Data:** 2026-11-23

## Contexto

PRD 7.8.1: o mês começa no dia em que o salário cai e só vira quando o usuário clica em "Virar o mês". Lançamentos podem ser editados em meses fechados, e os meses seguintes precisam ser recalculados (RF-79e).

## Decisão

- Tabela `periods`: `start_date` (dia do salário) e `end_date` (véspera da próxima virada; `null` no mês aberto). Só um período aberto por conta, garantido por índice único parcial.
- Um lançamento **não guarda o período**. Ele pertence ao período cujo intervalo contém sua `date`. Corrigir a data de início do mês (RF-79d) não exige mexer em lançamentos.
- **Nada calculado é salvo** (margem, sobra, saldo remanescente, compensação). O motor de cálculo refaz a cadeia de meses a partir do primeiro período. Só o que o usuário informa é salvo: `invested_amount` do fechamento e a data da virada.
- A virada é uma transação: fecha o período atual (`end_date` = véspera da data do salário), cria o novo e gera as fixas "a confirmar". É idempotente por `(ledger_id, start_date)`.
- Lançamento com data anterior ao primeiro período é rejeitado; com data futura (depois de hoje) é aceito e cai no mês aberto.

## Consequências

- Recalcular é barato (12 períodos por ano). Se um dia ficar lento, cria-se um cache invalidável, sem mudar o modelo.
- Desfazer a virada (RF-79d) = apagar o período novo vazio e reabrir o anterior.
