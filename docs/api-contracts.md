# Contratos da API

Decisão de base: [ADR-0009](adr/0009-contrato-rest-openapi.md). A fonte da verdade é o `openapi.json` gerado pelo `troco-api`. Este documento descreve as convenções e a lista de endpoints planejados; os detalhes de cada campo ficam no OpenAPI.

## Convenções

- Base: `/v1`. No navegador, sempre via proxy do front: `/api/v1/...`.
- JSON com chaves em `camelCase`.
- Dinheiro: string decimal (`"1234.56"`), sempre com `currency`. Percentual: string fracionária (`"0.1000"`).
- Datas de negócio: `"AAAA-MM-DD"`. Instantes: ISO 8601 UTC.
- Autenticação: cookie `troco_session` ([ADR-0005](adr/0005-autenticacao-sessao-em-cookie.md)). Sem sessão válida → `401`.
- Rotas de conta: `/v1/ledgers/{ledgerId}/...`. Usuário que não é membro → `404` (não revela que a conta existe).
- Listas: `GET ...?cursor=&limit=` (padrão 50, máximo 200) → `{ "items": [], "nextCursor": null }`.
- Criação → `201` com o recurso. Exclusão → `204`. Validação → `422`. Conflito de regra → `409`.
- Erros (`application/problem+json`):

```json
{
  "type": "https://troco/errors/period-already-open",
  "title": "Já existe um mês aberto",
  "status": 409,
  "code": "PERIOD_ALREADY_OPEN",
  "detail": "Vire o mês atual antes de abrir outro.",
  "errors": [{ "field": "salaryDate", "code": "DATE_IN_FUTURE" }]
}
```

`title` e `detail` são para log; a interface traduz a partir do `code`.

## Endpoints da Fase 1

### Sistema
| Método | Rota | O que faz |
|---|---|---|
| GET | `/v1/health` | Saúde da API e do banco (público) |

### Autenticação (7.1)
| Método | Rota | O que faz |
|---|---|---|
| POST | `/v1/auth/register` | `{ name, email, password, acceptTerms }` → cria usuário, ledger pessoal, categorias padrão e já abre a sessão (RF-05) |
| POST | `/v1/auth/login` | `{ email, password }` → cria sessão. `429` quando bloqueado |
| POST | `/v1/auth/logout` | Encerra a sessão atual |
| POST | `/v1/auth/password/forgot` | `{ email }` → sempre `202` |
| POST | `/v1/auth/password/reset` | `{ token, password }` → troca a senha e encerra todas as sessões |

### Usuário e LGPD (7.13)
| Método | Rota | O que faz |
|---|---|---|
| GET | `/v1/me` | Perfil (inclui `theme`) + lista de ledgers do usuário (`id`, `type`, `name`, `role`) |
| PATCH | `/v1/me` | `{ name?, locale?, timezone?, theme? }`; `theme` é um dos valores do enum `Theme` (PRD 7.16) |
| GET | `/v1/me/export` | JSON com todos os dados do usuário e dos seus ledgers (RF-121) |
| DELETE | `/v1/me` | `{ password }` → exclusão imediata e definitiva (RF-122) |

### Conta (ledger)
| Método | Rota | O que faz |
|---|---|---|
| GET | `/v1/ledgers/{ledgerId}` | Dados da conta e meta de reserva |
| PATCH | `/v1/ledgers/{ledgerId}` | `{ name?, reserveGoalType?, reserveGoalValue? }` |

