# ADR-0009: REST + OpenAPI gerado pela API; erros em problem+json

- **Status:** Aceito
- **Data:** 2026-11-23

## Contexto

Dois repositórios ([ADR-0002](0002-dois-repositorios.md)) precisam de um contrato que não fique desatualizado.

## Decisão

- REST com JSON, prefixo `/v1`. Recursos da conta ficam sob `/v1/ledgers/{ledgerId}/...`.
- O OpenAPI 3.1 é **gerado do código** com `@nestjs/swagger` e salvo em `openapi.json` na raiz do `troco-api` por um script (`pnpm openapi:generate`). O CI falha se o arquivo commitado estiver diferente do gerado.
- O front gera tipos com `openapi-typescript` a partir desse arquivo e usa `openapi-fetch` como cliente.
- Erros no formato RFC 9457 (`application/problem+json`) com campos `type`, `title`, `status`, `detail`, `code` (código estável, ex.: `PERIOD_ALREADY_OPEN`) e `errors` (lista de campos inválidos).
- Paginação por cursor (`?cursor=&limit=`), resposta `{ "items": [...], "nextCursor": "..." }`.
- Detalhes e lista de endpoints: [api-contracts.md](../api-contracts.md).

## Consequências

- O front sincroniza o contrato copiando o `openapi.json` da API (`pnpm api:sync`), e o PR do front que depende de um endpoint novo vem depois do PR da API.
