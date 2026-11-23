# Arquitetura

## Visão geral

```
 Navegador (PWA)
      │  HTTPS, mesmo domínio
      ▼
 troco-front (Next.js na Vercel)
      │  /api/* → rewrite (proxy) para a API, repassando o cookie de sessão
      ▼
 troco-api (NestJS na Vercel, função serverless)
      │  Prisma
      ▼
 PostgreSQL (Neon)

 troco-api também fala com: SMTP do Gmail (e-mail, depois Resend), Sentry (erros),
 API de cotação (Fase 3). A Vercel Cron chama a API uma vez por dia (Fase 2+).
```

- **troco-front** só cuida de interface. Não tem regra de negócio nem acesso ao banco.
- **troco-api** é dona de toda regra de negócio, cálculo e persistência.
- O front chama a API sempre por `/api/...` no próprio domínio do front. O Next.js reescreve para a URL da API. Assim o cookie de sessão é *first-party* (ver [ADR-0005](adr/0005-autenticacao-sessao-em-cookie.md)), o que importa porque `*.vercel.app` é um sufixo público e front e API em subdomínios diferentes seriam "sites" diferentes para o navegador.
- O contrato entre os dois é o OpenAPI gerado pela API ([ADR-0009](adr/0009-contrato-rest-openapi.md)).

## Módulos da API

Organização por domínio (um módulo NestJS por pasta em `src/modules/`), cada um com `controller → service → repository (Prisma)`:

| Módulo | Responsabilidade | Fase |
|---|---|---|
| `auth` | Cadastro, login, logout, sessões, recuperação de senha, limite de tentativas | 1 |
| `users` | Perfil, preferências, exportação e exclusão (LGPD) | 1 |
| `ledgers` | Conta individual (e conjunta na Fase 3), meta de reserva, moeda | 1 |
| `periods` | Mês financeiro: primeiro mês, virada, desfazer virada, fechamento | 1 |
| `entries` | Lançamentos de renda e gasto, filtros | 1 |
| `recurring` | Fixas (despesas e rendas), geração "a confirmar", revisão | 1 |
| `categories` | Categorias e subcategorias, padrões | 1 |
| `seasonal` | Gastos sazonais planejados | 1 (provisão na 2) |
| `calculation` | Motor de cálculo puro (sem I/O): margem, reserva, sobra, encadeamento de meses | 1 |
| `summary` | Monta os dados do dashboard usando `calculation` | 1 |
| `mail` | Interface de envio de e-mail e templates | 1 |
| `payment-methods`, `cards`, `invoices` | Formas de pagamento, cartões, faturas | 2 |
| `installments` | Parcelamentos | 2 |
| `subscriptions` | Assinaturas e verificação de uso | 2 |
| `budgets`, `insights`, `alerts` | Orçamento por categoria, insights por regras, alertas | 2 |
| `joint`, `currency`, `notifications`, `admin` | Conta conjunta, multimoeda, e-mail/push, dashboard de admin | 3 |

Pastas transversais: `src/common/` (filtros de erro, pipes, decorators, guards), `src/config/` (validação das variáveis de ambiente), `src/prisma/` (PrismaService).

Regra de dependência: `calculation` não importa nada de Prisma nem de NestJS. Ele recebe dados prontos e devolve números. Isso deixa as regras da seção 8 testáveis isoladamente.

## Estrutura do front

Next.js com App Router ([ADR-0010](adr/0010-front-nextjs-app-router.md)):

```
src/
  app/
    [locale]/
      (auth)/login, cadastro, recuperar-senha
      (app)/dashboard, lancamentos, mes (cadastro rápido e virada), configuracoes
  components/ui/        ← componentes do shadcn (gerados, pouco editados)
  components/           ← componentes do troco
  features/<dominio>/   ← hooks, formulários e componentes de cada domínio
  lib/api/              ← cliente gerado do OpenAPI (openapi-fetch) e tipos
  lib/                  ← utilitários (dinheiro, datas)
  messages/pt-BR.json   ← textos (next-intl)
```

## Fluxo de uma requisição

1. O componente chama um hook de `features/` (TanStack Query) que usa o cliente tipado de `lib/api`.
2. O cliente chama `/api/v1/...` no domínio do front, com o cookie `troco_session`.
3. O Next.js reescreve para `${API_URL}/v1/...`.
4. Na API, o `SessionGuard` valida o cookie, carrega o usuário e confere se ele é membro do `ledgerId` da rota.
5. O controller valida a entrada (DTO com `class-validator`), chama o service, que usa Prisma e, quando precisa, o `calculation`.
6. Erros saem no formato `application/problem+json` ([ADR-0009](adr/0009-contrato-rest-openapi.md)).

## Pontos em aberto

- Cache do resumo do mês, caso o recálculo encadeado fique lento (só se medir problema).
- Arquitetura da v2 fora da Vercel (PRD, seção 13).