### Mês financeiro (7.8.1)
| Método | Rota | O que faz |
|---|---|---|
| GET | `/v1/ledgers/{ledgerId}/periods` | Lista de meses (mais recente primeiro) |
| POST | `/v1/ledgers/{ledgerId}/periods` | Primeiro mês: `{ startDate }` (RF-79b). `409` se já existir algum |
| GET | `/v1/ledgers/{ledgerId}/periods/current` | Mês aberto, com `canUndoTurnover` (se a última virada ainda pode ser desfeita, RF-79d). `404` com `code: NO_PERIOD` antes do primeiro acesso |
| GET | `/v1/ledgers/{ledgerId}/periods/resolve?date=AAAA-MM-DD` | Em qual mês uma data cai: `{ periodId, status, startDate, endDate }` (RF-79a). Data antes do primeiro mês → `422` `DATE_BEFORE_FIRST_PERIOD` |
| PATCH | `/v1/ledgers/{ledgerId}/periods/current` | `{ startDate }`: corrige a data de início (RF-79d) e move para a nova data os lançamentos criados na virada |
| POST | `/v1/ledgers/{ledgerId}/periods/turnover` | Virada: `{ salaryDate, investedAmount }` → fecha o atual, abre o novo, gera as fixas "a confirmar". Responde o novo mês e o resumo do fechado |
| POST | `/v1/ledgers/{ledgerId}/periods/turnover/preview` | `{ salaryDate }` → como o mês atual fecharia com essa data: `surplus` e `overspendCompensation` (RF-79, etapa 2 da virada). Não salva nada |
| POST | `/v1/ledgers/{ledgerId}/periods/turnover/undo` | Desfaz a última virada, se o mês novo só tiver lançamentos gerados e ainda pendentes |
| PATCH | `/v1/ledgers/{ledgerId}/periods/{periodId}/closing` | `{ investedAmount }` em um mês já fechado |
| GET | `/v1/ledgers/{ledgerId}/periods/{periodId}/summary` | Resultado do motor de cálculo (campos em "Resumo do mês", abaixo) |

### Revisão das fixas (7.3.1)
| Método | Rota | O que faz |
|---|---|---|
| GET | `/v1/ledgers/{ledgerId}/periods/{periodId}/review` | Fixas do mês com valor sugerido, valor do mês anterior, diferença e se passou da variação esperada, mais `pendingCount` (quantas faltam confirmar) |
| POST | `/v1/ledgers/{ledgerId}/periods/{periodId}/review/preview` | `{ items: [{ entryId, amount }] }` → para cada item: `previousAmount`, `difference`, `differencePercent` e `outsideExpectedVariance`. Não salva nada; a tela chama quando o campo de valor perde o foco (RF-29a) |
| POST | `/v1/ledgers/{ledgerId}/periods/{periodId}/review` | `{ items: [{ entryId, amount, applyToFuture }] }` → confirma. Lista vazia com `confirmAll: true` confirma tudo |

### Lançamentos (7.2, 7.3)
| Método | Rota | O que faz |
|---|---|---|
| GET | `/v1/ledgers/{ledgerId}/entries` | Filtros: `periodId`, `from`, `to`, `kind`, `expenseType`, `incomeType`, `categoryId`, `status`, `q`. Além de `items` e `nextCursor`, devolve `counts: { all, expense, income }` com os outros filtros aplicados (menos `kind`), para as abas da tela |
| POST | `/v1/ledgers/{ledgerId}/entries` | Cria renda ou gasto |
| GET | `/v1/ledgers/{ledgerId}/entries/{entryId}` | Detalhe |
| PATCH | `/v1/ledgers/{ledgerId}/entries/{entryId}` | Edita (inclusive em mês fechado, RF-79e) |
| DELETE | `/v1/ledgers/{ledgerId}/entries/{entryId}` | Exclui |

### Fixas / recorrências (RF-22)
| Método | Rota | O que faz |
|---|---|---|
| GET, POST | `/v1/ledgers/{ledgerId}/recurring-items` | Lista e cria. Criar com `addToCurrentPeriod: true` já lança no mês aberto |
| PATCH, DELETE | `/v1/ledgers/{ledgerId}/recurring-items/{id}` | Edita (valor de referência, variação esperada, ativa/inativa) e exclui (instâncias passadas ficam) |
| GET | `/v1/ledgers/{ledgerId}/recurring-items/{id}/history` | Histórico de valores (RF-29e) |

