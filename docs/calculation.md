# Motor de cálculo

Implementação técnica da seção 8 do PRD. Vive no módulo `calculation` da API, **sem I/O**: recebe dados já carregados e devolve números ([architecture.md](architecture.md)). Valores em `Decimal` ([ADR-0006](adr/0006-dinheiro-em-decimal.md)).

## Entradas por mês financeiro

Para cada período `p` (do mais antigo ao atual), o serviço `summary` carrega os lançamentos com `p.start_date ≤ date ≤ (p.end_date ou hoje/futuro)` e monta:

| Termo | Como se obtém |
|---|---|
| `renda` | soma das rendas (`kind = INCOME`), confirmadas e "a confirmar" (RF-29c) |
| `aportes` | soma das despesas na categoria `INVESTMENT` (qualquer `expense_type`) |
| `fixos` | soma das despesas `FIXED` fora de `INVESTMENT`, confirmadas e "a confirmar" |
| `variaveis` | soma das despesas `ONE_OFF` e `SEASONAL` fora de `INVESTMENT` |
| `parcelas` | Fase 2 (na Fase 1, `0`) |
| `provisao` | Fase 2 (na Fase 1, `0`) |
| `parte_conjunta` | Fase 3 (na Fase 1, `0`) |
| `investido_marcado` | `periods.invested_amount` |
| `meta` | `ledgers.reserve_goal_type` e `reserve_goal_value` |

## Fórmulas

```
base            = renda + saldo_remanescente_anterior
reserva_meta    = meta.FIXED ? meta.valor : renda × meta.percentual
reserva_do_mes  = reserva_meta + compensacao_anterior

margem_do_mes   = base − fixos − parcelas − provisao − reserva_do_mes − parte_conjunta
excedente_aporte = max(0, aportes − reserva_do_mes)
margem_disponivel = margem_do_mes − variaveis − excedente_aporte

reserva_pendente = max(0, reserva_do_mes − aportes)      // quanto ainda falta guardar

-- fechamento (só para meses fechados) --
sobra = base − fixos − variaveis − parcelas − parte_conjunta − aportes − provisao
saldo_remanescente_proximo = max(0, sobra − investido_marcado)
compensacao_proxima        = margem_disponivel < 0 ? |margem_disponivel| : 0
investido_no_mes           = aportes + investido_marcado
```

Regras complementares (decididas na documentação técnica, confirmar se mudar o PRD):

- `investido_marcado` não pode passar de `max(0, sobra)`. A API recusa com `INVESTED_EXCEEDS_SURPLUS`.
- Sobra negativa não vira saldo remanescente negativo; o estouro já é cobrado pela compensação (RF-75).
- O primeiro período começa com `saldo_remanescente_anterior = 0` e `compensacao_anterior = 0`.
- O mês aberto mostra os mesmos números "até agora"; sobra e saldo remanescente só valem depois da virada.
- Arredondamento só no resultado final de cada termo (2 casas, meio para cima).

## Encadeamento

`calculatePeriods(periods[], entriesByPeriod, ledgerSettings) → PeriodResult[]` percorre os meses em ordem, levando `saldo_remanescente` e `compensacao` adiante. Editar qualquer lançamento de um mês fechado muda automaticamente os meses seguintes (RF-79e), porque nada calculado é salvo ([ADR-0007](adr/0007-mes-financeiro-por-periodos.md)).

## Casos de teste obrigatórios

1. **Exemplo do PRD:** renda 5.000, saldo anterior 200, fixos 2.000, parcelas 600, provisão 200, meta 10% → `reserva_do_mes = 500`, `margem_do_mes = 1.900,00`. (Na Fase 1, testar o motor passando parcelas e provisão como entrada.)
2. **Estouro:** margem disponível −150 → o mês seguinte tem `reserva_do_mes = meta + 150`.
3. **Aporte dentro da meta:** meta 500, aporte 300 → margem disponível não muda; reserva pendente 200.
4. **Aporte acima da meta:** meta 500, aporte 800 → margem disponível cai 300.
5. **Fixa "a confirmar":** usa o valor de referência; ao confirmar com outro valor, a margem muda.
6. **Edição retroativa:** um gasto a mais no mês 1 reduz o saldo remanescente do mês 2 e a base do mês 2.
7. **Meta fixa vs percentual**, e meta percentual com renda zero.
8. **Investido marcado maior que a sobra** é recusado.

## Lembretes calculados na leitura (Fase 1)

- `fixas_pendentes_ha_mais_de_3_dias`: existe lançamento `PENDING` no mês aberto e hoje ≥ `start_date + 3 dias` (RF-29d).
- `mes_aberto_ha_mais_de_35_dias`: hoje ≥ `start_date + 35 dias` (RF-79c).

## Pontos em aberto

- Provisão sazonal (Fase 2): "meses restantes" estimados pelo calendário até a data prevista, com mínimo de 1.
- Parte da conta conjunta (Fase 3): em qual mês financeiro individual entra (PRD, seção 13, ponto 10).
