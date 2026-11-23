# ADR-0001: Registrar decisões em ADRs

- **Status:** Aceito
- **Data:** 2026-11-23

## Contexto

Quase todo o código do troco será escrito pelo Claude Code e revisado pelo João. Cada sessão do agente começa sem memória, então as decisões precisam estar escritas onde o agente lê.

## Decisão

Toda decisão técnica relevante vira um ADR curto em `docs/adr/`, numerado e imutável. Mudança de decisão gera um ADR novo que substitui o anterior.

## Consequências

- O CLAUDE.md aponta para cá; o agente consulta os ADRs antes de propor algo que contrarie uma decisão.
- Um PR que muda uma decisão precisa incluir o ADR novo.
