---
paths:
  - "**/*.test.ts"
  - "**/*.test.tsx"
  - "e2e/**"
---

# Testes

- Componente com lógica (formulário, regra de exibição) → teste em Vitest + Testing Library ao lado do arquivo (`*.test.tsx`). Busque por papel e rótulo (`getByRole`, `getByLabelText`), não por classe.
- Mock da API com MSW nos testes de componente.
- Ponta a ponta em `e2e/` com Playwright, contra API real: cadastro, lançamento, virada do mês, revisão das fixas, recuperação de senha (Mailpit).
- Nome do teste em inglês, descrevendo comportamento.
- Proibido `.skip`, `.only` commitado ou afrouxar asserção para passar.
