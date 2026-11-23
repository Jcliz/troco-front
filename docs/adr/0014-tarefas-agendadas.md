# ADR-0014: Tarefas agendadas por Vercel Cron diário

- **Status:** Aceito
- **Data:** 2026-11-23

## Contexto

O plano Hobby da Vercel permite cron uma vez por dia. A virada do mês é manual (PRD 7.8.1), então não depende de cron.

## Decisão

- Na **Fase 1 não há cron**: os lembretes (revisão das fixas pendente há 3 dias, mês aberto há mais de 35 dias) são calculados na leitura e aparecem no dashboard.
- A partir da Fase 2/3 (e-mail e push), um cron diário chama `POST /v1/internal/cron/daily` com `Authorization: Bearer ${CRON_SECRET}`. O endpoint é idempotente (registra o que já enviou).

## Consequências

- Lembretes por e-mail chegam com até um dia de atraso, aceitável para a v1.
