# Plano da Fase 1: base e controle mensal

Escopo: PRD, seção 5, "Fase 1". Cada tarefa vira **uma branch e um PR**, feita pelo Claude Code e revisada pelo João. Ordem sugerida de cima para baixo; a coluna "Depende de" diz o que precisa estar no `main` antes.

**Sobre o design:** as tarefas de tela (FE-04 em diante) usam o tema padrão do shadcn enquanto o `DESIGN.md` estiver vazio. Quando o design ficar pronto, entra uma tarefa de aplicar o visual. API e scaffolding podem começar já.

## Visão geral

| ID | Tarefa | Repo | Depende de |
|---|---|---|---|
| API-01 | Scaffolding da API | api | – |
| FE-01 | Scaffolding do front | front | – |
| API-02 | Prisma e schema da Fase 1 | api | API-01 |
| API-03 | Base transversal: erros, config, logs, OpenAPI | api | API-01 |
| API-04 | Cadastro, login, logout e sessões | api | API-02, API-03 |
| API-05 | Recuperação de senha e e-mail | api | API-04 |
| FE-02 | Cliente da API, proxy e proteção de rotas | front | FE-01, API-04 |
| FE-03 | Telas de login, cadastro e recuperação de senha | front | FE-02, API-05 |
| API-06 | Conta (ledger) e categorias | api | API-04 |
| API-07 | Mês financeiro: primeiro mês, virada, desfazer, corrigir data | api | API-06 |
| API-08 | Lançamentos | api | API-07 |
| API-09 | Fixas, geração "a confirmar" e revisão | api | API-08 |
| API-10 | Sazonais planejados | api | API-08 |
| API-11 | Motor de cálculo e resumo do mês | api | API-08 |
| API-12 | LGPD: exportar e excluir conta | api | API-09, API-10 |
| FE-04 | Layout do app e navegação | front | FE-03 |
| FE-05 | Primeiro acesso (data do último salário) | front | FE-04, API-07 |
| FE-06 | Lançamentos | front | FE-04, API-08 |
| FE-07 | Dashboard | front | FE-04, API-11 |
| FE-08 | Virar o mês | front | FE-07, API-09 |
| FE-09 | Cadastro rápido do mês e revisão das fixas | front | FE-08 |
| FE-10 | Configurações | front | FE-04, API-09, API-12 |
| FE-11 | Testes de ponta a ponta | front | FE-09, FE-10 |
| OPS-01 | Primeiro deploy em produção | ambos | FE-11 |

## Tarefas

### API-01: Scaffolding da API
Projeto NestJS com pnpm, Node 24, TypeScript strict, ESLint + Prettier, Vitest (com SWC), `docker-compose.yml` (Postgres 17 + Mailpit), `.env.example`, endpoint `GET /v1/health`, scripts `dev`, `build`, `lint`, `typecheck`, `test`, `test:integration`.
**Aceite:**
- `docker compose up -d && pnpm install && pnpm start:dev` sobe a API e `/v1/health` responde `200`.
- `pnpm lint`, `pnpm typecheck`, `pnpm test`, `pnpm build` passam; o CI roda todos e fica verde.
- Estrutura de pastas igual à de [architecture.md](../architecture.md).

### FE-01: Scaffolding do front
Next.js (App Router) com pnpm, TypeScript strict, Tailwind, shadcn/ui inicializado, next-intl com `pt-BR` e rota `/[locale]`, ESLint + Prettier, Vitest + Testing Library, Playwright instalado (sem testes ainda), `.env.example`.
**Aceite:**
- `pnpm dev` abre uma página inicial com texto vindo de `messages/pt-BR.json`.
- Lint, typecheck, test e build passam; CI verde.

### API-02: Prisma e schema da Fase 1
Schema de [data-model.md](../data-model.md), primeira migração com os índices e `CHECK` em SQL, `PrismaService`, helper de banco limpo para testes de integração.
**Aceite:**
- `pnpm prisma migrate dev` cria tudo do zero num banco vazio.
- Teste de integração prova: só um período aberto por ledger; `CHECK` de `kind` com tipo de lançamento.
- CI roda testes de integração com Postgres e checa se as migrações estão em dia.

### API-03: Base transversal
Validação de variáveis com zod; filtro global de erros em problem+json com `code`; `ValidationPipe` global; `nestjs-pino` com `requestId`; `helmet`, CORS; `@nestjs/swagger` com script `openapi:generate` e checagem `openapi:check` no CI; utilitários `money` e `calendar-date` com testes; `Clock` injetável.
**Aceite:**
- Erro de validação sai como `422` problem+json com `errors[]`.
- `openapi.json` commitado e CI falha se estiver desatualizado.
- Testes dos utilitários de dinheiro (soma, arredondamento, parse de string) e de datas (hoje no fuso do usuário).

