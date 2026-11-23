---
name: new-screen
description: Cria uma tela nova do troco-front no padrão do projeto (rota no App Router, feature, hooks de dados, textos e testes). Use ao começar qualquer tela da seção 9 do PRD.
---

# Nova tela

1. Rota em `src/app/[locale]/(app)/<rota-em-português>/page.tsx` (rotas em português, como `lancamentos`, `configuracoes`; código interno em inglês).
2. Pasta `src/features/<dominio>/` (nome em inglês, conforme o glossário):
   ```
   api.ts               # hooks useQuery/useMutation + query keys
   components/          # componentes da tela
   schemas.ts           # zod dos formulários
   <componente>.test.tsx
   ```
3. Textos em `messages/pt-BR.json` sob a chave da tela.
4. Item de navegação no layout `(app)` se a tela for de primeiro nível.
5. Estados: carregando (skeleton), vazio (com chamada para ação), erro (mensagem pelo `code` + tentar de novo).
6. Conferir em 360 px e desktop; teclado e foco.
