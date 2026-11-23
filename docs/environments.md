# Ambientes, CI e deploy

## Ambientes

| Ambiente | Front | API | Banco | E-mail |
|---|---|---|---|---|
| **Local** | `pnpm dev` em `localhost:3000` | `pnpm start:dev` em `localhost:4000` | Postgres 17 no Docker | Mailpit no Docker (`localhost:8025`) |
| **Preview** | Deploy automático da Vercel por PR | Deploy automático da Vercel por PR | Branch do Neon por PR (integração Neon + Vercel) | Mailpit não existe aqui: `MAIL_DRIVER=log` (só registra) |
| **Produção** | `main` → Vercel | `main` → Vercel | Branch principal do Neon | Gmail (SMTP) |

O `docker-compose.yml` fica no `troco-api` e sobe Postgres e Mailpit. O front local aponta `API_URL=http://localhost:4000`.

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

Até a tarefa de scaffolding da Fase 1, os passos são pulados porque não há `package.json`.

## Primeiro deploy (passo a passo para o João)

Feito na tarefa OPS-01 da Fase 1. O Claude prepara o código; as contas são suas.

1. **Gmail dedicado:** crie uma conta (ex.: troco.app@gmail.com), ative a verificação em duas etapas e gere uma **senha de app** (Conta Google → Segurança → Senhas de app). Guarde a senha.
2. **Neon:** crie conta e um projeto `troco` na região mais próxima (São Paulo, se houver; senão, us-east-1). Copie a URL com pooling e a URL direta.
3. **Vercel:** entre com o GitHub e importe `troco-api` e `troco-front` como dois projetos. No projeto da API, instale a integração do Neon (cria branches de preview sozinha).
4. **Variáveis:** preencha as variáveis das tabelas acima nos dois projetos (Production e Preview).
5. **Sentry:** crie conta e dois projetos (Next.js e Node). Copie os DSNs para as variáveis.
6. **GitHub:** em cada repo, Settings → Branches → regra para `main`: exigir PR, exigir o check `ci` e bloquear push direto.
7. Avise o Claude com os nomes finais dos domínios `*.vercel.app` para ajustar `APP_URL` e `API_URL`.

## Pontos em aberto

- Domínio próprio (PRD, seção 13, ponto 9): trocar `APP_URL`, `API_URL`, `MAIL_DRIVER=resend` e verificar o domínio no Resend.
