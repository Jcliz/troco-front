# Modelo de dados

Banco: PostgreSQL 17. ORM: Prisma. Nomes de tabelas e colunas em inglês e `snake_case` no banco (`@@map`/`@map`), `camelCase` no Prisma. Decisões de base: dinheiro em `Decimal` ([ADR-0006](adr/0006-dinheiro-em-decimal.md)), datas de negócio em `date` ([ADR-0008](adr/0008-datas-e-fuso-horario.md)), IDs UUID v7 ([ADR-0016](adr/0016-ids-uuid-v7.md)), tudo pertence a um `Ledger` ([ADR-0011](adr/0011-ledger-como-dono-dos-dados.md)).

## Diagrama (Fase 1)

```
User ─1:N─ Session
  │  └─1:N─ PasswordResetToken
  └─N:M (LedgerMember)─ Ledger ─1:N─ Period
                          ├─1:N─ Category (─1:N─ Category filha = subcategoria)
                          ├─1:N─ RecurringItem ─1:N─ Entry (instâncias mensais)
                          ├─1:N─ Entry
                          └─1:N─ SeasonalPlan ─0..1─ Entry (quando acontece)
LoginAttempt (solta, para limite de tentativas)
```

## Tabelas da Fase 1

### `users`
Pessoa cadastrada. `email` é salvo em minúsculas e único. `role` é `USER` ou `ADMIN` (admin definido direto no banco). `locale` (`pt-BR`), `timezone` (`America/Sao_Paulo`), `theme` (tema da interface, padrão `SUNSET`, PRD 7.16). `terms_version` e `terms_accepted_at` registram o aceite (RF-120). `last_seen_at` alimenta as métricas de admin (Fase 3) sem guardar histórico de navegação.

### `sessions`
Uma linha por login ativo. Guarda só o hash do token (`token_hash`), validade e último uso. Apagada no logout, na troca de senha e na exclusão da conta.

### `password_reset_tokens`
Hash do token, validade de 1 hora e `used_at` (uso único).

### `login_attempts`
Para o limite de tentativas (RNF-04). `key` é o hash de `email` ou de `ip`; guarda só tentativas das últimas 24 horas (limpeza na própria rotina de login).

### `ledgers` e `ledger_members`
A "conta" financeira. Na Fase 1, uma `PERSONAL` por usuário. Guarda a moeda (`BRL`) e a meta de reserva: `reserve_goal_type` (`FIXED` ou `PERCENT`) e `reserve_goal_value` (valor ou fração, ex.: `0.1000`).

### `periods`
O mês financeiro ([ADR-0007](adr/0007-mes-financeiro-por-periodos.md)). `start_date` é o dia do salário; `end_date` é `null` no mês aberto. `invested_amount` é o quanto o usuário marcou como investido no fechamento (RF-73). `closed_at` marca quando a virada aconteceu.
Restrições: `unique (ledger_id, start_date)`; índice único parcial "só um aberto por ledger" (`WHERE end_date IS NULL`); `CHECK (end_date IS NULL OR end_date >= start_date)`.

### `categories`
Categorias e subcategorias na mesma tabela, com `parent_id` (um nível só, validado no service). `system_key` marca as categorias com comportamento especial: `INVESTMENT` (abate da reserva, RF-76), `EMERGENCY` (separada nos insights), `ONE_OFF` (Avulsos) e `OTHER`. Essas não podem ser excluídas, só renomeadas. `archived_at`: categoria removida que ainda tem lançamentos fica arquivada (some das listas, mas o histórico continua). Na exclusão, a interface oferece mover os lançamentos para outra categoria.
Categorias e subcategorias padrão são criadas para cada ledger novo (seed em código, não em migração).

### `recurring_items`
As fixas: despesas mensais e rendas fixas (7.3.1). `kind` (`INCOME`/`EXPENSE`), `description`, `category_id` e `subcategory_id` (só despesas), `reference_amount` (valor de referência), `expected_variance` (padrão `0.0500` = ±5%, RF-29b), `active`. O histórico de valores (RF-29e) são as próprias instâncias em `entries`, então não há tabela de histórico.

### `entries`
Todo lançamento, renda ou gasto.

| Coluna | Uso |
|---|---|
| `kind` | `INCOME` ou `EXPENSE` |
| `expense_type` | `FIXED`, `SEASONAL` ou `ONE_OFF` (só despesa) |
| `income_type` | `FIXED` ou `VARIABLE` (só renda) |
| `status` | `CONFIRMED` ou `PENDING` ("a confirmar", RF-27) |
| `date` | data de negócio; define o mês financeiro |
| `amount`, `currency` | valor na moeda do ledger (o que entra nos cálculos) |
| `original_amount`, `original_currency`, `exchange_rate` | Fase 3 (moeda própria); na Fase 1 iguais ao valor e `BRL`, cotação `1` |
| `category_id`, `subcategory_id` | só despesa; subcategoria opcional |
| `recurring_item_id` | instância de uma fixa |
| `seasonal_plan_id` | o gasto real de um sazonal planejado |
| `description`, `notes` | texto livre |
| `created_by_id` | quem lançou (RF-143) |

