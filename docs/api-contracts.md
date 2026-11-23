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
| GET | `/v1/me` | Perfil + lista de ledgers do usuário (`id`, `type`, `name`, `role`) |
| PATCH | `/v1/me` | Nome, idioma, fuso |
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
| GET | `/v1/ledgers/{ledgerId}/periods/current` | Mês aberto. `404` com `code: NO_PERIOD` antes do primeiro acesso |
| PATCH | `/v1/ledgers/{ledgerId}/periods/current` | `{ startDate }`: corrige a data de início (RF-79d) |
| POST | `/v1/ledgers/{ledgerId}/periods/turnover` | Virada: `{ salaryDate, investedAmount }` → fecha o atual, abre o novo, gera as fixas "a confirmar". Responde o novo mês e o resumo do fechado |
| POST | `/v1/ledgers/{ledgerId}/periods/turnover/undo` | Desfaz a última virada, se o mês novo só tiver lançamentos gerados e ainda pendentes |
| PATCH | `/v1/ledgers/{ledgerId}/periods/{periodId}/closing` | `{ investedAmount }` em um mês já fechado |
| GET | `/v1/ledgers/{ledgerId}/periods/{periodId}/summary` | Resultado do motor de cálculo: base, reserva, margem, margem disponível, gastos por categoria, sobra (se fechado) e lembretes |

### Revisão das fixas (7.3.1)
| Método | Rota | O que faz |
|---|---|---|
| GET | `/v1/ledgers/{ledgerId}/periods/{periodId}/review` | Fixas do mês com valor sugerido, valor do mês anterior, diferença e se passou da variação esperada |
| POST | `/v1/ledgers/{ledgerId}/periods/{periodId}/review` | `{ items: [{ entryId, amount, applyToFuture }] }` → confirma. Lista vazia com `confirmAll: true` confirma tudo |

### Lançamentos (7.2, 7.3)
| Método | Rota | O que faz |
|---|---|---|
| GET | `/v1/ledgers/{ledgerId}/entries` | Filtros: `periodId`, `from`, `to`, `kind`, `expenseType`, `incomeType`, `categoryId`, `status`, `q` |
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
| GET | `/v1/ledgers/{ledgerId}/categories` | Árvore categoria → subcategorias |
| POST | `/v1/ledgers/{ledgerId}/categories` | `{ name, parentId? }` |
| PATCH | `/v1/ledgers/{ledgerId}/categories/{id}` | Renomeia, reordena |
| DELETE | `/v1/ledgers/{ledgerId}/categories/{id}?moveTo={id}` | Exclui; com lançamentos, exige `moveTo` ou arquiva. Categorias de sistema → `409` |

### Sazonais (RF-24)
| Método | Rota | O que faz |
|---|---|---|
| GET, POST | `/v1/ledgers/{ledgerId}/seasonal-plans` | Lista e cria |
| PATCH, DELETE | `/v1/ledgers/{ledgerId}/seasonal-plans/{id}` | Edita e exclui |
| POST | `/v1/ledgers/{ledgerId}/seasonal-plans/{id}/realize` | `{ date, amount }` → cria o gasto real e marca como `DONE` |

## Códigos de erro já previstos

`VALIDATION_FAILED`, `INVALID_CREDENTIALS`, `TOO_MANY_ATTEMPTS`, `EMAIL_TAKEN`, `WEAK_PASSWORD`, `TERMS_NOT_ACCEPTED`, `RESET_TOKEN_INVALID`, `NO_PERIOD`, `PERIOD_ALREADY_EXISTS`, `PERIOD_ALREADY_OPEN`, `DATE_IN_FUTURE`, `DATE_BEFORE_PERIOD_START`, `DATE_BEFORE_FIRST_PERIOD`, `UNDO_NOT_ALLOWED`, `INVESTED_EXCEEDS_SURPLUS`, `SYSTEM_CATEGORY`, `CATEGORY_HAS_ENTRIES`, `SUBCATEGORY_DEPTH`, `WRONG_PASSWORD`.

## Fases 2 e 3

A construir no plano de cada fase.
