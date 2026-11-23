# ADR-0004: Hospedagem v1 na Vercel + Neon, domínio `*.vercel.app`

- **Status:** Aceito
- **Data:** 2026-11-23

## Contexto

A v1 é para um grupo pequeno e precisa ser gratuita (PRD, seção 11). Não haverá domínio próprio por enquanto (PRD, seção 13, ponto 9).

## Decisão

- Front e API são dois projetos na Vercel (plano Hobby), com os domínios gratuitos `troco-front.vercel.app` e `troco-api.vercel.app` (nomes finais definidos ao criar os projetos).
- A API roda como função serverless (suporte nativo da Vercel ao NestJS).
- Banco no Neon (plano gratuito), com uma *branch* do Neon por deploy de preview e a branch principal para produção.
- Conexão com o banco pela URL com *pooling* do Neon (`DATABASE_URL`) e URL direta para migrações (`DIRECT_URL`).

## Consequências

- Serverless: nada de estado em memória entre requisições (ex.: limite de tentativas de login fica no banco, [ADR-0005](0005-autenticacao-sessao-em-cookie.md)).
- *Cold start* aceitável para o público da v1.
- Quando houver domínio próprio, a troca é de configuração (variáveis `APP_URL`, `API_URL`, remetente de e-mail).
- Migração para infraestrutura própria é ponto da v2.
