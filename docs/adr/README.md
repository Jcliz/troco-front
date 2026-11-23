# ADRs (Architecture Decision Records)

Cada decisão técnica importante tem um arquivo curto: contexto, decisão e consequências. Use [0000-template.md](0000-template.md).

| # | Decisão | Status |
|---|---|---|
| [0001](0001-registrar-decisoes-em-adrs.md) | Registrar decisões em ADRs | Aceito |
| [0002](0002-dois-repositorios.md) | Dois repositórios: front e API | Aceito |
| [0003](0003-nestjs-prisma-postgres.md) | API em NestJS + Prisma + PostgreSQL | Aceito |
| [0004](0004-hospedagem-vercel-neon.md) | Hospedagem v1: Vercel + Neon, domínio `*.vercel.app` | Aceito |
| [0005](0005-autenticacao-sessao-em-cookie.md) | Autenticação por sessão opaca em cookie, com proxy no front | Aceito |
| [0006](0006-dinheiro-em-decimal.md) | Dinheiro em `Decimal`, trafegado como string | Aceito |
| [0007](0007-mes-financeiro-por-periodos.md) | Mês financeiro como tabela de períodos, cálculo derivado | Aceito |
| [0008](0008-datas-e-fuso-horario.md) | Datas de calendário sem hora; fuso do usuário | Aceito |
| [0009](0009-contrato-rest-openapi.md) | REST + OpenAPI gerado pela API; erros em problem+json | Aceito |
| [0010](0010-front-nextjs-app-router.md) | Front: Next.js App Router, TanStack Query, next-intl | Aceito |
| [0011](0011-ledger-como-dono-dos-dados.md) | Todos os dados pertencem a um `Ledger` (conta individual ou conjunta) | Aceito |
| [0012](0012-email-com-interface-unica.md) | E-mail por interface única: Gmail agora, Resend depois | Aceito |
| [0013](0013-testes-e-ci.md) | Vitest, banco real nos testes de integração, Playwright, GitHub Actions | Aceito |
| [0014](0014-tarefas-agendadas.md) | Tarefas agendadas por Vercel Cron diário + endpoint protegido | Aceito |
| [0015](0015-observabilidade.md) | Sentry e logs estruturados (pino) | Aceito |
| [0016](0016-ids-uuid-v7.md) | IDs UUID v7 | Aceito |
