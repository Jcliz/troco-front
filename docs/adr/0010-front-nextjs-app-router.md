# ADR-0010: Front em Next.js App Router, TanStack Query e next-intl

- **Status:** Aceito
- **Data:** 2026-11-23

## Contexto

PRD seção 11: Next.js, React, TypeScript, shadcn/ui. Toda regra fica na API.

## Decisão

- **Next.js (App Router)**, TypeScript `strict`, **Tailwind CSS** e **shadcn/ui**.
- Páginas autenticadas são *client-heavy*: dados buscados com **TanStack Query** pelo cliente tipado do OpenAPI. Server Components ficam para layout e páginas públicas.
- O `middleware.ts` só confere se existe o cookie de sessão para redirecionar ao login; quem valida de verdade é a API.
- Formulários: **react-hook-form** + **zod** (os esquemas espelham as regras da API, como a política de senha).
- **next-intl** desde o primeiro dia, com rotas `/[locale]/...` e só `pt-BR` na Fase 1 (RNF-07). Nenhum texto fixo em componente.
- PWA (Fase 3) com manifesto e service worker.
- Ícones: `lucide-react` (padrão do shadcn).

## Consequências

- O visual final depende da fase de design (`DESIGN.md`). Até lá, as telas usam o tema padrão do shadcn e são ajustadas depois.
