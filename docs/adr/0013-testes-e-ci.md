# ADR-0013: Testes com Vitest e banco real, Playwright e GitHub Actions

- **Status:** Aceito
- **Data:** 2026-11-23

## Contexto

Decisão da entrevista: testes unitários fortes no cálculo, integração com banco real e poucos testes de ponta a ponta.

## Decisão

- **Vitest** nos dois repos (na API, com `unplugin-swc` por causa dos decorators do NestJS).
- **API, unitários:** obrigatórios para `calculation` e para regras de domínio. Cada regra da seção 8 do PRD tem teste com o exemplo do PRD.
- **API, integração:** Supertest contra a aplicação NestJS com um Postgres real (Docker no local, *service container* no CI). Cada teste roda num banco limpo.
- **Front:** Vitest + Testing Library para componentes com lógica; **Playwright** para cadastro, lançamento, virada do mês e revisão das fixas, contra a API real.
- **CI (GitHub Actions)**, em todo PR e push na `main`: instalar, lint, checagem de tipos, testes, build. Na API também: validar migrações e conferir se o `openapi.json` está atualizado.
- `main` protegida: merge só com CI verde e revisão do João; squash merge.

## Consequências

- O CI começa antes do código existir e pula os passos até o `package.json` aparecer (tarefa 1 da Fase 1 ativa tudo).
