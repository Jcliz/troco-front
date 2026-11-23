---
name: sync-api
description: Atualiza o contrato do troco-front a partir do openapi.json do troco-api e regenera os tipos. Use quando a API ganhar ou mudar endpoints.
---

# Sincronizar com a API

1. `pnpm api:sync` copia o `openapi.json` do troco-api (do `main` no GitHub, ou de `../troco-api/openapi.json` se existir localmente) para `src/lib/api/openapi.json` e roda `openapi-typescript` gerando `src/lib/api/schema.d.ts`.
2. Rode `pnpm typecheck`: erros mostram onde o front precisa se adaptar.
3. Commit dos dois arquivos gerados junto com as adaptações.
4. Nunca edite `schema.d.ts` à mão.