Restrições: a idempotência da virada usa `unique (recurring_item_id, generated_for_period_start)`, uma coluna preenchida só nas instâncias geradas automaticamente (a data do lançamento pode ser editada, então não serve como chave). `CHECK` para coerência de `kind` com `expense_type`/`income_type`.
Índices: `(ledger_id, date)`, `(ledger_id, category_id, date)`.

### `seasonal_plans`
Gasto sazonal planejado (RF-24): `description`, `category_id`, `expected_date`, `estimated_amount`, `status` (`PLANNED`, `DONE`, `CANCELED`). Quando o gasto acontece, cria-se um `entry` com `expense_type = SEASONAL` ligado ao plano. A provisão mensal (RF-72) é Fase 2 e é só cálculo.

## Schema Prisma da Fase 1

```prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider  = "postgresql"
  url       = env("DATABASE_URL")
  directUrl = env("DIRECT_URL")
}

enum Role { USER ADMIN }
enum LedgerType { PERSONAL JOINT }
enum LedgerRole { OWNER MEMBER }
enum ReserveGoalType { FIXED PERCENT }
enum EntryKind { INCOME EXPENSE }
enum ExpenseType { FIXED SEASONAL ONE_OFF }
enum IncomeType { FIXED VARIABLE }
enum EntryStatus { CONFIRMED PENDING }
enum CategorySystemKey { INVESTMENT EMERGENCY ONE_OFF OTHER }
enum SeasonalStatus { PLANNED DONE CANCELED }
enum Theme { DARK MIDNIGHT LIGHT SUNSET BLUE SEA_GREEN AUTUMN OCEAN ZOMBIE }

model User {
  id              String    @id @default(uuid(7)) @db.Uuid
  name            String
  email           String    @unique
  passwordHash    String    @map("password_hash")
  role            Role      @default(USER)
  locale          String    @default("pt-BR")
  timezone        String    @default("America/Sao_Paulo")
  theme           Theme     @default(SUNSET)
  termsVersion    String    @map("terms_version")
  termsAcceptedAt DateTime  @map("terms_accepted_at") @db.Timestamptz
  lastSeenAt      DateTime? @map("last_seen_at") @db.Timestamptz
  createdAt       DateTime  @default(now()) @map("created_at") @db.Timestamptz
  updatedAt       DateTime  @updatedAt @map("updated_at") @db.Timestamptz

  sessions       Session[]
  resetTokens    PasswordResetToken[]
  memberships    LedgerMember[]
  createdEntries Entry[] @relation("EntryCreatedBy")

  @@map("users")
}

model Session {
  id         String   @id @default(uuid(7)) @db.Uuid
  userId     String   @map("user_id") @db.Uuid
  tokenHash  String   @unique @map("token_hash")
  expiresAt  DateTime @map("expires_at") @db.Timestamptz
  lastUsedAt DateTime @default(now()) @map("last_used_at") @db.Timestamptz
  userAgent  String?  @map("user_agent")
  createdAt  DateTime @default(now()) @map("created_at") @db.Timestamptz

  user User @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@index([userId])
  @@map("sessions")
}

model PasswordResetToken {
  id        String    @id @default(uuid(7)) @db.Uuid
  userId    String    @map("user_id") @db.Uuid
  tokenHash String    @unique @map("token_hash")
  expiresAt DateTime  @map("expires_at") @db.Timestamptz
  usedAt    DateTime? @map("used_at") @db.Timestamptz
  createdAt DateTime  @default(now()) @map("created_at") @db.Timestamptz

  user User @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@index([userId])
  @@map("password_reset_tokens")
}

model LoginAttempt {
  id        String   @id @default(uuid(7)) @db.Uuid
  key       String
  success   Boolean
  createdAt DateTime @default(now()) @map("created_at") @db.Timestamptz

  @@index([key, createdAt])
  @@map("login_attempts")
}

model Ledger {
  id               String          @id @default(uuid(7)) @db.Uuid
  type             LedgerType
  name             String
  currency         String          @default("BRL") @db.Char(3)
  reserveGoalType  ReserveGoalType @default(PERCENT) @map("reserve_goal_type")
  reserveGoalValue Decimal         @default(0) @map("reserve_goal_value") @db.Decimal(18, 4)
  createdAt        DateTime        @default(now()) @map("created_at") @db.Timestamptz
  updatedAt        DateTime        @updatedAt @map("updated_at") @db.Timestamptz

  members        LedgerMember[]
  periods        Period[]
  categories     Category[]
  recurringItems RecurringItem[]
  entries        Entry[]
  seasonalPlans  SeasonalPlan[]

  @@map("ledgers")
}

model LedgerMember {
  ledgerId String     @map("ledger_id") @db.Uuid
  userId   String     @map("user_id") @db.Uuid
  role     LedgerRole
  joinedAt DateTime   @default(now()) @map("joined_at") @db.Timestamptz

  ledger Ledger @relation(fields: [ledgerId], references: [id], onDelete: Cascade)
  user   User   @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@id([ledgerId, userId])
  @@index([userId])
  @@map("ledger_members")
}

model Period {
  id             String    @id @default(uuid(7)) @db.Uuid
  ledgerId       String    @map("ledger_id") @db.Uuid
  startDate      DateTime  @map("start_date") @db.Date
  endDate        DateTime? @map("end_date") @db.Date
  investedAmount Decimal   @default(0) @map("invested_amount") @db.Decimal(18, 2)
  closedAt       DateTime? @map("closed_at") @db.Timestamptz
  createdAt      DateTime  @default(now()) @map("created_at") @db.Timestamptz

  ledger Ledger @relation(fields: [ledgerId], references: [id], onDelete: Cascade)

  @@unique([ledgerId, startDate])
  // Na migração (SQL): CREATE UNIQUE INDEX periods_one_open ON periods (ledger_id) WHERE end_date IS NULL;
  // e CHECK (end_date IS NULL OR end_date >= start_date)
  @@map("periods")
}

model Category {
  id         String             @id @default(uuid(7)) @db.Uuid
  ledgerId   String             @map("ledger_id") @db.Uuid
  parentId   String?            @map("parent_id") @db.Uuid
  name       String
  systemKey  CategorySystemKey? @map("system_key")
  sortOrder  Int                @default(0) @map("sort_order")
  archivedAt DateTime?          @map("archived_at") @db.Timestamptz
  createdAt  DateTime           @default(now()) @map("created_at") @db.Timestamptz

  ledger   Ledger     @relation(fields: [ledgerId], references: [id], onDelete: Cascade)
  parent   Category?  @relation("Subcategories", fields: [parentId], references: [id], onDelete: Restrict)
  children Category[] @relation("Subcategories")

  entries               Entry[]         @relation("EntryCategory")
  subEntries            Entry[]         @relation("EntrySubcategory")
  recurringItems        RecurringItem[] @relation("RecurringCategory")
  recurringSubItems     RecurringItem[] @relation("RecurringSubcategory")
  seasonalPlans         SeasonalPlan[]

  @@unique([ledgerId, parentId, name]) // na migração, trocar por índice com NULLS NOT DISTINCT para valer também nas categorias pai
  @@index([ledgerId])
  @@map("categories")
}

model RecurringItem {
  id               String    @id @default(uuid(7)) @db.Uuid
  ledgerId         String    @map("ledger_id") @db.Uuid
  kind             EntryKind
  description      String
  categoryId       String?   @map("category_id") @db.Uuid
  subcategoryId    String?   @map("subcategory_id") @db.Uuid
  referenceAmount  Decimal   @map("reference_amount") @db.Decimal(18, 2)
  expectedVariance Decimal   @default(0.05) @map("expected_variance") @db.Decimal(7, 4)
  active           Boolean   @default(true)
  createdAt        DateTime  @default(now()) @map("created_at") @db.Timestamptz
  updatedAt        DateTime  @updatedAt @map("updated_at") @db.Timestamptz

  ledger      Ledger    @relation(fields: [ledgerId], references: [id], onDelete: Cascade)
  category    Category? @relation("RecurringCategory", fields: [categoryId], references: [id])
  subcategory Category? @relation("RecurringSubcategory", fields: [subcategoryId], references: [id])
  instances   Entry[]

  @@index([ledgerId])
  @@map("recurring_items")
}

model Entry {
  id                      String       @id @default(uuid(7)) @db.Uuid
  ledgerId                String       @map("ledger_id") @db.Uuid
  kind                    EntryKind
  expenseType             ExpenseType? @map("expense_type")
  incomeType              IncomeType?  @map("income_type")
  status                  EntryStatus  @default(CONFIRMED)
  date                    DateTime     @db.Date
  amount                  Decimal      @db.Decimal(18, 2)
  currency                String       @db.Char(3)
  originalAmount          Decimal      @map("original_amount") @db.Decimal(18, 2)
  originalCurrency        String       @map("original_currency") @db.Char(3)
  exchangeRate            Decimal      @default(1) @map("exchange_rate") @db.Decimal(18, 8)
  description             String
  notes                   String?
  categoryId              String?      @map("category_id") @db.Uuid
  subcategoryId           String?      @map("subcategory_id") @db.Uuid
  recurringItemId         String?      @map("recurring_item_id") @db.Uuid
  generatedForPeriodStart DateTime?    @map("generated_for_period_start") @db.Date
  seasonalPlanId          String?      @unique @map("seasonal_plan_id") @db.Uuid
  createdById             String?      @map("created_by_id") @db.Uuid
  createdAt               DateTime     @default(now()) @map("created_at") @db.Timestamptz
  updatedAt               DateTime     @updatedAt @map("updated_at") @db.Timestamptz

  ledger        Ledger         @relation(fields: [ledgerId], references: [id], onDelete: Cascade)
  category      Category?      @relation("EntryCategory", fields: [categoryId], references: [id])
  subcategory   Category?      @relation("EntrySubcategory", fields: [subcategoryId], references: [id])
  recurringItem RecurringItem? @relation(fields: [recurringItemId], references: [id], onDelete: SetNull)
  seasonalPlan  SeasonalPlan?  @relation(fields: [seasonalPlanId], references: [id], onDelete: SetNull)
  createdBy     User?          @relation("EntryCreatedBy", fields: [createdById], references: [id], onDelete: SetNull)

  @@unique([recurringItemId, generatedForPeriodStart])
  @@index([ledgerId, date])
  @@index([ledgerId, categoryId, date])
  // Na migração (SQL): CHECK ((kind = 'EXPENSE' AND expense_type IS NOT NULL AND income_type IS NULL)
  //                       OR (kind = 'INCOME' AND income_type IS NOT NULL AND expense_type IS NULL))
  @@map("entries")
}

model SeasonalPlan {
  id              String         @id @default(uuid(7)) @db.Uuid
  ledgerId        String         @map("ledger_id") @db.Uuid
  description     String
  categoryId      String         @map("category_id") @db.Uuid
  expectedDate    DateTime       @map("expected_date") @db.Date
  estimatedAmount Decimal        @map("estimated_amount") @db.Decimal(18, 2)
  status          SeasonalStatus @default(PLANNED)
  createdAt       DateTime       @default(now()) @map("created_at") @db.Timestamptz
  updatedAt       DateTime       @updatedAt @map("updated_at") @db.Timestamptz

  ledger   Ledger   @relation(fields: [ledgerId], references: [id], onDelete: Cascade)
  category Category @relation(fields: [categoryId], references: [id])
  entry    Entry?

  @@index([ledgerId, expectedDate])
  @@map("seasonal_plans")
}
```

