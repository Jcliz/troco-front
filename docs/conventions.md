# Convenções

Valem para os dois repositórios. O que é específico de cada um está no `CLAUDE.md` e em `.claude/rules/` do repo.

## Idioma

- **Código, nomes de tabelas, rotas, commits, branches e PRs:** inglês.
- **Documentação (`docs/`), textos da interface e comentários explicando regra de negócio:** português (com referência ao requisito, ex.: `// RF-29c`).

## Glossário de domínio (PT → EN)

Use sempre estes nomes no código.

| Português (PRD e interface) | Código |
|---|---|
| Conta (individual / conjunta) | `Ledger` (`PERSONAL` / `JOINT`) |
| Membro, dono | `LedgerMember`, `OWNER` / `MEMBER` |
| Mês financeiro | `Period` |
| Virada do mês | `turnover` |
| Fechamento do mês | `closing` |
| Lançamento | `Entry` |
| Renda / gasto | `INCOME` / `EXPENSE` |
| Renda fixa / variável | `IncomeType.FIXED` / `VARIABLE` |
| Gasto fixo (mensal) / sazonal / avulso | `ExpenseType.FIXED` / `SEASONAL` / `ONE_OFF` |
| Fixa, recorrência | `RecurringItem` |
| Valor de referência | `referenceAmount` |
| Variação esperada | `expectedVariance` |
| "A confirmar" | `EntryStatus.PENDING` |
| Revisão das fixas | `review` |
| Gasto sazonal planejado | `SeasonalPlan` |
| Provisão sazonal | `seasonalProvision` |
| Categoria / subcategoria | `Category` (com `parentId`) |
| Meta de reserva | `reserveGoal` |
| Reserva do mês | `monthReserve` |
| Margem do mês / margem disponível | `monthMargin` / `availableMargin` |
| Saldo remanescente | `carryOver` |
| Compensação de estouro | `overspendCompensation` |
| Sobra | `surplus` |
| Aporte (em Investimento) | `contribution` |
| Parcelamento / parcela | `InstallmentPlan` / `installment` |
| Forma de pagamento | `PaymentMethod` |
| Fatura | `Invoice` |
| Assinatura | `Subscription` |
| Orçamento por categoria | `Budget` |
| Gasto "a ver" | `SplitStatus.UNDECIDED` |

## Código

- TypeScript `strict`, sem `any` (use `unknown` e refine). ESLint + Prettier, sem exceções silenciosas.
- Arquivos em `kebab-case`; classes e tipos em `PascalCase`; variáveis e funções em `camelCase`; constantes de módulo em `UPPER_SNAKE_CASE`.
- Funções pequenas, nomes que dizem a regra (`calculateAvailableMargin`, não `calc2`).
- Dinheiro só com `Decimal` ([ADR-0006](adr/0006-dinheiro-em-decimal.md)); datas de negócio só com o utilitário de datas ([ADR-0008](adr/0008-datas-e-fuso-horario.md)).
- Nada de segredo no código. Variáveis novas vão no `.env.example` e na validação de configuração.
- Dependência nova só com motivo escrito no PR.

### Princípios de design

Valem para quem escreve código aqui, pessoa ou agente. Na dúvida, o mais simples vence.

- **YAGNI**: implemente só o que a tarefa do plano pede. Nada de interface, factory, parâmetro, flag ou configuração "para o futuro" sem um segundo uso real hoje.
- **KISS**: prefira a solução direta e legível à engenhosa. Uma função clara com um `if` é melhor que um padrão de projeto para um caso só.
- **DRY, com limite**: extraia na terceira repetição, não na segunda. Duplicação é melhor que a abstração errada: dois trechos parecidos que mudam por motivos diferentes ficam separados. A fonte única de verdade das regras de negócio é a API (e, no front, o `openapi.json`), nunca uma cópia da regra.
- **SOLID, com moderação**: cada classe, função e componente com uma responsabilidade. Na API: controller recebe e valida, service decide, repository acessa o banco, o motor de cálculo só calcula. No front: a tela compõe, o hook de `features/` busca os dados, o componente de `components/` só exibe. Dependa de uma interface só onde já existe troca real (ex.: envio de e-mail, [ADR-0012](adr/0012-email-com-interface-unica.md)); não crie interface para toda classe.
- Refatoração que esses princípios sugerirem fora do escopo da tarefa vira tarefa separada, anotada no PR.

## Git

- `main` protegida: merge só por PR, com CI verde e revisão do João. **Squash merge.**
- Uma branch por tarefa, com **nome limpo e compreensível**: `feat/<id-da-tarefa>-<resumo>`, ex.: `feat/api-07-month-turnover`. Também `fix/`, `chore/`, `docs/`, `refactor/`, `test/`. Sem prefixo de ferramenta (`claude/`), hash ou sufixo aleatório. Regra completa em `.claude/rules/git.md` de cada repo.
- **Autoria:** todo commit é do João (`Jcliz`). Agentes nunca aparecem como autor ou coautor (sem `Co-Authored-By` nem assinatura de agente em commits e PRs).
- **Conventional Commits** em inglês: `feat(periods): add month turnover endpoint`. O título do PR segue o mesmo padrão (vira a mensagem do squash).
- PR pequeno (idealmente até ~400 linhas de código, sem contar gerados). Corpo do PR com o template do repo: tarefa, o que mudou, como testar, checklist.

## Testes

Ver [ADR-0013](adr/0013-testes-e-ci.md).

- Toda regra de negócio nova vem com teste. Todo bug corrigido vem com um teste que falhava antes.
- Nome do teste descreve o comportamento em inglês: `it('rolls overspend into next month reserve')`.
- Testes não dependem de ordem nem de data atual (use relógio injetável `Clock`).
- Proibido desativar ou pular teste para o CI passar.

## Definição de pronto (para cada tarefa)

1. Critérios de aceite da tarefa atendidos.
2. Lint, tipos, testes e build passando localmente e no CI.
3. Testes novos cobrindo a regra.
4. `openapi.json` atualizado (API) ou tipos sincronizados (front), se o contrato mudou.
5. Documentação em `docs/` atualizada no mesmo PR se algo do que está escrito mudou (nos dois repos).
6. Textos de interface em `messages/`, nunca no componente.
