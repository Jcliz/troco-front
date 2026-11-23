# Documentação do troco

Esta pasta `docs/` é idêntica nos dois repositórios (`troco-api` e `troco-front`) e na pasta local `troco/docs`. Ao mudar um documento, aplique a mesma mudança nos dois repos no mesmo dia (ver "Como manter").

| Documento | O que tem | Estado |
|---|---|---|
| [PRD.md](PRD.md) | Produto: o que o troco faz e por quê | Aprovado v1.3 |
| [architecture.md](architecture.md) | Visão geral técnica: componentes, fluxo de uma requisição, módulos | v1 |
| [adr/](adr/README.md) | Decisões de arquitetura, uma por arquivo | v1 |
| [data-model.md](data-model.md) | Tabelas do Postgres e schema Prisma | Fase 1 completa; Fases 2 e 3 em esboço |
| [calculation.md](calculation.md) | Como o motor de cálculo implementa a seção 8 do PRD | Fase 1 |
| [api-contracts.md](api-contracts.md) | Convenções REST e endpoints | Fase 1 |
| [conventions.md](conventions.md) | Código, Git, testes, glossário PT → EN | v1 |
| [security-lgpd.md](security-lgpd.md) | Autenticação, sessões, LGPD | v1 |
| [environments.md](environments.md) | Ambientes, variáveis, CI e passo a passo do primeiro deploy | v1 |
| [plans/phase-1.md](plans/phase-1.md) | Tarefas da Fase 1 com critérios de aceite | Pronto para começar |
| [plans/phase-2.md](plans/phase-2.md) | Tarefas da Fase 2 | A construir |
| [plans/phase-3.md](plans/phase-3.md) | Tarefas da Fase 3 | A construir |
| `troco-front/DESIGN.md` | Design system e telas | A construir (fase de design) |

## Como manter

- A cópia de referência é a do `troco-api`. Um PR que muda `docs/` em um repo precisa de um PR irmão no outro.

- Mudou uma decisão técnica? Crie um ADR novo que substitui o antigo (não edite o antigo, só marque como "Substituído por").
- Mudou o produto? Atualize o PRD, suba a versão e registre na seção 13.
- O que ainda não foi decidido vai como **ponto de confirmação futura**: no PRD (seção 13) para produto e na seção "Pontos em aberto" de cada documento técnico.
