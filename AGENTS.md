# AGENTS.md: troco-front

Instruções para qualquer agente de código neste repositório. (O Claude Code lê este arquivo pelo `CLAUDE.md`.)

## O que é

Front do **troco**, sistema web de finanças pessoais, responsivo para celular e computador (PWA na Fase 3). Só interface: **toda regra de negócio e todo cálculo vêm da API** (`troco-api`). Se uma tela precisa de um número que a API não dá, a mudança é na API.

## Stack

Node 24 LTS · pnpm · TypeScript strict · Next.js (App Router) · React · Tailwind CSS · shadcn/ui · TanStack Query · openapi-fetch + openapi-typescript · react-hook-form + zod · next-intl · date-fns · lucide-react · Vitest + Testing Library · Playwright. Deploy na Vercel.

## Comandos

```bash
pnpm install
pnpm dev                 # http://localhost:3000 (API local em http://localhost:4000)
pnpm lint
pnpm typecheck
pnpm test                # Vitest
pnpm test:e2e            # Playwright (precisa da API e do banco rodando)
pnpm api:sync            # copia o openapi.json do troco-api e regenera os tipos
pnpm build
```

> Até a tarefa FE-01 do plano, o projeto ainda não existe: estes comandos são o alvo da tarefa.

## Onde está cada coisa

- `docs/PRD.md`: produto (telas na seção 9, requisitos RF-xx).
- `docs/plans/phase-1.md`: tarefas com critérios de aceite. Toda tarefa começa aqui.
- `docs/architecture.md` (estrutura do front), `docs/api-contracts.md`, `docs/adr/` (ADR-0010 é o do front).
- `docs/conventions.md`: código, Git, testes e **glossário PT → EN**.
- `DESIGN.md`: design system e telas (**a construir**; até lá, tema padrão do shadcn).
- `src/app/[locale]/`: rotas. `(auth)` para login/cadastro, `(app)` para a área logada.
- `src/components/ui/`: componentes do shadcn. `src/components/`: componentes do troco.
- `src/features/<dominio>/`: hooks de dados, formulários e componentes de cada domínio.
- `src/lib/api/`: cliente e tipos **gerados** do OpenAPI. Não edite à mão.
- `messages/pt-BR.json`: todos os textos da interface.

## Regras que não podem ser quebradas

1. **Sem regra de negócio no front.** Margem, reserva, sobra, diferença de fixas: tudo vem da API.
2. **Sem texto fixo em componente.** Todo texto vai em `messages/` via `next-intl` (RNF-07).
3. **Dinheiro chega como string** (`"1234.56"`) e é formatado com `Intl.NumberFormat` na moeda do ledger. Nunca `parseFloat` para fazer conta.
4. **Datas de negócio são `AAAA-MM-DD`**; nunca `new Date('AAAA-MM-DD')` (muda de dia no Brasil). Use `src/lib/calendar-date`.
5. **Tipos da API só do OpenAPI gerado** (`src/lib/api`). Nada de redeclarar tipos de resposta.
6. **Chamadas à API só por `/api/...`** (proxy do Next), nunca direto para a URL da API: o cookie de sessão depende disso (ADR-0005).
7. Toda tela funciona em 360 px de largura e no desktop, com teclado e leitor de tela (labels, foco visível, contraste).
8. Erros da API são exibidos pelo `code` traduzido, nunca pelo `detail` em inglês.
9. Nunca commitar `.env`, segredos ou dados reais. Nunca pular teste para o CI passar.
10. Mudou algo descrito em `docs/` → atualize o doc no mesmo PR **e** abra o PR irmão no `troco-api` (a pasta `docs/` é idêntica nos dois).

## Postura: pensamento crítico

Concordar por padrão não ajuda o João. Em toda tarefa:

- Se um pedido, plano ou premissa estiver errado, arriscado ou em conflito com o PRD, um ADR ou estes docs, **diga antes de fazer**, com a evidência (arquivo, linha, RF, ADR). Não concorde só para agradar.
- Ao receber uma crítica ou sugestão (do João, de um revisor ou de um bot), verifique tecnicamente antes de aceitar. Se ela estiver errada, explique por quê.
- Dê sua recomendação e o porquê; quando houver alternativas reais, mostre a troca. Diga o que você não sabe ou não verificou.
- A decisão final é do João: depois que ele decidir, siga a decisão (e registre em "Pontos em aberto" o que ficou sem decidir).
- Para testar um plano ou decisão grande a fundo, use `/grill-me`.
- Siga os princípios de design (YAGNI, KISS, DRY com limite, SOLID com moderação) descritos em `docs/conventions.md`, seção "Código". Ao revisar, aponte abstração prematura tanto quanto duplicação.

## Git

Branch por tarefa (`feat/fe-08-month-turnover`), Conventional Commits em inglês, PR pequeno com o template, squash merge após CI verde e revisão do João. Se a tarefa depende de um endpoint novo, o PR da API vem antes.

## Idioma

Código, commits e PRs em inglês. Documentação e textos da interface em português.
