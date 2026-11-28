# Ambientes, CI e deploy

## Ambientes

| Ambiente | Front | API | Banco | E-mail |
|---|---|---|---|---|
| **Local** | `pnpm dev` em `localhost:3000` | `pnpm start:dev` em `localhost:4000` | Postgres 17 no Docker | Mailpit no Docker (`localhost:8025`) |
| **Preview** | Deploy automático da Vercel por PR | Deploy automático da Vercel por PR | Branch do Neon por PR (integração Neon + Vercel) | Mailpit não existe aqui: `MAIL_DRIVER=log` (só registra) |
| **Produção** | `main` → Vercel | `main` → Vercel | Branch principal do Neon | Gmail (SMTP) |

O `docker-compose.yml` fica no `troco-api` e sobe Postgres e Mailpit. O front local aponta `API_URL=http://localhost:4000`.

## Preparar a máquina de desenvolvimento

Uma vez por computador, antes da primeira tarefa:

1. **Node 24 LTS** (a versão do `.nvmrc`) e **pnpm** (`corepack enable`).
2. **Docker** (Docker Desktop no Windows e no macOS), para o Postgres 17 e o Mailpit.
3. **Git** com a identidade do João (`git config --global user.name` e `user.email`). No Windows, o Git for Windows traz o Git Bash, que o Claude Code usa para rodar comandos e os hooks de `.claude/hooks/`.
4. Os dois repositórios clonados lado a lado na mesma pasta (`troco-api/` e `troco-front/`): o `pnpm api:sync` do front lê `../troco-api/openapi.json` quando existe.
5. **Claude Code** aberto na pasta de cada repo. Na primeira vez ele pergunta se instala os plugins do `settings.json` (veja `.claude/third-party.md`); aceite. O MCP do Playwright do front roda com `npx`.

Para conferir: `node -v` mostra `v24`, `docker compose version` responde e `pnpm -v` responde.

### No Windows (a máquina de desenvolvimento do João)

- **Git for Windows** é obrigatório: o Claude Code usa o Git Bash dele para rodar comandos e os hooks (`.sh`) de `.claude/hooks/`. Se o Claude Code não achar o Git Bash, aponte `CLAUDE_CODE_GIT_BASH_PATH` para o `bash.exe` (ex.: `C:\Program Files\Git\bin\bash.exe`).
- **Node** precisa estar no `PATH` do Git Bash: os hooks usam `node` para ler a entrada do Claude Code.
- **Docker Desktop** com o WSL 2 ligado.
- Fim de linha: o `.gitattributes` já força `LF`; não mude o `core.autocrlf` por repositório.
- **Assinatura do Claude:** o `settings.json` de cada repo já desliga o `Co-Authored-By`. Para valer em qualquer pasta, ponha o mesmo em `%USERPROFILE%\.claude\settings.json`: `{ "attribution": { "commit": "", "pr": "" }, "includeCoAuthoredBy": false }`.
- **Conferir os hooks uma vez:** peça ao Claude Code, na pasta do repo, para rodar `echo '{"tool_input":{"command":"git switch -c claude/teste"}}' | .claude/hooks/guard-git.sh; echo $?`. Tem que aparecer a mensagem de bloqueio e `2`. Se der erro de caminho, avise antes de começar as tarefas.

## Rodar o sistema inteiro

```bash
# troco-api
docker compose up -d          # Postgres e Mailpit
pnpm install
pnpm prisma migrate dev
pnpm db:seed                  # opcional: usuário de demonstração (API-14)
pnpm start:dev                # http://localhost:4000

# troco-front, em outro terminal
pnpm install
pnpm api:sync
pnpm dev                      # http://localhost:3000
```

E-mails do local aparecem no Mailpit (`localhost:8025`). Os testes de ponta a ponta do front (`pnpm test:e2e`) precisam dos dois rodando.

## Variáveis de ambiente

### troco-api

| Variável | Exemplo | Uso |
|---|---|---|
| `NODE_ENV` | `development` | |
| `PORT` | `4000` | só local |
| `DATABASE_URL` | `postgresql://troco:troco@localhost:5432/troco` | conexão (com pooling no Neon) |
| `DIRECT_URL` | igual ao acima no local | migrações |
| `APP_URL` | `http://localhost:3000` | links nos e-mails, CORS, checagem de `Origin` |
| `SESSION_TTL_DAYS` | `30` | |
| `MAIL_DRIVER` | `smtp` \| `log` \| `resend` | [ADR-0012](adr/0012-email-com-interface-unica.md) |
| `MAIL_FROM` | `troco <troco.app@gmail.com>` | remetente |
| `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER`, `SMTP_PASS` | `smtp.gmail.com`, `465`, ... | senha de app do Gmail |
| `SENTRY_DSN` | | vazio no local |
| `CRON_SECRET` | | Fase 2+ |
| `DEMO_USER_PASSWORD` | | senha do usuário de demonstração do `pnpm db:seed` (API-14); só local e preview |

### troco-front

| Variável | Exemplo | Uso |
|---|---|---|
| `API_URL` | `http://localhost:4000` | destino do rewrite `/api/*` (só no servidor) |
| `NEXT_PUBLIC_SENTRY_DSN` | | |

Cada repo mantém um `.env.example` atualizado. Arquivos `.env*` (menos o exemplo) nunca vão para o Git.

## CI (GitHub Actions)

`.github/workflows/ci.yml` em cada repo, em PRs e pushes na `main`:

- **API:** pnpm install → lint → typecheck → testes unitários → testes de integração (Postgres como *service container*) → `prisma migrate diff` (migrações em dia com o schema) → `openapi:check` → build.
- **Front:** pnpm install → lint → typecheck → testes → build. Playwright entra quando existirem as telas principais.
- **Regras do PR (os dois repos):** job `pr-rules`, que roda desde já, sem `package.json`. Confere o nome da branch, o título do PR em Conventional Commits e que nenhum commit ou corpo de PR tem assinatura de agente (`Co-Authored-By`, `Claude-Session`, "Generated with Claude Code"), conforme `.claude/rules/git.md`.

Até a tarefa de scaffolding da Fase 1, os passos são pulados porque não há `package.json`.

## Primeiro deploy (passo a passo para o João)

Feito na tarefa OPS-01 da Fase 1. O Claude prepara o código; as contas são suas.

1. **Gmail dedicado:** crie uma conta (ex.: troco.app@gmail.com), ative a verificação em duas etapas e gere uma **senha de app** (Conta Google → Segurança → Senhas de app). Guarde a senha.
2. **Neon:** crie conta e um projeto `troco` na região mais próxima (São Paulo, se houver; senão, us-east-1). Copie a URL com pooling e a URL direta.
3. **Vercel:** entre com o GitHub e importe `troco-api` e `troco-front` como dois projetos. No projeto da API, instale a integração do Neon (cria branches de preview sozinha).
4. **Variáveis:** preencha as variáveis das tabelas acima nos dois projetos (Production e Preview).
5. **Sentry:** crie conta e dois projetos (Next.js e Node). Copie os DSNs para as variáveis.
6. **GitHub:** em cada repo, Settings → Branches → regra para `main`: exigir PR, exigir os checks `ci` e `pr-rules` e bloquear push direto.
7. Avise o Claude com os nomes finais dos domínios `*.vercel.app` para ajustar `APP_URL` e `API_URL`.

## Pontos em aberto

- Domínio próprio (PRD, seção 13, ponto 9): trocar `APP_URL`, `API_URL`, `MAIL_DRIVER=resend` e verificar o domínio no Resend.