### Categorias (7.6)
| Método | Rota | O que faz |
|---|---|---|
| GET | `/v1/ledgers/{ledgerId}/categories` | Árvore categoria → subcategorias, cada uma com `isSystem` e `entryCount` (para a tela perguntar para onde mover antes de excluir) |
| POST | `/v1/ledgers/{ledgerId}/categories` | `{ name, parentId? }` |
| PATCH | `/v1/ledgers/{ledgerId}/categories/{id}` | Renomeia, reordena |
| DELETE | `/v1/ledgers/{ledgerId}/categories/{id}?moveTo={id}` | Exclui; com lançamentos, exige `moveTo` ou arquiva. Categorias de sistema → `409` |

### Sazonais (RF-24)
| Método | Rota | O que faz |
|---|---|---|
| GET, POST | `/v1/ledgers/{ledgerId}/seasonal-plans` | Lista (filtros `status` e `from`, em ordem de `expectedDate`) e cria |
| PATCH, DELETE | `/v1/ledgers/{ledgerId}/seasonal-plans/{id}` | Edita e exclui |
| POST | `/v1/ledgers/{ledgerId}/seasonal-plans/{id}/realize` | `{ date, amount }` → cria o gasto real e marca como `DONE` |

### Resumo do mês (`summary`)

Todos os números que a interface mostra sobre o mês vêm daqui; o front não soma nem subtrai ([calculation.md](calculation.md)). Valores em string decimal.

| Campo | Termo em `calculation.md` | Onde aparece |
|---|---|---|
| `income` | `renda` | Conta da margem |
| `carryOver` | `saldo_remanescente_anterior` | Conta da margem; coluna "Este mês" do Mês (sobra do mês anterior) |
| `baseAmount` | `base` | Conta da margem |
| `fixedExpenses` | `fixos` | Conta da margem |
| `reserveGoalAmount` | `reserva_meta` | Reserva do mês (meta) |
| `overspendCompensation` | `compensacao_anterior` | Conta da margem, quando houver |
| `monthReserve` | `reserva_do_mes` | Conta da margem; reserva do mês |
| `contributions` | `aportes` | Reserva do mês ("já guardado") |
| `pendingReserve` | `reserva_pendente` | Reserva do mês ("falta guardar") |
| `monthMargin` | `margem_do_mes` | Medidor (total) e conta da margem |
| `variableExpenses` | `variaveis` | Conta da margem |
| `marginSpent` | `margem_do_mes − margem_disponivel` | Medidor (quanto já foi gasto) |
| `availableMargin` | `margem_disponivel` | Número principal do Painel (negativo = estouro) |
| `spendingByCategory[]` | soma por categoria | `{ categoryId, name, amount }`, da maior para a menor |
| `surplus`, `investedAmount` | `sobra`, `investido_marcado` | Só em mês fechado (`null` no aberto) |
| `reminders[]` | lembretes calculados na leitura | `PENDING_REVIEW` e `PERIOD_OPEN_TOO_LONG` (RF-29d, RF-79c) |

## Dados de cada tela (Fase 1)

Cruzamento do `DESIGN.md` (front) com os endpoints acima. Toda informação que a tela mostra tem uma fonte na API; se faltar, a mudança é na API antes da tarefa de tela. Revise esta tabela quando o desenho de uma tela mudar.

