# ADR-0015: Sentry e logs estruturados

- **Status:** Aceito
- **Data:** 2026-11-23

## Decisão

- **Sentry** (plano gratuito) no front e na API a partir do primeiro deploy, sem enviar dados pessoais (`sendDefaultPii: false`, sem corpo de requisição).
- Logs da API em JSON com **pino** (`nestjs-pino`), com `requestId`. Nunca logar senha, token, e-mail completo ou valores de lançamentos.

## Consequências

- Os logs ficam no painel da Vercel; o Sentry avisa por e-mail quando surge erro novo.
