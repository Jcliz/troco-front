# Skills e plugins de terceiros

Skills copiadas de repositórios públicos depois de auditadas (SKILL.md, referências, scripts e hooks lidos em busca de instruções maliciosas, envio de dados e comandos perigosos). Os arquivos estão **idênticos ao original** no commit indicado. Para atualizar, copie de novo a partir do repositório de origem e audite o diff antes do commit.

Auditoria feita em 2026-11-23.

## Skills copiadas para `.claude/skills/`

| Skill | Origem (commit) | Licença | Observações |
|---|---|---|---|
| `tlc-spec-driven` | [tech-leads-club/agent-skills](https://github.com/tech-leads-club/agent-skills) `d0c46bf`, pasta `packages/skills-catalog/skills/(development)/tlc-spec-driven` | MIT (catálogo) / CC-BY-4.0 (skill, autor Felipe Rodrigues) | Scripts Python locais de validação; `check_proofs.py` executa os comandos de prova escritos na própria spec. Sem rede. |
| `frontend-design` | [anthropics/skills](https://github.com/anthropics/skills) `e4bb5d9` (a mesma do skills.sh e do plugin oficial) | Apache-2.0 | Só texto. |
| `impeccable` (+ 5 subagentes `impeccable-*` em `.claude/agents/`) | [pbakaus/impeccable](https://github.com/pbakaus/impeccable) `b49177d`, pasta `.claude/` | Apache-2.0 | O script `scripts/impeccable` baixa o binário do detector das Releases do GitHub do próprio projeto e confere o SHA-256 contra `engine-checksums.txt`. Os hooks automáticos do projeto (rodam o binário a cada edição) **não** foram instalados. O modo `live` pode chamar `claude --permission-mode bypassPermissions`: use `IMPECCABLE_LIVE_COPY_AGENT=chat` ao usar o modo live. O login (`npx impeccable login`) é opcional e envia critiques para a conta Impeccable; não é necessário. |
| `ip-as-logo` | [s1dashu/ip-as-logo-skill](https://github.com/s1dashu/ip-as-logo-skill) `6e808f3` | MIT | Só texto. Precisa de um modelo de imagem externo (GPT Image, Nano Banana) e pede a chave quando for usar. |
| Skills do Emil Kowalski: `animate`, `animation-performance`, `animation-vocabulary`, `apple-design`, `ask-emil`, `ask-sonner`, `break-ui`, `choreograph`, `emil-design-eng`, `find-animation-opportunities`, `gestures`, `improve-animations`, `learn-taste`, `pick-ui-library`, `prototype`, `remove-animations`, `review-animations` | [emilkowalski/skills](https://github.com/emilkowalski/skills) `64eb3de` | MIT | Só texto. Ficaram de fora `animate-expo`, `mobile-native` e `write-swift` (React Native/iOS, fora da stack). |

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
