# Plano da Fase 1: base e controle mensal

Escopo: PRD, seção 5, "Fase 1". Cada tarefa vira **uma branch e um PR**, feita pelo Claude Code e revisada pelo João. Ordem sugerida de cima para baixo; a coluna "Depende de" diz o que precisa estar no `main` antes.

**Sobre o design:** o `DESIGN.md` do `troco-front` traz o design system consolidado a partir do protótipo aprovado da Fase 1: tokens, paletas dos temas, componentes, movimento e o desenho de cada tela. As tarefas de tela (FE-03 em diante) já seguem esse arquivo, sem tarefa separada de aplicar o visual. A seção "Proibido" do `DESIGN.md` vale para toda tarefa de tela e vem antes de qualquer skill de design. API e scaffolding podem começar já.

**Nomes das telas:** o que o PRD chama de Dashboard aparece na interface como **Painel** (a rota continua `dashboard`, como em [architecture.md](../architecture.md)), e o Cadastro rápido do mês é a tela **Mês**.

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
| FE-07 | Painel (dashboard) | front | FE-04, API-11 |
| FE-08 | Virar o mês | front | FE-07, API-09 |
| FE-09 | Mês: cadastro rápido e revisão das fixas | front | FE-08 |
| FE-10 | Configurações | front | FE-04, API-09, API-12 |
| FE-12 | Temas | front | FE-10 |
| FE-11 | Testes de ponta a ponta | front | FE-09, FE-10, FE-12 |
| OPS-01 | Primeiro deploy em produção | ambos | FE-11 |

## Tarefas

### API-01: Scaffolding da API
Projeto NestJS com pnpm, Node 24, TypeScript strict, ESLint + Prettier, Vitest (com SWC), `docker-compose.yml` (Postgres 17 + Mailpit), `.env.example`, endpoint `GET /v1/health`, scripts `start:dev`, `build`, `lint`, `typecheck`, `test`, `test:integration`.
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
Endpoints de `auth` ([api-contracts.md](../api-contracts.md)). Cadastro cria usuário, ledger pessoal, membro `OWNER` e as categorias padrão, e já abre sessão. `SessionGuard` global (rotas públicas marcadas com `@Public()`), `LedgerAccessGuard`, `GET /v1/me` e `PATCH /v1/me` (nome, idioma, fuso e tema). Limite de tentativas ([ADR-0005](../adr/0005-autenticacao-sessao-em-cookie.md)). Checagem de `Origin` em métodos de escrita.
**Aceite:**
- Senha fora do RF-02 → `422` `WEAK_PASSWORD`; sem aceite dos termos → `TERMS_NOT_ACCEPTED`; e-mail repetido → `409` `EMAIL_TAKEN`.
- Login certo devolve cookie com os atributos do ADR; senha errada → `401` `INVALID_CREDENTIALS` (mesma mensagem para e-mail inexistente).
- 6ª tentativa errada em 15 minutos → `429` `TOO_MANY_ATTEMPTS`.
- Logout invalida a sessão no banco. Senha salva em argon2id.
- Usuário A recebe `404` ao acessar ledger do usuário B (teste de integração).
- Usuário novo tem `theme` `SUNSET`; `PATCH /v1/me` com tema fora do enum → `422`.

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
Login, cadastro (com as regras de senha aparecendo em tempo real, RF-02, e aceite de termos com link para páginas de termos e privacidade com texto provisório), esqueci a senha, redefinir senha (com tela própria para link vencido ou já usado), logout. Desenho em `DESIGN.md`, "Telas da Fase 1" e "Ilustração das telas de entrada": formulário à esquerda e arte do porquinho à direita, com a borda sinuosa (`public/brand/login-edge.svg`) e a arte do tema (`public/brand/login-*.webp`); sem sessão, usa o tema do cookie ou Fim de tarde (RF-165).
**Aceite:**
- Cadastro leva direto ao primeiro acesso (RF-05, FE-05).
- Cada regra da senha fica marcada conforme o usuário digita.
- Erros da API aparecem traduzidos, na linha do campo, que já tem o espaço reservado: o cartão não muda de altura.
- Nenhuma tela de entrada rola no computador a partir de 768 px de altura; abaixo de 960 px de largura a arte some.
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
CRUD de `recurring-items`; a virada passa a gerar instâncias `PENDING` com o valor de referência (despesas e rendas fixas, RF-27, RF-29f); endpoints de revisão com diferença em valor e percentual em relação ao mês anterior e marcação de "fora da variação esperada" (RF-29a, RF-29b), inclusive a prévia `review/preview`, que calcula sem salvar; "usar nos próximos meses" atualiza o `referenceAmount`; histórico.
**Aceite:**
- Virada gera uma instância por fixa ativa, sem duplicar se repetida.
- Confirmar tudo muda todas para `CONFIRMED` sem mudar valores.
- Alterar só para o mês não muda o valor de referência; com `applyToFuture` muda.
- Variação de 6% com esperado de 5% aparece marcada, tanto no `GET` da revisão quanto na prévia.
- A prévia não grava nada: depois dela, o lançamento continua com o valor e o status de antes.
- Corrigir a data de início do mês (`PATCH periods/current`) move para a nova data as instâncias geradas na virada (RF-79d).

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
Casca autenticada conforme `DESIGN.md`, "Layout do app": menu lateral de 256 px no desktop com logo do tema, botão "Novo lançamento", Painel, Lançamentos, Mês e Configurações, e no rodapé "Recolher menu" e "Sair" (sem bloco de conta; o perfil fica em Configurações). Menu recolhido de 76 px, lembrado no navegador. Abaixo de 960 px, barra do logo em cima e barra com os quatro destinos embaixo. Pílula com o número de fixas a confirmar no item Mês (contagem da lista de revisão da API). Provedor do ledger atual.
**Aceite:** navegação para Painel, Lançamentos, Mês e Configurações em 360 px e em desktop; o leitor de tela ouve a pílula como "3 fixas a confirmar"; sem texto fixo fora de `messages/`.