| Tela (tarefa) | O que mostra ou faz | Fonte na API |
|---|---|---|
| Entrada (FE-03) | Login, cadastro, recuperar e redefinir senha; erros por campo | `auth/*`; códigos `INVALID_CREDENTIALS`, `EMAIL_TAKEN`, `WEAK_PASSWORD`, `TERMS_NOT_ACCEPTED`, `TOO_MANY_ATTEMPTS`, `RESET_TOKEN_INVALID` |
| Entrada (FE-03) | Tema sem sessão | Cookie do tema no front (FE-12); padrão Fim de tarde |
| Layout (FE-04) | Pílula "3 fixas a confirmar" no item Mês | `periods/current` + `review.pendingCount` |
| Layout (FE-04) | Conta atual | `GET /v1/me` (`ledgers[]`) |
| Primeiro acesso (FE-05) | Decidir se aparece | `periods/current` → `NO_PERIOD` |
| Primeiro acesso (FE-05) | Abrir o primeiro mês; meta de reserva | `POST periods`; `PATCH ledgers/{id}` |
| Painel (FE-07) | Margem disponível, medidor e "Como a margem é calculada" | `summary` (`availableMargin`, `monthMargin`, `marginSpent` e os termos da conta) |
| Painel (FE-07) | Gastos por categoria | `summary.spendingByCategory` |
| Painel (FE-07) | Reserva do mês: meta, já guardado, falta guardar | `summary.monthReserve`, `contributions`, `pendingReserve` |
| Painel (FE-07) | Próximos sazonais | `seasonal-plans?status=PLANNED&from=<hoje>` |
| Painel (FE-07) | Lembretes e aviso de fixas a confirmar | `summary.reminders` |
| Lançamentos (FE-06) | Abas Todos, Gastos e Rendas com contagem | `entries.counts` |
| Lançamentos (FE-06) | Lista, busca, filtros e mês na lista suspensa | `entries` (filtros), `categories`, `periods` |
| Lançamentos (FE-06) | "Entra no mês de …" e aviso de mês fechado no novo lançamento | `periods/resolve?date=` (`status`) |
| Virar o mês (FE-08) | Etapa 2: sobra ou estouro com a data escolhida | `periods/turnover/preview` |
| Virar o mês (FE-08) | Confirmar; erro de data | `periods/turnover`; `DATE_IN_FUTURE`, `DATE_BEFORE_PERIOD_START`, `INVESTED_EXCEEDS_SURPLUS` |
| Mês (FE-09) | Revisão das fixas com diferença e aviso de variação | `review`, `review/preview` |
| Mês (FE-09) | Coluna "Este mês": início, sobra do mês anterior, "Desfazer a virada" | `periods/current` (`startDate`, `canUndoTurnover`); `summary` do mês anterior (`surplus`) |
| Mês (FE-09) | Rendas variáveis, sazonais e meta | `entries`, `seasonal-plans`, `PATCH ledgers/{id}` |
| Configurações (FE-10) | Excluir categoria perguntando para onde mover; categoria de sistema sem excluir | `categories` (`entryCount`, `isSystem`) |
| Configurações (FE-10) | Fixas, perfil, exportar e excluir conta | `recurring-items`, `me`, `me/export`, `DELETE me` |
| Temas (FE-12) | Tema salvo na conta | `GET/PATCH /v1/me` (`theme`) |

Campos e rotas marcados nesta revisão (28/11/2026) como novos: `canUndoTurnover`, `periods/resolve`, `turnover/preview`, `review.pendingCount`, `entries.counts`, `categories[].entryCount` e `isSystem`, filtros de `seasonal-plans` e a lista de campos do `summary`.

## Códigos de erro já previstos

`VALIDATION_FAILED`, `INVALID_CREDENTIALS`, `TOO_MANY_ATTEMPTS`, `EMAIL_TAKEN`, `WEAK_PASSWORD`, `TERMS_NOT_ACCEPTED`, `RESET_TOKEN_INVALID`, `NO_PERIOD`, `PERIOD_ALREADY_EXISTS`, `PERIOD_ALREADY_OPEN`, `DATE_IN_FUTURE`, `DATE_BEFORE_PERIOD_START`, `DATE_BEFORE_FIRST_PERIOD`, `UNDO_NOT_ALLOWED`, `INVESTED_EXCEEDS_SURPLUS`, `SYSTEM_CATEGORY`, `CATEGORY_HAS_ENTRIES`, `SUBCATEGORY_DEPTH`, `WRONG_PASSWORD`.

## Fases 2 e 3

A construir no plano de cada fase.

## Pontos em aberto

- **Excluir categoria com lançamentos:** o plano (API-06) diz que, sem `moveTo`, a categoria é arquivada; o código `CATEGORY_HAS_ENTRIES` está previsto, mas nenhuma regra o usa. Falta decidir se o `DELETE` sem `moveTo` arquiva ou recusa com esse código (a tela pergunta antes, pelo `entryCount`).
- **Link de redefinir senha vencido:** o `DESIGN.md` tem tela própria para link vencido ou já usado. Falta decidir se ela aparece ao abrir o link (precisaria de uma rota que confere o token sem trocar a senha) ou só ao salvar, pelo `RESET_TOKEN_INVALID`.
