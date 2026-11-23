# ADR-0011: Todos os dados pertencem a um `Ledger`

- **Status:** Aceito
- **Data:** 2026-11-23

## Contexto

PRD 7.15: além da conta individual, haverá conta conjunta com margem, orçamentos e lançamentos próprios (Fase 3). Fazer o modelo pensando só no usuário obrigaria uma migração grande depois.

## Decisão

- A entidade `Ledger` ("conta" na interface) é dona de todos os dados financeiros. Tem `type`: `PERSONAL` ou `JOINT`.
- `LedgerMember` liga usuários a contas com papel `OWNER` ou `MEMBER`.
- No cadastro, cada usuário ganha um ledger `PERSONAL` do qual é `OWNER`. Na Fase 1 é o único.
- Toda rota financeira tem `ledgerId` e o `LedgerAccessGuard` confere a participação. Toda consulta filtra por `ledger_id`.
- Membros de uma conta conjunta nunca acessam o ledger pessoal de outro membro (RF-146): a regra sai naturalmente do guard.

## Consequências

- Na Fase 3, a conta conjunta reaproveita todos os módulos. O que é novo: convites, divisão de gastos e o reflexo da parte de cada um no ledger pessoal (RF-152).