### FE-05: Primeiro acesso
Se `periods/current` responde `NO_PERIOD`, mostra a tela "Quando você recebeu o último salário?" (calendário com limite em hoje) e cria o primeiro mês. Depois, "Quanto você quer guardar por mês?", com meta em percentual ou valor fixo e a opção "Definir depois" (meta fica em 0%). Usa a mesma moldura das telas de entrada.
**Aceite:** usuário novo não chega ao Painel sem ter um mês aberto.

### FE-06: Lançamentos
Abas Todos, Gastos e Rendas (com contagem), busca por descrição ou categoria (`q`), filtros num popover (categoria, status) e o mês financeiro numa lista suspensa; filtros escolhidos viram pílulas removíveis. Lista com um cartão por dia; clicar num lançamento abre o painel lateral com detalhes, editar e excluir (com confirmação). Novo lançamento em formulário de tela cheia com prévia, começando pelo seletor Gasto/Renda e pelo valor em destaque (máscara de moeda), dizendo em qual mês o lançamento entra e avisando que a sobra é recalculada se o mês estiver fechado.
**Aceite:** criar, editar e excluir renda e gasto refletem na lista sem recarregar; filtros e busca ficam na URL; todo filtro exibido muda a lista (nada de filtro sem efeito).

### FE-07: Painel (dashboard)
Margem disponível em destaque, com o medidor do quanto já foi gasto e a conta completa recolhida ("Como a margem é calculada"); abaixo, o aviso de fixas a confirmar e os gastos por categoria (barras horizontais da maior para a menor, numa cor só). Coluna de detalhes com a reserva do mês (meta, já guardado, falta guardar) e os próximos sazonais. Lembretes (revisão pendente, mês aberto há mais de 35 dias) curtos, junto do dado. "Virar o mês" no cabeçalho.
**Aceite:** números batem com o `summary` da API; estados vazios tratados, cada um com a ação que tira a tela do vazio; sem saudação no topo.

