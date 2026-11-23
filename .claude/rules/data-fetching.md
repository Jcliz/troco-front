---
paths:
  - "src/lib/api/**"
  - "src/features/**"
---

# Dados e API

- Tipos e cliente vêm do OpenAPI gerado em `src/lib/api` (`pnpm api:sync`). Não edite `schema.d.ts`.
- Toda chamada passa por `/api/v1/...` (proxy do Next). Nunca use a URL da API no navegador.
- Leitura com `useQuery`, escrita com `useMutation` em hooks de `src/features/<dominio>/api.ts`. Chaves de query centralizadas por domínio (`entryKeys.list(filters)`).
- Depois de uma mutação, invalide as queries afetadas. Atenção: lançamentos, fixas e virada mudam o `summary` do mês.
- Estados de carregamento, vazio e erro tratados em toda tela.
- Nenhum cálculo de negócio no cliente: se precisa de um número, peça à API.
- Formulários com react-hook-form + zod; o schema zod espelha a validação da API (mensagens em `messages/`).
