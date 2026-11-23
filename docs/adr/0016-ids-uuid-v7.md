# ADR-0016: IDs UUID v7

- **Status:** Aceito
- **Data:** 2026-11-23

## Decisão

Chaves primárias `uuid`, geradas como UUID v7 pelo Prisma (`@default(uuid(7))`). São ordenáveis pelo tempo (bom para paginação por cursor e índices) e não expõem quantidade de registros.

## Consequências

- Cursores de paginação usam o próprio ID.
