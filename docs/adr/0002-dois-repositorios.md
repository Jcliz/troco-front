# ADR-0002: Dois repositórios, front e API

- **Status:** Aceito
- **Data:** 2026-11-23

## Contexto

O projeto já tem `troco-front` e `troco-api` (PRD, seção 11). Um monorepo facilitaria tipos compartilhados, mas os repositórios já existem e têm deploys independentes na Vercel.

## Decisão

Manter dois repositórios. O contrato entre eles é o arquivo OpenAPI gerado pela API ([ADR-0009](0009-contrato-rest-openapi.md)). A pasta `docs/` é idêntica nos dois.

## Consequências

- Uma funcionalidade de ponta a ponta normalmente gera dois PRs: primeiro a API, depois o front.
- O front nunca define tipos de dados da API à mão: eles vêm do OpenAPI.
- Mudanças em `docs/` precisam ser replicadas no outro repo.
