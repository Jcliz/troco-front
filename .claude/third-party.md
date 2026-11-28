# Skills e plugins de terceiros

Skills copiadas de repositórios públicos depois de auditadas (SKILL.md, referências, scripts e hooks lidos em busca de instruções maliciosas, envio de dados e comandos perigosos). Os arquivos estão **idênticos ao original** no commit indicado. Para atualizar, copie de novo a partir do repositório de origem e audite o diff antes do commit.

Auditoria feita em 2026-11-23.

## Skills copiadas para `.claude/skills/`

| Skill | Origem (commit) | Licença | Observações |
|---|---|---|---|
| `tlc-spec-driven` | [tech-leads-club/agent-skills](https://github.com/tech-leads-club/agent-skills) `d0c46bf`, pasta `packages/skills-catalog/skills/(development)/tlc-spec-driven` | MIT (catálogo) / CC-BY-4.0 (skill, autor Felipe Rodrigues) | Scripts Python locais de validação; `check_proofs.py` executa os comandos de prova escritos na própria spec. Sem rede. |
| `grill-me` e `grilling` | [mattpocock/skills](https://github.com/mattpocock/skills) `abeeaf9`, pastas `skills/productivity/grill-me` e `skills/productivity/grilling` | MIT | Só texto. `grill-me` só roda quando chamada (`/grill-me`) e carrega `grilling`. Ficou de fora `grill-with-docs`: ela usa a skill `domain-modeling`, que cria `GLOSSARY.md` na raiz e ADRs num formato próprio, em conflito com `docs/adr/` e o glossário de `docs/conventions.md`. |
| Skills do Emil Kowalski: `apple-design`, `emil-design-eng`, `animate`, `animation-performance`, `choreograph`, `review-animations`, `break-ui`, `ask-sonner`, `learn-taste` | [emilkowalski/skills](https://github.com/emilkowalski/skills) `64eb3de` | MIT | Só texto. `apple-design` e `emil-design-eng` são as que deixam o agente crítico com padrões de design e entram em toda tarefa de tela (veja o `CLAUDE.md`). `learn-taste` (só por `/learn-taste`) transforma as correções de design do João em regras no `DESIGN.md`. |

### Removidas em 28/11/2026

Para o agente não escolher entre skills que se sobrepõem ou que puxam contra o `DESIGN.md`, saíram: `frontend-design` (busca uma direção estética nova, e o design já está decidido), `impeccable` e os 5 subagentes `impeccable-*` (refaz direção e reescreve o `DESIGN.md`), `ip-as-logo` (o logo está pronto), e do Emil `ask-emil`, `animation-vocabulary`, `find-animation-opportunities`, `improve-animations`, `remove-animations`, `gestures`, `pick-ui-library` e `prototype` (o movimento, a biblioteca de componentes e o protótipo já estão decididos). Para trazer alguma de volta, copie de novo do commit indicado e audite.

## Plugins habilitados em `settings.json`

O Claude Code pergunta se você quer instalar estes plugins ao abrir o repositório.

| Plugin | Marketplace | Observações |
|---|---|---|
| `superpowers` | `claude-plugins-official` (aponta para [obra/superpowers](https://github.com/obra/superpowers) `22f0b46`) | Tem hook de início de sessão que injeta a skill `using-superpowers`. As regras do `CLAUDE.md`/`AGENTS.md` continuam valendo acima dela. |
| `claude-code-setup` | `claude-plugins-official` ([anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official)) | Skill `claude-automation-recommender`, só leitura. |
| `cartographer` | `cartographer-marketplace` ([kingbootoshi/cartographer](https://github.com/kingbootoshi/cartographer) `a62d169`) | Script Python local que conta tokens. Grava `docs/CODEBASE_MAP.md` e edita o `CLAUDE.md`: como `docs/` é espelhada no troco-api, rode só se quiser o mapa nos dois repos. |

## MCP em `.mcp.json`

| Servidor | Origem | Observações |
|---|---|---|
| `playwright` | [`@playwright/mcp`](https://github.com/microsoft/playwright-mcp) (Microsoft) | Versão fixada em `0.0.84` para não puxar uma publicação nova sem revisão. |

O MCP do Figma já está conectado na conta do claude.ai e aparece no Claude Code sem configuração no repositório.
