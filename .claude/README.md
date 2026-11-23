# Pasta .claude

Configuração do Claude Code para este repositório. Visão geral e fluxo de trabalho no [CLAUDE.md](../CLAUDE.md).

- `settings.json`: permissões e hooks compartilhados (versionado). Preferências pessoais vão em `settings.local.json` (ignorado pelo Git).
- `hooks/`: scripts chamados pelos hooks.
- `rules/`: regras por caminho de arquivo (campo `paths` no topo de cada arquivo).
- `agents/`: subagentes (revisão, testes).
- `skills/`: procedimentos reutilizáveis, chamados por `/nome-da-skill`.
- `third-party.md`: skills, plugins e MCPs de terceiros instalados, com origem, commit auditado e cuidados de uso.
