---
name: implement-task
description: Implementa uma tarefa do plano de fase do troco-front (ex. FE-08) do início ao PR, seguindo docs, ADRs, DESIGN.md e definição de pronto. Use quando pedirem para fazer uma tarefa do plano.
---

# Implementar uma tarefa do plano

Argumento: o ID da tarefa (ex.: `FE-08`).

1. **Entender**
   - Ache a tarefa em `docs/plans/phase-*.md` e confira as dependências ("Depende de"). Endpoint necessário ainda não está no `openapi.json` do troco-api? Pare e avise.
   - Leia a tela no PRD (seção 9), os RFs citados, o ADR-0010 e o `DESIGN.md`.
   - Ambiguidade → pergunte ao João antes de codar.
2. **Preparar**
   - `git switch main && git pull && git switch -c feat/<id-minúsculo>-<resumo-em-inglês>`.
   - `pnpm api:sync` (skill `sync-api`).
3. **Implementar**
   - Siga a skill `new-screen` para telas novas e as regras de `.claude/rules/`.
   - Textos em `messages/pt-BR.json`. Testes junto (subagente `test-writer` se ajudar).
   - Commits pequenos em Conventional Commits.
4. **Verificar**
   - `pnpm lint && pnpm typecheck && pnpm test && pnpm build`; `pnpm test:e2e` se mexeu em fluxo coberto.
   - Confira a tela em 360 px e em desktop.
   - Rode o subagente `reviewer` e corrija o que for "Bloqueia".
5. **Documentar**
   - Atualize `docs/` se algo mudou e marque a tarefa como feita no plano (`✅` no título). Mudou `docs/`? Anote no PR que precisa do PR irmão no troco-api.
6. **Abrir o PR**
   - Título em Conventional Commits. Corpo pelo template, em português, com prints no celular e no desktop.
