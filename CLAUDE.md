# CLAUDE.md: troco-front

@AGENTS.md

## Como trabalhar neste repo (Claude Code)

Você escreve praticamente todo o código; o João revisa os PRs. Ele lê em português.

### Fluxo de uma tarefa

Use a skill **`implement-task`** (`/implement-task FE-08`). Resumo:

1. Leia a tarefa em `docs/plans/phase-1.md`, a tela correspondente no PRD (seção 9) e o `DESIGN.md`.
2. Confira se os endpoints que a tela usa já existem no `openapi.json`. Se não, pare: a tarefa da API vem antes.
3. Ambiguidade de comportamento ou de visual → pergunte antes de codar. Não invente regra de negócio.
4. Crie a branch, rode `pnpm api:sync`, implemente com testes junto.
5. Rode `pnpm lint && pnpm typecheck && pnpm test && pnpm build` (e `pnpm test:e2e` se mexeu em fluxo coberto).
6. Rode o subagente **`reviewer`** e só então abra o PR, com prints da tela no celular e no desktop quando houver mudança visual.

### Enquanto o `DESIGN.md` estiver vazio

Use os componentes e o tema padrão do shadcn/ui, sem inventar paleta, tipografia ou ilustrações. Layout simples e consistente; o visual será aplicado depois da fase de design.

### Estrutura da pasta `.claude/`

| Caminho | Para quê |
|---|---|
| `settings.json` | Permissões (comandos liberados, arquivos bloqueados) e hooks |
| `hooks/format.sh` | Formata com Prettier cada arquivo editado |
| `rules/git.md` | Nome de branch limpo, autoria só do João (sem coautoria de agente), commits e PRs (vale sempre) |
| `rules/*.md` | Regras carregadas conforme o caminho (componentes, i18n, dados, testes) |
| `agents/reviewer.md` | Revisa o diff contra ADRs, PRD, convenções e acessibilidade |
| `agents/test-writer.md` | Escreve testes de componente e de ponta a ponta |
| `skills/implement-task/` | Passo a passo de uma tarefa do plano até o PR |
| `skills/new-screen/` | Como criar uma tela no padrão do projeto |
| `skills/sync-api/` | Como atualizar os tipos a partir do `openapi.json` da API |

### Lembretes

- Ao terminar uma tarefa, marque-a como feita no plano (`docs/plans/phase-1.md`) no mesmo PR.
- Refatoração fora do escopo vira tarefa separada (anote no PR).
- Ponto não decidido vira "Pontos em aberto" no doc correspondente.
