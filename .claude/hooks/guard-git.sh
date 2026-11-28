#!/usr/bin/env bash
# Barra comandos de git que quebram .claude/rules/git.md:
# assinatura de agente no commit e branch com prefixo de ferramenta.
# Sai com 2 para o Claude Code bloquear o comando e mostrar o motivo.
set -u
input="$(cat)"
cmd="$(printf '%s' "$input" | node -e 'let d="";process.stdin.on("data",c=>d+=c).on("end",()=>{try{const j=JSON.parse(d);process.stdout.write((j.tool_input&&j.tool_input.command)||"")}catch{}})' 2>/dev/null)"
[ -z "$cmd" ] && exit 0
case "$cmd" in *git*) ;; *) exit 0 ;; esac

if printf '%s' "$cmd" | grep -Eq 'git[^|;&]*[[:space:]]commit' &&
   printf '%s' "$cmd" | grep -Eiq 'co-authored-by|claude-session|generated (with|by) \[?claude code|noreply@anthropic\.com'; then
  echo "Bloqueado: o commit tem assinatura de agente (Co-Authored-By, Claude-Session ou 'Generated with Claude Code'). O autor é só o João; tire essas linhas (.claude/rules/git.md)." >&2
  exit 2
fi

if printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+(switch[[:space:]]+(-c|-C|--create)|checkout[[:space:]]+(-b|-B)|branch|push)[^|;&]*[[:space:]:](origin[[:space:]]+)?(claude|codex|copilot)/'; then
  echo "Bloqueado: branch com prefixo de ferramenta. Use <tipo>/<resumo-em-inglês>, ex.: feat/api-07-month-turnover (.claude/rules/git.md)." >&2
  exit 2
fi
exit 0