### API-04: Cadastro, login, logout e sessões
Endpoints de `auth` ([api-contracts.md](../api-contracts.md)). Cadastro cria usuário, ledger pessoal, membro `OWNER` e as categorias padrão, e já abre sessão. `SessionGuard` global (rotas públicas marcadas com `@Public()`), `LedgerAccessGuard`, `GET /v1/me`. Limite de tentativas ([ADR-0005](../adr/0005-autenticacao-sessao-em-cookie.md)). Checagem de `Origin` em métodos de escrita.
**Aceite:**
- Senha fora do RF-02 → `422` `WEAK_PASSWORD`; sem aceite dos termos → `TERMS_NOT_ACCEPTED`; e-mail repetido → `409` `EMAIL_TAKEN`.
- Login certo devolve cookie com os atributos do ADR; senha errada → `401` `INVALID_CREDENTIALS` (mesma mensagem para e-mail inexistente).
- 6ª tentativa errada em 15 minutos → `429` `TOO_MANY_ATTEMPTS`.
- Logout invalida a sessão no banco. Senha salva em argon2id.
- Usuário A recebe `404` ao acessar ledger do usuário B (teste de integração).

### API-05: Recuperação de senha e e-mail
Módulo `mail` com `Mailer`, drivers `smtp` e `log`, template de recuperação em React Email. Endpoints `password/forgot` e `password/reset`.
**Aceite:**
- No local, o e-mail chega no Mailpit com link `${APP_URL}/recuperar-senha?token=...`.
- `forgot` responde `202` exista ou não o e-mail.
- Token expira em 1 hora, só funciona uma vez, e o reset encerra todas as sessões.

### FE-02: Cliente da API, proxy e proteção de rotas
Rewrite `/api/:path*` → `API_URL`; script `api:sync` que copia o `openapi.json` da API e gera tipos com `openapi-typescript`; cliente `openapi-fetch`; TanStack Query configurado; tratamento de erro por `code` com mensagens em `messages/`; `middleware.ts` que manda para o login quem não tem cookie.
**Aceite:**
- Chamada a `/api/v1/me` no navegador funciona com o cookie no domínio do front.
- Acessar `/pt-BR/dashboard` sem sessão redireciona para o login e volta depois de entrar.
- Tipos gerados não são editados à mão; CI falha se estiverem diferentes do `openapi.json`.

### FE-03: Telas de autenticação
Login, cadastro (com as regras de senha aparecendo em tempo real, RF-02, e aceite de termos com link para páginas de termos e privacidade com texto provisório), esqueci a senha, redefinir senha, logout.
**Aceite:**
- Cadastro leva direto ao app (RF-05).
- Cada regra da senha fica marcada conforme o usuário digita.
- Erros da API aparecem traduzidos.
- Funciona bem em 360 px de largura e em desktop.

### API-06: Conta e categorias
`GET/PATCH /ledgers/{id}` (meta de reserva fixa ou percentual), CRUD de categorias com árvore de um nível, regras de exclusão (`moveTo`, arquivamento, categorias de sistema protegidas).
**Aceite:**
- Subcategoria de subcategoria → `422` `SUBCATEGORY_DEPTH`.
- Excluir "Investimento" → `409` `SYSTEM_CATEGORY`.
- Excluir categoria com lançamentos sem `moveTo` → arquiva; com `moveTo` → move e apaga.
- Meta percentual aceita só entre 0 e 1.

### API-07: Mês financeiro
Endpoints de `periods` ([ADR-0007](../adr/0007-mes-financeiro-por-periodos.md)): primeiro mês, mês atual, corrigir data, virada (transação idempotente), desfazer, fechamento (`investedAmount`). Nesta tarefa a virada ainda não gera fixas (entra na API-09).
**Aceite:**
- Virada com data futura → `DATE_IN_FUTURE`; anterior ao início do mês atual → `DATE_BEFORE_PERIOD_START`.
- Duas viradas com a mesma data (clique duplo) resultam em um só mês novo.
- Desfazer só funciona se o mês novo não tiver lançamentos além dos gerados e ainda pendentes; senão `UNDO_NOT_ALLOWED`.
- Corrigir a data do mês atual também ajusta o `end_date` do mês anterior.

### API-08: Lançamentos
CRUD de `entries` com filtros e paginação por cursor; regras de coerência (renda sem categoria, despesa com categoria; subcategoria tem que ser filha da categoria); data antes do primeiro mês → `DATE_BEFORE_FIRST_PERIOD`; `createdById`.
**Aceite:**
- Filtros por mês (`periodId`), tipo, categoria e status funcionam juntos (RF-26).
- Lançamento pertence ao mês pela data (teste com mês corrigido).
- Moeda sempre a do ledger na Fase 1.