Este schema é o ponto de partida da tarefa de modelagem da Fase 1. Se algo mudar durante a implementação, atualize este documento no mesmo PR.

## Categorias padrão (seed por ledger)

| Categoria | `system_key` | Subcategorias padrão |
|---|---|---|
| Moradia | | Aluguel, Condomínio, Energia, Água, Internet |
| Alimentação | | Mercado, Restaurante, Delivery |
| Transporte | | Combustível, Transporte público, Aplicativo, Manutenção |
| Saúde | | Plano de saúde, Farmácia, Consultas |
| Educação | | Cursos, Material, Mensalidade |
| Lazer | | Passeios, Viagens, Hobbies |
| Assinaturas | | |
| Emergência | `EMERGENCY` | |
| Investimento | `INVESTMENT` | |
| Avulsos | `ONE_OFF` | |
| Outros | `OTHER` | |

## Esboço das Fases 2 e 3 (a detalhar)

Só para garantir que a Fase 1 não fecha portas. Cada tabela será detalhada no plano da sua fase.

| Tabela | Fase | Ideia |
|---|---|---|
| `payment_methods` | 2 | Tipo (`CREDIT_CARD`, `BANK_ACCOUNT`, `CASH`, `PIX`), nome; cartão com `closing_day` e `due_day`. `entries.payment_method_id` entra aqui |
| `invoices`, `invoice_payments` | 2 | Fatura por cartão e mês de referência; pagamentos antecipados totais ou parciais (não são gastos, RF-48) |
| `installment_plans` | 2 | Compra parcelada: total, nº de parcelas, juros. Cada parcela é um `entry` ligado ao plano |
| `subscriptions`, `subscription_usages` | 2 | Assinatura com ciclo, status e renovação; uso mensal com texto |
| `budgets` | 2 | Limite por categoria (e subcategoria) por ledger |
| `alerts`, `notification_preferences` | 2/3 | Alertas gerados e preferências por tipo e canal |
| `push_subscriptions` | 3 | Endpoints de Web Push |
| `exchange_rates` | 3 | Cotação por moeda e dia, cache da API de cotação |
| `ledger_invites`, `entry_splits` | 3 | Convites da conta conjunta; divisão por membro, com estado "a ver" |

## Pontos em aberto

- Modelo de mês da conta conjunta (PRD, seção 13, ponto 10).
- Política de retenção de `login_attempts` e sessões expiradas (limpeza periódica quando houver cron).
