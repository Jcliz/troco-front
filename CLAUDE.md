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

### Design

Siga o `DESIGN.md`: tokens e paletas dos temas, componentes, movimento e o desenho de cada tela da Fase 1. Use os componentes do shadcn/ui ligados às variáveis de lá, e nunca cor fixa. A seção "Proibido" vem antes de qualquer skill de design. Se a tela pedir algo que o arquivo não cobre, pergunte antes de inventar.

O protótipo aprovado está versionado em `docs/design/prototype/` (veja o `LEIA-ME.md` de lá): o HTML navegável, com as animações, e os prints de cada tela em 1440 e 360 px. Antes de codar uma tela, abra os prints dela; para ver um movimento, abra o HTML com o MCP do Playwright e interaja. Em conflito, o `DESIGN.md` vence o protótipo.

Em toda tarefa de tela, antes do `reviewer`, faça a crítica com as skills **`apple-design`** e **`emil-design-eng`** e corrija o que elas apontarem, sempre dentro do `DESIGN.md`. Em tela com lista ou valores, rode também **`break-ui`** (nomes longos, valores enormes, lista vazia).

### Qual fluxo usar

Vários fluxos instalados se sobrepõem. Use este:

| Situação | Use | Não use |
|---|---|---|
| Tarefa do plano (`FE-xx`) | `implement-task`: o plano e o `DESIGN.md` já são a especificação | `brainstorming`, `writing-plans`, `executing-plans` e `subagent-driven-development` do superpowers; nada de `docs/superpowers/` nem `.specs/` |
| Funcionalidade fora do plano (ex.: Fase 2), só quando o João pedir | `tlc-spec-driven`; o resultado vira tarefa em `docs/plans/` | |
| Decisão ou plano grande para testar | `/grill-me` | |
| Teste antes do código, bug, conferir antes de dizer que terminou, responder a revisão | `test-driven-development`, `systematic-debugging`, `verification-before-completion`, `receiving-code-review` (superpowers) | `using-git-worktrees` e `finishing-a-development-branch`: a branch e o PR seguem `rules/git.md` |
| Movimento | `animate` e `choreograph` para implementar, `review-animations` para revisar, `animation-performance` se travar | |
| Aviso flutuante (toast) | `ask-sonner` | |
| O João corrigiu algo de design | `/learn-taste`, para virar regra no `DESIGN.md` | |

### Estrutura da pasta `.claude/`

| Caminho | Para quê |
|---|---|
| `settings.json` | Permissões (comandos liberados, arquivos bloqueados) e hooks |
| `hooks/format.sh` | Formata com Prettier cada arquivo editado |
| `hooks/guard-git.sh` | Barra commit com assinatura de agente e branch com prefixo de ferramenta |
| `hooks/check-before-stop.sh` | Roda lint e typecheck antes do Claude encerrar, se ele mudou código |
| `rules/git.md` | Nome de branch limpo, autoria só do João (sem coautoria de agente), commits e PRs (vale sempre) |
| `rules/*.md` | Regras carregadas conforme o caminho (componentes, i18n, dados, testes) |
| `agents/reviewer.md` | Revisa o diff contra ADRs, PRD, convenções e acessibilidade |
| `agents/test-writer.md` | Escreve testes de componente e de ponta a ponta |
| `skills/implement-task/` | Passo a passo de uma tarefa do plano até o PR |
| `skills/new-screen/` | Como criar uma tela no padrão do projeto |
| `skills/sync-api/` | Como atualizar os tipos a partir do `openapi.json` da API |
| `third-party.md` | Skills de terceiros em `skills/`, plugins habilitados no `settings.json` e MCP do Playwright em `.mcp.json`, com origem e commit auditado |

### Aprendizados da revisão

Regras que saíram das revisões do João. Quando ele corrigir algo que pode se repetir, acrescente aqui uma linha no mesmo PR da correção: a regra, o porquê e o número do PR. Se for de design, leve para o `DESIGN.md` com `/learn-taste`. Se a lista crescer, mova para `.claude/rules/`.

_Nenhuma ainda._

### Lembretes

- Ao terminar uma tarefa, marque-a como feita no plano (`docs/plans/phase-1.md`) no mesmo PR.
- Refatoração fora do escopo vira tarefa separada (anote no PR).
- Ponto não decidido vira "Pontos em aberto" no doc correspondente.