### API-09: Fixas e revisão
CRUD de `recurring-items`; a virada passa a gerar instâncias `PENDING` com o valor de referência (despesas e rendas fixas, RF-27, RF-29f); endpoints de revisão com diferença em valor e percentual em relação ao mês anterior e marcação de "fora da variação esperada" (RF-29a, RF-29b); "usar nos próximos meses" atualiza o `referenceAmount`; histórico.
**Aceite:**
- Virada gera uma instância por fixa ativa, sem duplicar se repetida.
- Confirmar tudo muda todas para `CONFIRMED` sem mudar valores.
- Alterar só para o mês não muda o valor de referência; com `applyToFuture` muda.
- Variação de 6% com esperado de 5% aparece marcada.

### API-10: Sazonais planejados
CRUD de `seasonal-plans` e `realize` (cria o gasto real `SEASONAL` e marca `DONE`).
**Aceite:**
- Realizar duas vezes → `409`.
- Excluir o gasto real volta o plano para `PLANNED`.

### API-11: Motor de cálculo e resumo
Módulo `calculation` puro e `GET .../periods/{id}/summary` conforme [calculation.md](../calculation.md), incluindo gastos por categoria e os lembretes calculados na leitura.
**Aceite:**
- Todos os casos de teste obrigatórios de `calculation.md` passam, incluindo o exemplo do PRD (R$ 1.900,00).
- `investedAmount` maior que a sobra → `INVESTED_EXCEEDS_SURPLUS`.
- Resumo de 24 meses responde em menos de 300 ms no local.

### API-12: LGPD
`GET /v1/me/export` e `DELETE /v1/me` com senha.
**Aceite:**
- Exportação contém perfil, ledgers, meses, categorias, fixas, lançamentos e sazonais, sem hashes de senha ou tokens.
- Depois da exclusão, nenhuma linha ligada ao usuário sobra no banco (teste de integração) e a sessão deixa de valer.

### FE-04: Layout do app
Casca autenticada: navegação lateral no desktop e inferior no celular, cabeçalho com o mês atual, menu do usuário com sair, provedor do ledger atual.
**Aceite:** navegação para Dashboard, Lançamentos, Mês e Configurações em 360 px e em desktop; sem texto fixo fora de `messages/`.

### FE-05: Primeiro acesso
Se `periods/current` responde `NO_PERIOD`, mostra a tela "Quando você recebeu o último salário?" e cria o primeiro mês. Oferece configurar a meta de reserva.
**Aceite:** usuário novo não chega ao dashboard sem ter um mês aberto.

### FE-06: Lançamentos
Lista com filtros (mês, tipo, categoria, status), criação e edição em formulário (sheet no celular), exclusão com confirmação, campo de valor com máscara de moeda.
**Aceite:** criar, editar e excluir renda e gasto refletem na lista sem recarregar; filtros ficam na URL.

### FE-07: Dashboard
Margem disponível em destaque, reserva do mês (meta, aportado, pendente), gastos por categoria, próximos sazonais, lembretes (revisão pendente, mês aberto há mais de 35 dias) e botão "Virar o mês".
**Aceite:** números batem com o `summary` da API; estados vazios tratados.

### FE-08: Virar o mês
Fluxo em etapas: data do salário (padrão hoje) → fechamento (sobra ou estouro, quanto foi investido) → confirmação → leva à revisão das fixas. Opção de desfazer a última virada.
**Aceite:** fluxo completo funciona com teclado e no celular; erro de data mostra a mensagem certa.

### FE-09: Cadastro rápido do mês
Começa pela revisão das fixas e rendas fixas ("Teve mudança em algum valor?"), com confirmar tudo, editar valor, "usar nos próximos meses" e diferença em relação ao mês anterior (destaque fora da variação). Depois: rendas variáveis, sazonais e meta de reserva.
**Aceite:** confirmar tudo em um clique; diferença exibida como "+R$ 4,30, +3,1%".

### FE-10: Configurações
Fixas (criar, editar, ativar/desativar, variação esperada), categorias e subcategorias, meta de reserva, perfil, exportar dados e excluir conta (com senha).
**Aceite:** excluir categoria com lançamentos pergunta para onde mover; exportação baixa um `.json`.

### FE-11: Testes de ponta a ponta
Playwright contra API real (Docker) nos fluxos: cadastro → primeiro acesso → lançamento → virada → revisão das fixas; recuperação de senha via Mailpit. Entram no CI do front.
**Aceite:** suíte roda no CI em menos de 5 minutos.

### OPS-01: Primeiro deploy
Siga [environments.md](../environments.md#primeiro-deploy-passo-a-passo-para-o-joão). Claude: `vercel.json`/configuração necessária, Sentry nos dois repos, `migrate deploy` no build da API. João: contas e variáveis.
**Aceite:** cadastro, login, recuperação de senha (e-mail chegando de verdade) e virada funcionando em produção pelo celular.

## Fora da Fase 1

Formas de pagamento, cartões, parcelas, provisão sazonal, assinaturas, orçamentos, insights, alertas por toast/e-mail/push, conta conjunta, multimoeda, outros idiomas, PWA e admin (PRD, seção 5).
