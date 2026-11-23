# ADR-0003: API em NestJS + Prisma + PostgreSQL

- **Status:** Aceito
- **Data:** 2026-11-23

## Contexto

Decidido no PRD (seção 11). Aqui ficam os detalhes de uso.

## Decisão

- **Node 24 LTS**, **pnpm**, TypeScript em modo `strict`.
- **NestJS** organizado por módulos de domínio (ver [architecture.md](../architecture.md)).
- **Prisma** como ORM e ferramenta de migração. Migrações versionadas em `prisma/migrations`, sempre criadas com `prisma migrate dev` e aplicadas em produção com `prisma migrate deploy`.
- **PostgreSQL 17**, local no Docker e no Neon em preview/produção.
- Validação de entrada com `class-validator` nos DTOs; variáveis de ambiente validadas com `zod` na inicialização.
- Regras que o banco consegue garantir (unicidade, chaves estrangeiras, "só um mês aberto por conta") ficam no banco, além do código.

## Consequências

- O schema Prisma é a fonte da verdade do modelo de dados; [data-model.md](../data-model.md) explica o porquê de cada tabela.
- Restrições que o Prisma não expressa (índice único parcial, `CHECK`) entram em SQL dentro da migração.
