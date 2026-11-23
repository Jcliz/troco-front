---
paths:
  - "src/components/**"
  - "src/features/**"
  - "src/app/**"
---

# Componentes e telas

- Antes de criar um componente, procure em `src/components/ui` (shadcn) e `src/components`. Componente do shadcn que falta: `pnpm dlx shadcn@latest add <nome>`.
- Edite `src/components/ui` só para ajustes de tema; comportamento novo vai num componente do troco que envolve o do shadcn.
- Componente de domínio vive em `src/features/<dominio>/components`; genérico e reaproveitável em `src/components`.
- Server Components por padrão em layouts e páginas públicas; `'use client'` só onde há estado, efeito ou TanStack Query.
- Mobile first: comece em 360 px e expanda com `md:`/`lg:`. Formulários longos no celular abrem em `Sheet`.
- Acessibilidade: todo campo com `Label`, ícone sozinho com `aria-label`, foco visível, cor nunca é a única informação (alertas também têm texto/ícone, RF-62).
- Cores e espaçamentos só por tokens do tema (classes do Tailwind ligadas às variáveis do shadcn), nada de hex solto. Visual definitivo virá do `DESIGN.md`.