### FE-08: Virar o mês
Modal em 3 etapas: data do salário (padrão hoje, calendário entre o início do mês atual e hoje) → fechamento (sobra ou estouro, quanto foi investido) → confirmação → leva à revisão das fixas. "Desfazer a virada" na coluna "Este mês" da tela Mês, só enquanto a API permitir.
**Aceite:** fluxo completo funciona com teclado e no celular; erro de data mostra a mensagem certa.

### FE-09: Mês: cadastro rápido e revisão das fixas
Abas em sequência Fixas › Rendas variáveis › Sazonais › Meta de reserva, cada uma com "Próxima etapa". Começa pela revisão das fixas e rendas fixas ("Teve mudança em algum valor?"): cada uma com o valor sugerido num campo, o valor do mês anterior, "Confirmar valor", "Confirmar tudo", "usar nos próximos meses" quando o valor muda, e a diferença em relação ao mês anterior (aviso com ícone quando passa da variação esperada), vinda da prévia da API quando o campo perde o foco; o front não calcula. Coluna "Este mês" com a data de início e "Corrigir data", a sobra do mês anterior e "Desfazer a virada".
**Aceite:** confirmar tudo em um clique; diferença exibida como "+R$ 4,30, +3,1% em relação ao mês anterior"; corrigir a data mostra as fixas geradas na virada no novo dia.

### FE-10: Configurações
Subnavegação Fixas › Categorias › Meta de reserva › Tema › Perfil › Seus dados. Fixas (criar, editar, pausar, variação esperada, "lançar também neste mês" via `addToCurrentPeriod`) e categorias e subcategorias no painel lateral; meta de reserva; perfil; em Seus dados, exportar dados e excluir conta (com senha, em modal de confirmação). A seção Tema é da FE-12.
**Aceite:** excluir categoria com lançamentos pergunta para onde mover; categoria de sistema não mostra excluir; exportação baixa um `.json`.

### FE-11: Testes de ponta a ponta
Playwright contra API real (Docker) nos fluxos: cadastro → primeiro acesso → lançamento → virada → revisão das fixas; recuperação de senha via Mailpit. Entram no CI do front.
**Aceite:** suíte roda no CI em menos de 5 minutos.

### FE-12: Temas
Os 9 temas do PRD 7.16 como variáveis de CSS do shadcn (uma classe ou `data-theme` por tema, com as cores do `DESIGN.md`), logo do menu e arte das telas de entrada trocando com o tema (`public/brand/logo-*.png` e `login-*.webp`), escolha em Configurações com prévia de cada tema, salva via `PATCH /v1/me` e copiada num cookie para o servidor já renderizar no tema certo. Favicon e ícone fixos em Fim de tarde. O Escuro usa as cores do Fim de tarde com o tom abaixado, e nenhum tema escuro fica só em preto e branco (`DESIGN.md`, "Paletas" e "Proibido").
**Aceite:**
- Trocar o tema muda a interface na hora, sem recarregar, e vale em outro navegador depois do login.
- Recarregar a página não pisca outro tema; sem cookie e sem sessão, abre em Fim de tarde.
- Os 9 temas passam no contraste WCAG AA (teste automatizado com axe nas telas principais).
- Nomes dos temas vêm de `messages/`; o leitor de tela anuncia "Tema aplicado e salvo".

### OPS-01: Primeiro deploy
Siga [environments.md](../environments.md#primeiro-deploy-passo-a-passo-para-o-joão). Claude: `vercel.json`/configuração necessária, Sentry nos dois repos, `migrate deploy` no build da API. João: contas e variáveis.
**Aceite:** cadastro, login, recuperação de senha (e-mail chegando de verdade) e virada funcionando em produção pelo celular.

## Fora da Fase 1

Formas de pagamento, cartões, parcelas, compra à vista com resgate do investimento, provisão sazonal, assinaturas, orçamentos, insights, alertas por toast/e-mail/push, conta conjunta, multimoeda, outros idiomas, PWA e admin (PRD, seção 5).
