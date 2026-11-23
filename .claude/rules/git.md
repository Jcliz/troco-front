# Git: branches, commits e PRs

Vale para todo trabalho neste repositório, inclusive quando o ambiente (sessão na nuvem, ferramenta ou bot) sugerir outro nome de branch.

## Nome de branch

O nome tem que ser **limpo e compreensível**: quem lê sabe o que a branch faz sem abrir o PR.

Formato: `<tipo>/<resumo-curto-em-inglês>`, ou `<tipo>/<id-da-tarefa>-<resumo>` quando houver tarefa do plano.

- `tipo`: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`.
- Resumo em inglês, minúsculas, palavras separadas por hífen, de 2 a 5 palavras.
- Sem prefixos de ferramenta (`claude/`, `codex/`, `copilot/`), sem hashes ou sufixos aleatórios (`-gmvczh`, `-a1b2c3`), sem nomes de sessão, datas ou nomes de pessoas.

| Bom | Ruim |
|---|---|
| `feat/api-07-month-turnover` | `claude/project-thread-gmvczh` |
| `fix/login-rate-limit` | `fix-stuff` |
| `docs/technical-documentation` | `branch-joao-23-11` |
| `chore/ci-postgres-cache` | `feat/a8f3e21` |

Se o ambiente já criou uma branch com nome genérico, crie uma branch com nome limpo a partir dela e abra o PR por essa.

## Autoria

- O autor de **todo** commit é o João (`Jcliz`), com a identidade dele no Git. Nenhum agente aparece como autor ou coautor.
- Proibido incluir `Co-Authored-By`, `Claude-Session`, "Generated with Claude Code" ou qualquer assinatura de agente em commits, PRs, comentários ou código.
- Se o ambiente não tiver a identidade do João configurada, use a mesma do commit inicial do repositório (`git log --reverse --format="%an <%ae>" | head -1`) com `git -c user.name=... -c user.email=... commit`.

## Commits e PRs

- Conventional Commits em inglês: `feat(periods): add month turnover endpoint`.
- O título do PR segue o mesmo padrão (vira a mensagem do squash merge).
- Detalhes em `docs/conventions.md`.
